import 'package:isar/isar.dart';

part 'album_cover_cache.g.dart';

/// Persisted album cover thumbnail bytes for instant re-open (#Step 3).
@collection
class AlbumCoverCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String albumId;

  late List<int> bytes;
}
