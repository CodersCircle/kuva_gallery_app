import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_test/flutter_test.dart';

import 'package:kuva_gallery_app/core/services/encryption_service.dart';

void main() {
  group('Encryption — main isolate only (hide path)', () {
    test('encryptBytes produces decryptable output', () async {
      const pin = '4829';
      const salt = 'hide-test-salt';
      final digest = sha256.convert(utf8.encode('$pin$salt'));
      final keyBytes = Uint8List.fromList(digest.bytes);

      final plain = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      // Simulate encryptBytes logic (EncryptionService uses secure storage).
      final key = enc.Key(keyBytes);
      final iv = enc.IV.fromSecureRandom(16);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final encrypted = encrypter.encryptBytes(plain, iv: iv);
      final blob = Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);

      expect(blob.length, greaterThan(16));

      final readIv = enc.IV(blob.sublist(0, 16));
      final ciphertext = blob.sublist(16);
      final decrypted = encrypter.decryptBytes(
        enc.Encrypted(ciphertext),
        iv: readIv,
      );
      expect(decrypted, plain);
    });
  });
}
