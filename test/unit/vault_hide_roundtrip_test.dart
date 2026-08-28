import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:kuva_gallery_app/core/services/encryption_compute.dart';

/// Simulates the vault hide pipeline (encrypt → write → verify → decrypt)
/// without touching MediaStore or Isar.
Future<void> simulateHidePipeline({
  required Uint8List plainBytes,
  required Uint8List keyBytes,
  required Directory vaultDir,
  required String fileName,
}) async {
  final encryptedBytes = await compute(
    encryptBytesInIsolate,
    CipherPayload(data: plainBytes, keyBytes: keyBytes),
  );

  final vaultFile = File('${vaultDir.path}/$fileName');
  await vaultFile.writeAsBytes(encryptedBytes, flush: true);

  final writtenOk =
      await vaultFile.exists() && (await vaultFile.length()) == encryptedBytes.length;
  if (!writtenOk) {
    if (await vaultFile.exists()) await vaultFile.delete();
    throw StateError('Vault write verification failed');
  }

  final verifyDecrypt = await compute(
    decryptBytesInIsolate,
    CipherPayload(data: encryptedBytes, keyBytes: keyBytes),
  );
  if (verifyDecrypt.length != plainBytes.length) {
    await vaultFile.delete();
    throw StateError('Round-trip decrypt verification failed');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pin = '4829';
  const salt = 'vault-roundtrip-salt';

  test('hide→unhide round trip: 10/10 byte-identical restores', () async {
    final keyBytes = Uint8List.fromList(
      sha256.convert(utf8.encode('$pin$salt')).bytes,
    );
    final vaultDir = Directory.systemTemp.createTempSync('kuva_vault_qa_');
    final originals = <String, Uint8List>{
      for (var i = 0; i < 10; i++)
        '${const Uuid().v4()}.enc': Uint8List.fromList(
          List<int>.generate(2048 + i, (j) => (i * 23 + j) % 256),
        ),
    };

    try {
      for (final entry in originals.entries) {
        await simulateHidePipeline(
          plainBytes: entry.value,
          keyBytes: keyBytes,
          vaultDir: vaultDir,
          fileName: entry.key,
        );
      }

      var passed = 0;
      for (final entry in originals.entries) {
        final encryptedBytes =
            await File('${vaultDir.path}/${entry.key}').readAsBytes();
        final restored = await compute(
          decryptBytesInIsolate,
          CipherPayload(data: encryptedBytes, keyBytes: keyBytes),
        );
        expect(restored, entry.value, reason: entry.key);
        passed++;
      }
      expect(passed, 10);
    } finally {
      if (vaultDir.existsSync()) {
        vaultDir.deleteSync(recursive: true);
      }
    }
  });
}
