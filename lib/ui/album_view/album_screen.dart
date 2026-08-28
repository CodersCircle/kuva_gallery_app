import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/vault_hide_exception.dart';
import '../../core/services/share_service.dart';
import '../../core/services/thumbnail_prefetch_service.dart';
import '../../core/theme/spacing.dart';
import '../../data/datasources/photo_manager_datasource.dart';
import '../../domain/models/album_model.dart';
import '../../domain/models/media_asset.dart';
import '../../providers/app_providers.dart';
import '../widgets/locked_album_placeholder.dart';
import '../widgets/cached_asset_thumbnail.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/hide_confirm_dialog.dart';
import '../widgets/pinch_zoom_grid.dart';
import '../widgets/shimmer_box.dart';

/// Album asset grid with pinch-to-zoom, multi-select, and share.
class AlbumScreen extends ConsumerStatefulWidget {
  const AlbumScreen({super.key, required this.album});

  final AlbumModel album;

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen>
    with SingleTickerProviderStateMixin {
  final _datasource = PhotoManagerDatasource();
  final _scrollController = ScrollController();
  final _assets = <MediaAsset>[];
  final _selected = <String>{};
  var _page = 0;
  var _loading = false;
  var _hasMore = true;
  var _selectionMode = false;
  late AnimationController _zoomAnim;
  double _displayColumns = 4;
  int? _openStartedMs;
  var _loggedFirstFrame = false;
  var _lastPrefetchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _openStartedMs = DateTime.now().millisecondsSinceEpoch;
    _zoomAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyAccessAndLoad();
      unawaited(
        ThumbnailPrefetchService.instance.warmAlbumOnOpen(widget.album),
      );
    });
  }

  Future<void> _verifyAccessAndLoad() async {
    final locked =
        await ref.read(albumLockedProvider(widget.album.id).future);
    final unlocked = ref.read(unlockedAlbumsProvider);
    if (!AlbumAccessGuard.canNavigate(
      isLocked: locked,
      unlockedAlbumIds: unlocked,
      albumId: widget.album.id,
    )) {
      if (mounted) context.pop();
      return;
    }
    await _loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _zoomAnim.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients && _assets.isNotEmpty) {
      final columns = ref.read(albumGridColumnsProvider(widget.album.id));
      final offset = _scrollController.offset;
      final tileSize =
          (MediaQuery.sizeOf(context).width - AppSpacing.xs * 2) / columns;
      final row = (offset / (tileSize + 2)).floor();
      final lastVisible = ((row + 6) * columns).clamp(0, _assets.length - 1);
      if (lastVisible > _lastPrefetchedIndex) {
        _lastPrefetchedIndex = lastVisible;
        unawaited(
          ThumbnailPrefetchService.instance.prefetchScrollAhead(
            visibleAssets: const [],
            allAssets: _assets.map((a) => a.entity).toList(),
            lastVisibleIndex: lastVisible,
          ),
        );
      }
    }

    if (!_scrollController.hasClients || _loading || !_hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    _loading = true;
    final pageResult = await _datasource.getAssetsPaged(
      albumPath: widget.album.assetPath,
      albumId: widget.album.id,
      page: _page,
    );
    final hiddenIds = await ref.read(hiddenAssetIdsProvider.future);
    final visible = pageResult.items
        .where((a) => !hiddenIds.contains(a.id))
        .toList();
    if (!mounted) return;
    setState(() {
      _assets.addAll(visible);
      _page++;
      _hasMore = pageResult.hasMore;
      _loading = false;
    });

    if (!_loggedFirstFrame && _openStartedMs != null && _page == 1) {
      _loggedFirstFrame = true;
      final elapsed = DateTime.now().millisecondsSinceEpoch - _openStartedMs!;
      if (kDebugMode) {
        debugPrint(
          'AlbumScreen: first batch ready in ${elapsed}ms '
          '(${pageResult.items.length} assets, album=${widget.album.name})',
        );
      }
    }
  }

  void _onColumnsChanged(int columns) {
    ref
        .read(albumGridColumnsProvider(widget.album.id).notifier)
        .setColumns(columns);
    _zoomAnim.forward(from: 0);
    setState(() => _displayColumns = columns.toDouble());
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selected.clear();
    });
  }

  void _toggleSelection(MediaAsset asset) {
    setState(() {
      if (_selected.contains(asset.id)) {
        _selected.remove(asset.id);
        if (_selected.isEmpty) _selectionMode = false;
      } else {
        _selected.add(asset.id);
      }
    });
  }

  void _onTileTap(MediaAsset asset, int index) {
    if (_selectionMode) {
      _toggleSelection(asset);
      return;
    }
    context.push(
      '/viewer',
      extra: {'assets': _assets, 'index': index},
    );
  }

  void _onTileLongPress(MediaAsset asset) {
    if (!_selectionMode) {
      setState(() {
        _selectionMode = true;
        _selected.add(asset.id);
      });
      return;
    }
    _hideAsset(asset);
  }

  Future<void> _shareSelected() async {
    final entities = _assets
        .where((a) => _selected.contains(a.id))
        .map((a) => a.entity)
        .toList();
    await ShareService.instance.shareAssets(entities, context: context);
    _exitSelection();
  }

  @override
  Widget build(BuildContext context) {
    final columns = ref.watch(albumGridColumnsProvider(widget.album.id));
    if (_displayColumns.round() != columns) {
      _displayColumns = columns.toDouble();
    }
    final viewportHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text(
          _selectionMode
              ? '${_selected.length} selected'
              : widget.album.name,
        ),
        leading: IconButton(
          icon: Icon(_selectionMode ? Icons.close : Icons.arrow_back),
          onPressed: () {
            if (_selectionMode) {
              _exitSelection();
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          if (_selectionMode)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share selected',
              onPressed: _selected.isEmpty ? null : _shareSelected,
            )
          else
            IconButton(
              icon: const Icon(Icons.visibility_off_outlined),
              tooltip: 'Hide album',
              onPressed: () => _hideSelected(context),
            ),
        ],
      ),
      body: SafeArea(
        child: PinchZoomGrid(
          columns: columns,
          onColumnsChanged: _onColumnsChanged,
          child: AnimatedBuilder(
            animation: _zoomAnim,
            builder: (context, child) {
              final t = Curves.easeOut.transform(_zoomAnim.value);
              return Transform.scale(
                scale: 0.97 + (0.03 * t),
                child: Opacity(opacity: 0.88 + (0.12 * t), child: child),
              );
            },
            child: GridView.builder(
              controller: _scrollController,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              cacheExtent: viewportHeight * 1.5,
              padding: const EdgeInsets.all(AppSpacing.xs),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemCount: _assets.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _assets.length) {
                  return const ShimmerBox(borderRadius: 4);
                }
                final asset = _assets[index];
                final selected = _selected.contains(asset.id);
                return GestureDetector(
                  onTap: () => _onTileTap(asset, index),
                  onLongPress: () => _onTileLongPress(asset),
                  child: DecoratedBox(
                    decoration: selected
                        ? BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            ),
                          )
                        : const BoxDecoration(),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedAssetThumbnail(
                          asset: asset.entity,
                          columns: columns,
                          isVideo: asset.isVideo,
                        ),
                        if (_selectionMode)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white70,
                              size: 22,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _hideAsset(MediaAsset asset) async {
    final confirm = await confirmHideItem(context);
    if (!confirm) return;

    final pin = await _askPin(context);
    if (pin == null) return;
    try {
      await ref.read(vaultRepositoryProvider).hideAsset(
            entity: asset.entity,
            albumId: widget.album.id,
            albumName: widget.album.name,
            pin: pin,
          );
      setState(() {
        _assets.removeWhere((a) => a.id == asset.id);
        _selected.remove(asset.id);
      });
      ref.invalidate(albumsProvider);
      ref.invalidate(hiddenAssetIdsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hidden in Vault — original kept on device'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final message = e is VaultHideException
            ? e.message
            : 'Hide failed — your original photo was not touched';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  Future<void> _hideSelected(BuildContext context) async {
    final confirm =
        await confirmHideAlbum(context, albumName: widget.album.name);
    if (!confirm) return;

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
            album: widget.album,
            pin: pin,
          );
      ref.invalidate(albumsProvider);
      if (mounted) {
        Navigator.pop(context);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Album hidden')),
        );
      }
    } catch (e) {
      if (mounted) {
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

  Future<String?> _askPin(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter PIN'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: AppConstants.pinLength,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
