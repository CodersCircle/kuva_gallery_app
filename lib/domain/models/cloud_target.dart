import 'package:isar/isar.dart';

part 'cloud_target.g.dart';

enum CloudProvider { googleDrive, cloudinary, s3 }

/// Saved cloud storage connection credentials.
@collection
class CloudTarget {
  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  late CloudProvider provider;

  late String displayName;
  late bool isConnected;
  late bool backupVault;

  // Provider-specific config stored as JSON string
  late String configJson;
  late DateTime? lastSyncAt;
}
