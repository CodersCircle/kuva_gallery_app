import 'package:isar/isar.dart';

part 'upload_queue_item.g.dart';

enum UploadStatus { queued, uploading, done, failed, cancelled }

/// Background upload queue entry.
@collection
class UploadQueueItem {
  Id id = Isar.autoIncrement;

  late String localPath;
  late String fileName;
  late String albumId;
  late String cloudTargetId;

  @Enumerated(EnumType.name)
  late UploadStatus status;

  late int retryCount;
  late double progress;
  late String? errorMessage;
  late DateTime createdAt;
  late DateTime? completedAt;

  /// Upload encrypted vault blob without decrypting.
  late bool isVaultItem;
}
