import 'package:isar/isar.dart';

import '../../data/datasources/isar_database.dart';
import '../../domain/models/album_model.dart';
import '../../domain/models/album_usage_stats.dart';

/// Records album open frequency for prefetch prioritization.
class AlbumUsageService {
  AlbumUsageService._();
  static final AlbumUsageService instance = AlbumUsageService._();

  Future<void> recordOpen(String albumId) async {
    final db = await IsarDatabase.open();
    final existing = await db.albumUsageStats
        .filter()
        .albumIdEqualTo(albumId)
        .findFirst();
    final row = existing ?? AlbumUsageStats()..albumId = albumId;
    row.openCount += 1;
    row.lastOpenedAt = DateTime.now();
    await db.writeTxn(() async {
      await db.albumUsageStats.put(row);
    });
  }

  /// Album ids sorted by open frequency (most opened first).
  Future<List<String>> prioritizedAlbumIds(List<AlbumModel> albums) async {
    final db = await IsarDatabase.open();
    final stats = await db.albumUsageStats.where().findAll();
    final counts = {for (final s in stats) s.albumId: s.openCount};
    final sorted = [...albums]
      ..sort((a, b) {
        final diff = (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0);
        if (diff != 0) return diff;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return sorted.map((a) => a.id).toList();
  }
}
