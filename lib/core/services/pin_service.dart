import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// PIN hashing and verification using SHA-256 + random salt.
class PinService {
  PinService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static bool isValidFormat(String pin) {
    return pin.length == AppConstants.pinLength &&
        RegExp(r'^\d+$').hasMatch(pin);
  }

  Future<bool> isPinSet() async {
    final value = await _storage.read(key: AppConstants.securePinSet);
    return value == 'true';
  }

  Future<void> setPin(String pin) async {
    _validatePin(pin);
    final salt = generateSalt();
    final hash = hashPinWithSalt(pin, salt);
    await _storage.write(key: AppConstants.securePinSalt, value: salt);
    await _storage.write(key: AppConstants.securePinHash, value: hash);
    await _storage.write(key: AppConstants.securePinSet, value: 'true');
  }

  Future<bool> verifyPin(String pin) async {
    if (!isValidFormat(pin)) return false;
    final salt = await _storage.read(key: AppConstants.securePinSalt);
    final storedHash = await _storage.read(key: AppConstants.securePinHash);
    if (salt == null || storedHash == null) return false;
    return hashPinWithSalt(pin, salt) == storedHash;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: AppConstants.securePinSalt);
    await _storage.delete(key: AppConstants.securePinHash);
    await _storage.delete(key: AppConstants.securePinSet);
  }

  /// Hash PIN with salt — exposed for unit tests and album-level locks.
  static String hashPinWithSalt(String pin, String salt) {
    final bytes = utf8.encode('$pin$salt');
    return sha256.convert(bytes).toString();
  }

  static String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  void _validatePin(String pin) {
    if (!isValidFormat(pin)) {
      throw ArgumentError(
        'PIN must be exactly ${AppConstants.pinLength} digits',
      );
    }
  }
}
