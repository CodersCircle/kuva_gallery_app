import 'package:isar/isar.dart';

part 'locked_album.g.dart';

/// Per-album lock configuration stored in Isar.
@collection
class LockedAlbum {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String albumId;

  /// SHA-256 hash of album PIN + salt.
  late String pinHash;
  late String pinSalt;

  /// If true, uses master app PIN instead of album-specific PIN.
  late bool useMasterPin;
}
