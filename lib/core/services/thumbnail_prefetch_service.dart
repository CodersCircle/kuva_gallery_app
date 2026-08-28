import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../data/datasources/photo_manager_datasource.dart';
import '../../domain/models/album_model.dart';
import 'album_usage_service.dart';
import 'thumbnail_cache_service.dart';

/// Background thumbnail warmer — low priority, concurrency-capped.
class ThumbnailPrefetchService {
  ThumbnailPrefetchService._();
  static final ThumbnailPrefetchService instance =
      ThumbnailPrefetchService._();

  static const _assetsPerAlbum = 50;
  static const _scrollAheadCount = 20;
  var _warming = false;

  /// Warm ~50 most recent assets per album after album list loads.
  Future<void> warmAlbumsInBackground(List<AlbumModel> albums) async {
    if (_warming || albums.isEmpty) return;
    _warming = true;

    try {
      final orderedIds =
          await AlbumUsageService.instance.prioritizedAlbumIds(albums);
      final byId = {for (final a in albums) a.id: a};

      for (final albumId in orderedIds) {
        final album = byId[albumId];
        if (album == null || album.assetCount == 0) continue;
        await _warmAlbum(album);
        await Future<void>.delayed(const Duration(milliseconds: 80));
      }
    } finally {
      _warming = false;
    }
  }

  Future<void> warmAlbumOnOpen(AlbumModel album) async {
    unawaited(_warmAlbum(album, limit: _assetsPerAlbum));
  }

  /// Prefetch thumbnails for assets just below the current scroll position.
  Future<void> prefetchScrollAhead({
    required List<AssetEntity> visibleAssets,
    required List<AssetEntity> allAssets,
    required int lastVisibleIndex,
  }) async {
    if (allAssets.isEmpty) return;
    final start = (lastVisibleIndex + 1).clamp(0, allAssets.length);
    final end = (start + _scrollAheadCount).clamp(0, allAssets.length);
    if (start >= end) return;

    final size = thumbnailSizeForColumns(4);
    for (var i = start; i < end; i++) {
      final entity = allAssets[i];
      if (visibleAssets.any((a) => a.id == entity.id)) continue;
      unawaited(
        ThumbnailCacheService.instance.loadThumbnail(
          entity,
          size,
          priority: ThumbnailPriority.low,
        ),
      );
    }
  }

  Future<void> _warmAlbum(AlbumModel album, {int limit = _assetsPerAlbum}) async {
    final count = album.assetCount;
    if (count == 0) return;

    final fetchCount = count < limit ? count : limit;
    final sorted = PhotoManagerDatasource.sortNewestFirst(album.assetPath);
    final entities =
        await sorted.getAssetListRange(start: 0, end: fetchCount);
    final size = thumbnailSizeForColumns(4);

    if (kDebugMode) {
      debugPrint(
        'ThumbnailPrefetchService: warming ${entities.length} thumbs '
        'for ${album.name}',
      );
    }

    for (final entity in entities) {
      await ThumbnailCacheService.instance.loadThumbnail(
        entity,
        size,
        priority: ThumbnailPriority.low,
      );
    }
  }
}
