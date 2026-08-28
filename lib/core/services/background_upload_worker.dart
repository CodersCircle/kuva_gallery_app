import 'package:workmanager/workmanager.dart';

import '../constants/app_constants.dart';
import '../../data/repositories/upload_repository.dart';

/// Workmanager callback dispatcher for background uploads.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == AppConstants.uploadTaskName) {
      final repo = UploadRepository();
      await repo.processQueue();
      return true;
    }
    return false;
  });
}
