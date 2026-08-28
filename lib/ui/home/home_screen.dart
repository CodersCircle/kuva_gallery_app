import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/pin_service.dart';
import '../../core/errors/vault_hide_exception.dart';
import '../../core/services/album_usage_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utils/file_utils.dart';
import '../../domain/models/album_model.dart';
import '../../providers/app_providers.dart';
import '../widgets/album_cover_thumbnail.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/hide_confirm_dialog.dart';
import '../widgets/locked_album_placeholder.dart';
import '../widgets/shimmer_box.dart';

/// Home screen — fixed 3-column album grid.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);
    final appLockOn = ref.watch(appLockEnabledProvider);
    final isLocked = ref.watch(appLockedProvider);

    if (appLockOn && isLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/pin-entry', extra: {'onSuccess': '/'});
        }
      });
    }

    ref.listen<AsyncValue<bool>>(forcePinResetProvider, (prev, next) {
      next.whenData((force) {
        if (!force || !context.mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted) return;
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: const Text('PIN update required'),
              content: const Text(
                'Kuva Gallery now uses a 4-digit PIN. Please set a new PIN to continue.',
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/pin-setup');
                  },
                  child: const Text('Set new PIN'),
                ),
              ],
            ),
          );
        });
      });
    });

    final aspectRatio = homeAlbumAspectRatio(MediaQuery.sizeOf(context).width);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: const Text('Kuva Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () => context.push('/vault'),
            tooltip: 'Vault',
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined),
            onPressed: () => context.push('/backup'),
            tooltip: 'Backup',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: albumsAsync.when(
          data: (albums) {
            if (albums.isEmpty) {
              return const Center(
                child: Text('No albums found. Grant media permission.'),
              );
            }
            return RefreshIndicator(
              onRefresh: () => ref.refresh(albumsProvider.future),
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.sm),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: AppConstants.homeGridColumns,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: albums.length,
                itemBuilder: (context, index) =>
                    _AlbumCard(album: albums[index]),
              ),
            );
          },
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppConstants.homeGridColumns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: aspectRatio,
            ),
            itemCount: 9,
            itemBuilder: (_, __) => const ShimmerBox(),
          ),
          error: (e, _) => Center(child: Text('Failed to load albums: $e')),
        ),
      ),
    );
  }
}

class _AlbumCard extends ConsumerWidget {
  const _AlbumCard({required this.album});

  final AlbumModel album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLockedAsync = ref.watch(albumLockedProvider(album.id));
    final unlocked = ref.watch(unlockedAlbumsProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openAlbum(context, ref),
        onLongPress: () => _showAlbumMenu(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: isLockedAsync.when(
                data: (locked) {
                  final needsPin =
                      locked && !unlocked.contains(album.id);
                  if (needsPin) {
                    return const LockedAlbumPlaceholder();
                  }
                  return AlbumCoverThumbnail(
                    albumId: album.id,
                    albumPath: album.assetPath,
                    assetCount: album.assetCount,
                  );
                },
                loading: () => const ShimmerBox(),
                error: (_, __) => AlbumCoverThumbnail(
                  albumId: album.id,
                  albumPath: album.assetPath,
                  assetCount: album.assetCount,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.albumName(context),
                  ),
                  _AlbumMetaRow(album: album),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAlbum(BuildContext context, WidgetRef ref) async {
    final locked = await ref.read(albumLockedProvider(album.id).future);
    final unlocked = ref.read(unlockedAlbumsProvider);

    if (!AlbumAccessGuard.canNavigate(
      isLocked: locked,
      unlockedAlbumIds: unlocked,
      albumId: album.id,
    )) {
      if (!context.mounted) return;
      final ok = await context.push<bool>(
        '/pin-entry',
        extra: {
          'title': 'Unlock ${album.name}',
          'albumId': album.id,
          'popOnSuccess': true,
        },
      );
      if (ok != true) return;
    }

    if (!context.mounted) return;
    unawaited(AlbumUsageService.instance.recordOpen(album.id));
    context.push('/album/${album.id}', extra: album);
  }

  void _showAlbumMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: const Text('Hide entire album'),
              onTap: () {
                Navigator.pop(ctx);
                _hideAlbum(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Lock album'),
              onTap: () async {
                Navigator.pop(ctx);
                await _lockAlbum(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _lockAlbum(BuildContext context, WidgetRef ref) async {
    final pin = await _askPin(
      context,
      title: 'Set album PIN',
      subtitle: 'Enter a 4-digit PIN to lock this album',
    );
    if (pin == null || !PinService.isValidFormat(pin)) return;

    try {
      await ref.read(lockRepositoryProvider).lockAlbum(
            albumId: album.id,
            pin: pin,
          );
      ref.invalidate(albumLockedProvider(album.id));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Album locked')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not lock album: $e')),
        );
      }
    }
  }

  Future<void> _hideAlbum(BuildContext context, WidgetRef ref) async {
    final confirm = await confirmHideAlbum(context, albumName: album.name);
    if (!confirm || !context.mounted) return;

    final pin = await _askPin(context);
    if (pin == null) return;
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        title: Text('Hiding album…'),
        content: LinearProgressIndicator(),
      ),
    );
    try {
      await ref.read(vaultRepositoryProvider).hideAlbum(
            album: album,
            pin: pin,
          );
      ref.invalidate(albumsProvider);
      ref.invalidate(hiddenAssetIdsProvider);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Album hidden in Vault — originals kept on your device',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        final message = e is VaultHideException
            ? e.message
            : 'Hide failed — your original photos were not touched';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  Future<String?> _askPin(
    BuildContext context, {
    String title = 'Enter PIN to hide',
    String? subtitle,
  }) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null) ...[
              Text(subtitle),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: AppConstants.pinLength,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _AlbumMetaRow extends ConsumerWidget {
  const _AlbumMetaRow({required this.album});

  final AlbumModel album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeAsync = ref.watch(albumSizeProvider(album));
    final countLabel = '${album.assetCount} items';
    return sizeAsync.when(
      data: (size) => Text(
        '$countLabel · ${FileUtils.formatBytes(size)}',
        style: AppTextStyles.albumMeta(context),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      loading: () => Text(countLabel, style: AppTextStyles.albumMeta(context)),
      error: (_, __) =>
          Text(countLabel, style: AppTextStyles.albumMeta(context)),
    );
  }
}
