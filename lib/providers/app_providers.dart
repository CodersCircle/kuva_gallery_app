import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/services/album_cover_service.dart';
import '../core/services/thumbnail_prefetch_service.dart';
import '../core/services/biometric_service.dart';
import '../core/services/encryption_service.dart';
import '../core/services/hidden_albums_store.dart';
import '../core/services/pin_migration_service.dart';
import '../core/services/pin_service.dart';
import '../data/datasources/isar_database.dart';
import '../data/datasources/photo_manager_datasource.dart';
import '../data/repositories/album_repository.dart';
import '../data/repositories/upload_repository.dart';
import '../data/repositories/vault_repository.dart';
import '../domain/models/album_model.dart';
import '../domain/models/album_sort_mode.dart';
import '../domain/models/upload_queue_item.dart';

// ── Core services ──────────────────────────────────────────────────────────

final isarProvider = FutureProvider<Isar>((ref) => IsarDatabase.open());

final pinServiceProvider = Provider((ref) => PinService());
final biometricServiceProvider = Provider((ref) => BiometricService());
final encryptionServiceProvider = Provider((ref) => EncryptionService());

final photoDatasourceProvider = Provider((ref) => PhotoManagerDatasource());
final albumRepositoryProvider = Provider(
  (ref) => AlbumRepository(datasource: ref.watch(photoDatasourceProvider)),
);
final vaultRepositoryProvider = Provider((ref) => VaultRepository());
final lockRepositoryProvider = Provider((ref) => LockRepository());
final hiddenAlbumsStoreProvider = Provider((ref) => HiddenAlbumsStore());

final hiddenAssetIdsProvider = FutureProvider<Set<String>>((ref) async {
  return ref.watch(vaultRepositoryProvider).getHiddenAssetIds();
});
final uploadRepositoryProvider = Provider((ref) => UploadRepository());

// ── Albums ─────────────────────────────────────────────────────────────────

final albumCoverServiceProvider =
    Provider((ref) => AlbumCoverService.instance);

final albumsProvider = FutureProvider<List<AlbumModel>>((ref) async {
  final repo = ref.watch(albumRepositoryProvider);
  final datasource = ref.watch(photoDatasourceProvider);
  final sortMode = ref.watch(albumSortModeProvider);
  final permission = await datasource.requestPermission();
  if (!permission.hasAccess) return [];
  var albums = await repo.getAlbums();
  final hiddenAlbumIds =
      await ref.watch(hiddenAlbumsStoreProvider).getHiddenAlbumIds();
  albums = albums.where((a) => !hiddenAlbumIds.contains(a.id)).toList();

  switch (sortMode) {
    case AlbumSortMode.nameAsc:
      albums.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    case AlbumSortMode.nameDesc:
      albums.sort(
        (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      );
    case AlbumSortMode.recentlyUpdated:
      final withDates = <AlbumModel>[];
      for (final album in albums) {
        final modified = await datasource.getAlbumLastModified(album.assetPath);
        withDates.add(album.copyWith(lastModified: modified));
      }
      withDates.sort((a, b) {
        final ad = a.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });
      albums = withDates;
    case AlbumSortMode.size:
      albums.sort((a, b) => b.assetCount.compareTo(a.assetCount));
  }

  unawaited(
    ref.read(albumCoverServiceProvider).preloadCovers(
          albums
              .map((a) => (id: a.id, path: a.assetPath))
              .toList(),
        ),
  );
  _scheduleThumbnailWarm(albums);
  return albums;
});

/// Kicks off low-priority background thumbnail warming after albums load.
void _scheduleThumbnailWarm(List<AlbumModel> albums) {
  unawaited(
    ThumbnailPrefetchService.instance.warmAlbumsInBackground(albums),
  );
}

/// Stable per-album cover future — survives card rebuilds (#Step 1 fix).
final albumCoverProvider =
    FutureProvider.family<Uint8List?, String>((ref, albumId) async {
  final albums = await ref.watch(albumsProvider.future);
  AlbumModel? album;
  for (final a in albums) {
    if (a.id == albumId) {
      album = a;
      break;
    }
  }
  if (album == null || album.assetCount == 0) return null;
  return ref.read(albumCoverServiceProvider).getAlbumCoverThumbnail(
        album.assetPath,
        album.id,
      );
});

/// Stable lock check — inline FutureProvider was recreating every rebuild (#Step 1).
final albumLockedProvider = FutureProvider.family<bool, String>((ref, albumId) {
  return ref.read(lockRepositoryProvider).isAlbumLocked(albumId);
});

final albumSizeProvider =
    FutureProvider.family<int, AlbumModel>((ref, album) async {
  return ref.watch(albumRepositoryProvider).getAlbumSize(album);
});

// ── App lock (opt-in via Settings) ─────────────────────────────────────────

final appLockEnabledProvider =
    StateNotifierProvider<AppLockEnabledNotifier, bool>((ref) {
  return AppLockEnabledNotifier();
});

class AppLockEnabledNotifier extends StateNotifier<bool> {
  AppLockEnabledNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(AppConstants.prefAppLockEnabled) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefAppLockEnabled, enabled);
  }
}

