import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;

/// Payload for isolate-safe AES encrypt/decrypt (key derived on main isolate).
class CipherPayload {
  const CipherPayload({
    required this.data,
    required this.keyBytes,
  });

  final Uint8List data;
  final Uint8List keyBytes;
}

/// Encrypt plain bytes in a background isolate.
Uint8List encryptBytesInIsolate(CipherPayload payload) {
  final key = enc.Key(payload.keyBytes);
  final iv = enc.IV.fromSecureRandom(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final encrypted = encrypter.encryptBytes(payload.data, iv: iv);
  return Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
}

/// Decrypt vault blob bytes in a background isolate.
Uint8List decryptBytesInIsolate(CipherPayload payload) {
  final bytes = payload.data;
  if (bytes.length < 16) {
    throw const FormatException('Invalid encrypted file');
  }
  final key = enc.Key(payload.keyBytes);
  final iv = enc.IV(bytes.sublist(0, 16));
  final ciphertext = bytes.sublist(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  return Uint8List.fromList(
    encrypter.decryptBytes(enc.Encrypted(ciphertext), iv: iv),
  );
}
