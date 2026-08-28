import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import 'encryption_compute.dart';

/// AES-256 encryption for vault files. Key derived from PIN + salt.
/// All platform-channel work stays on the main isolate.
class EncryptionService {
  EncryptionService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final _uuid = const Uuid();

  Future<enc.Key> deriveKey(String pin) => _deriveKey(pin);

  /// Raw AES key bytes for isolate-safe encrypt/decrypt.
  Future<Uint8List> deriveKeyBytes(String pin) async {
    final key = await _deriveKey(pin);
    return key.bytes;
  }

  Future<enc.Key> _deriveKey(String pin) async {
    final salt = await _getOrCreateSalt();
    final digest = sha256.convert(utf8.encode('$pin$salt'));
    return enc.Key(Uint8List.fromList(digest.bytes));
  }

  Future<String> _getOrCreateSalt() async {
    var salt = await _storage.read(key: AppConstants.secureEncryptionSalt);
    if (salt == null) {
      salt = _uuid.v4();
      await _storage.write(
        key: AppConstants.secureEncryptionSalt,
        value: salt,
      );
    }
    return salt;
  }

  /// Encrypt bytes — key derived on main isolate, AES in background.
  Future<Uint8List> encryptBytes(Uint8List plainBytes, String pin) async {
    final keyBytes = await deriveKeyBytes(pin);
    return compute(
      encryptBytesInIsolate,
      CipherPayload(data: plainBytes, keyBytes: keyBytes),
    );
  }

  Future<void> encryptFile(
    File source,
    File dest, {
    required String pin,
  }) async {
    final bytes = await source.readAsBytes();
    final encrypted = await encryptBytes(bytes, pin);
    await dest.parent.create(recursive: true);
    await dest.writeAsBytes(encrypted, flush: true);
  }

  Future<File> decryptToTemp(File source, {required String pin}) async {
    final key = await _deriveKey(pin);
    final bytes = await source.readAsBytes();
    if (bytes.length < 16) {
      throw const FormatException('Invalid encrypted file');
    }
    final iv = enc.IV(bytes.sublist(0, 16));
    final ciphertext = bytes.sublist(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final decrypted = encrypter.decryptBytes(
      enc.Encrypted(ciphertext),
      iv: iv,
    );

    final tempFile = File(
      p.join(Directory.systemTemp.path, 'kuva_dec_${_uuid.v4()}'),
    );
    await tempFile.writeAsBytes(decrypted, flush: true);
    return tempFile;
  }
}