/// Only true when app lock is enabled AND user hasn't unlocked this session.
final appLockedProvider = StateProvider<bool>((ref) => false);
// ── Album grid density (pinch-to-zoom, persisted per album) ──────────────────

final albumGridColumnsProvider =
    StateNotifierProvider.family<AlbumGridNotifier, int, String>((ref, albumId) {
  return AlbumGridNotifier(albumId);
});

class AlbumGridNotifier extends StateNotifier<int> {
  AlbumGridNotifier(this.albumId) : super(4) {
    _load();
  }

  final String albumId;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('${AppConstants.prefAlbumGridColumns}_$albumId') ?? 4;
  }

  Future<void> setColumns(int columns) async {
    state = columns.clamp(AppConstants.albumGridMin, AppConstants.albumGridMax);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${AppConstants.prefAlbumGridColumns}_$albumId', state);
  }
}

final unlockedAlbumsProvider = StateProvider<Set<String>>((ref) => {});

final lockTimeoutProvider = FutureProvider<int>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(AppConstants.prefLockTimeoutMinutes) ?? 5;
});

// ── Upload queue ───────────────────────────────────────────────────────────

final uploadQueueProvider =
    StateNotifierProvider<UploadQueueNotifier, List<UploadQueueItem>>((ref) {
  return UploadQueueNotifier(ref.watch(uploadRepositoryProvider));
});

class UploadQueueNotifier extends StateNotifier<List<UploadQueueItem>> {
  UploadQueueNotifier(this._repo) : super([]) {
    refresh();
  }

  final UploadRepository _repo;

  Future<void> refresh() async {
    state = await _repo.getQueue();
  }

  Future<void> processQueue() async {
    await _repo.processQueue(
      onItemUpdate: (item) {
        state = [...state];
      },
    );
    await refresh();
  }
}

// ── Theme ──────────────────────────────────────────────────────────────────

final themeModeProvider = StateNotifierProvider<AppThemeModeNotifier, AppThemeMode>(
  (ref) => AppThemeModeNotifier(),
);

enum AppThemeMode { system, light, dark }

class AppThemeModeNotifier extends StateNotifier<AppThemeMode> {
  AppThemeModeNotifier() : super(AppThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(AppConstants.prefThemeMode) ?? 0;
    state = AppThemeMode.values[index];
  }

  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefThemeMode, mode.index);
  }
}

// ── PIN setup check ────────────────────────────────────────────────────────

final pinSetupProvider = FutureProvider<bool>((ref) async {
  return ref.watch(pinServiceProvider).isPinSet();
});

final forcePinResetProvider = FutureProvider<bool>((ref) async {
  return PinMigrationService().shouldForcePinReset();
});

// ── Album sort ─────────────────────────────────────────────────────────────

final albumSortModeProvider =
    StateNotifierProvider<AlbumSortModeNotifier, AlbumSortMode>((ref) {
  return AlbumSortModeNotifier();
});

class AlbumSortModeNotifier extends StateNotifier<AlbumSortMode> {
  AlbumSortModeNotifier() : super(AlbumSortMode.nameAsc) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(AppConstants.prefAlbumSortMode) ?? 0;
    state = AlbumSortMode.values[index.clamp(0, AlbumSortMode.values.length - 1)];
  }

  Future<void> setMode(AlbumSortMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefAlbumSortMode, mode.index);
  }
}

// ── Video playback ─────────────────────────────────────────────────────────

final autoPlayNextVideoProvider =
    StateNotifierProvider<AutoPlayNextVideoNotifier, bool>((ref) {
  return AutoPlayNextVideoNotifier();
});

class AutoPlayNextVideoNotifier extends StateNotifier<bool> {
  AutoPlayNextVideoNotifier() : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(AppConstants.prefAutoPlayNextVideo) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefAutoPlayNextVideo, enabled);
  }
}
