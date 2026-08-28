import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import 'pin_service.dart';

/// Migrates legacy 6-digit PINs to the fixed 4-digit schema.
class PinMigrationService {
  PinMigrationService({PinService? pinService})
      : _pinService = pinService ?? PinService();

  final PinService _pinService;

  Future<void> migrateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getInt(AppConstants.prefPinSchemaVersion) ?? 1;
    if (version >= AppConstants.currentPinSchemaVersion) return;

    if (await _pinService.isPinSet()) {
      await _pinService.clearPin();
      await prefs.setBool(AppConstants.prefForcePinReset, true);
    }

    await prefs.setInt(
      AppConstants.prefPinSchemaVersion,
      AppConstants.currentPinSchemaVersion,
    );
  }

  Future<bool> shouldForcePinReset() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefForcePinReset) ?? false;
  }

  Future<void> clearForcePinReset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefForcePinReset, false);
  }
}
