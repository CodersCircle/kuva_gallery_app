import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'album_view/album_screen.dart';
import 'backup/backup_screen.dart';
import 'backup/cloud_settings_screen.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import 'vault/pin_entry_screen.dart';
import 'vault/pin_setup_screen.dart';
import 'vault/vault_screen.dart';
import '../domain/models/media_asset.dart';
import 'viewer/media_viewer_screen.dart';

/// Fade+scale page transition — premium feel vs default slide (#7).
CustomTransitionPage<void> _fadeScalePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// App router configuration.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            _fadeScalePage(key: state.pageKey, child: const HomeScreen()),
      ),
      GoRoute(
        path: '/pin-setup',
        pageBuilder: (context, state) =>
            _fadeScalePage(key: state.pageKey, child: const PinSetupScreen()),
      ),
      GoRoute(
        path: '/pin-entry',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return _fadeScalePage(
            key: state.pageKey,
            child: PinEntryScreen(
              title: extra?['title'] as String? ?? 'Enter PIN',
              albumId: extra?['albumId'] as String?,
              onSuccessRoute: extra?['onSuccess'] as String? ?? '/',
              popOnSuccess: extra?['popOnSuccess'] as bool? ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: '/album/:id',
        pageBuilder: (context, state) {
          final album = state.extra as dynamic;
          return _fadeScalePage(
            key: state.pageKey,
            child: AlbumScreen(album: album),
          );
        },
      ),
      GoRoute(
        path: '/viewer',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return _fadeScalePage(
            key: state.pageKey,
            child: MediaViewerScreen(
              assets: (extra['assets'] as List).cast<MediaAsset>(),
              initialIndex: extra['index'] as int? ?? 0,
            ),
          );
        },
      ),
      GoRoute(
        path: '/vault',
        pageBuilder: (context, state) =>
            _fadeScalePage(key: state.pageKey, child: const VaultScreen()),
      ),
      GoRoute(
        path: '/backup',
        pageBuilder: (context, state) =>
            _fadeScalePage(key: state.pageKey, child: const BackupScreen()),
      ),
      GoRoute(
        path: '/cloud-settings',
        pageBuilder: (context, state) => _fadeScalePage(
          key: state.pageKey,
          child: const CloudSettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _fadeScalePage(key: state.pageKey, child: const SettingsScreen()),
      ),
    ],
  );
});
