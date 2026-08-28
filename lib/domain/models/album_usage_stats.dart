import 'package:isar/isar.dart';

part 'album_usage_stats.g.dart';

/// Tracks how often each album is opened for prefetch prioritization.
@collection
class AlbumUsageStats {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String albumId;

  int openCount = 0;
  DateTime lastOpenedAt = DateTime.fromMillisecondsSinceEpoch(0);
}
