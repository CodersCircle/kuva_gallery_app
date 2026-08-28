import 'package:isar/isar.dart';

part 'hidden_item.g.dart';

/// Metadata for a file moved into the encrypted vault.
@collection
class HiddenItem {
  Id id = Isar.autoIncrement;

  @Index()
  late String originalAssetId;

  late String originalPath;
  late String albumId;
  late String albumName;
  late String encryptedPath;
  late String mimeType;
  late bool isVideo;
  late int originalSize;
  late DateTime hiddenAt;

  @Index()
  String? tag;
}
