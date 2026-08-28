import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_test/flutter_test.dart';

import 'package:kuva_gallery_app/core/services/pin_service.dart';
import 'package:kuva_gallery_app/data/repositories/upload_repository.dart';

void main() {
  group('PinService', () {
    test('hashPinWithSalt produces consistent SHA-256 hash', () {
      const pin = '1234';
      const salt = 'test-salt';
      final hash1 = PinService.hashPinWithSalt(pin, salt);
      final hash2 = PinService.hashPinWithSalt(pin, salt);
      expect(hash1, hash2);
      expect(hash1.length, 64); // SHA-256 hex
    });

    test('different salts produce different hashes', () {
      const pin = '1234';
      final h1 = PinService.hashPinWithSalt(pin, 'salt-a');
      final h2 = PinService.hashPinWithSalt(pin, 'salt-b');
      expect(h1, isNot(equals(h2)));
    });

    test('hash matches manual SHA-256 computation', () {
      const pin = '5678';
      const salt = 'abc';
      final expected = sha256.convert(utf8.encode('$pin$salt')).toString();
      expect(PinService.hashPinWithSalt(pin, salt), expected);
    });
  });

  group('Encryption round-trip', () {
    test('encrypt then decrypt restores original bytes', () {
      const pin = '4829';
      const salt = 'test-encryption-salt';
      final digest = sha256.convert(utf8.encode('$pin$salt'));
      final key = enc.Key(Uint8List.fromList(digest.bytes));

      final originalBytes = Uint8List.fromList(
        List<int>.generate(256, (i) => i % 256),
      );

      final iv = enc.IV.fromSecureRandom(16);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final encrypted = encrypter.encryptBytes(originalBytes, iv: iv);

      final encFile = Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);

      final readIv = enc.IV(encFile.sublist(0, 16));
      final ciphertext = encFile.sublist(16);
      final decrypted = encrypter.decryptBytes(
        enc.Encrypted(ciphertext),
        iv: readIv,
      );

      expect(decrypted, originalBytes);
    });
  });

  group('UploadRepository backoff', () {
    test('backoff delay increases exponentially', () async {
      final stopwatch = Stopwatch()..start();
      await UploadRepository.backoff(1);
      stopwatch.stop();
      expect(stopwatch.elapsed.inSeconds, greaterThanOrEqualTo(2));
      expect(stopwatch.elapsed.inSeconds, lessThan(5));
    });

    test('backoffSeconds caps at 300', () {
      expect(UploadRepository.backoffSeconds(20), 300);
      expect(UploadRepository.backoffSeconds(9), 512.clamp(1, 300));
    });
  });
}
