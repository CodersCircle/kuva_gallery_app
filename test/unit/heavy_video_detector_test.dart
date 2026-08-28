import 'package:flutter_test/flutter_test.dart';
import 'package:kuva_gallery_app/core/services/heavy_video_detector.dart';

void main() {
  group('HeavyVideoDetector', () {
    test('4K width triggers proxy', () {
      expect(
        HeavyVideoDetector.needsProxy(
          width: 3840,
          height: 2160,
          fileSizeBytes: 50 * 1024 * 1024,
          durationSeconds: 60,
        ),
        isTrue,
      );
    });

    test('low-bitrate 720p does not trigger proxy', () {
      expect(
        HeavyVideoDetector.needsProxy(
          width: 1280,
          height: 720,
          fileSizeBytes: 20 * 1024 * 1024,
          durationSeconds: 120,
        ),
        isFalse,
      );
    });

    test('high bitrate 1080p triggers proxy', () {
      // ~90 Mbps over 30s ≈ 337 MB
      expect(
        HeavyVideoDetector.needsProxy(
          width: 1920,
          height: 1080,
          fileSizeBytes: 340 * 1024 * 1024,
          durationSeconds: 30,
        ),
        isTrue,
      );
    });

    test('large 1080p file triggers proxy even with unknown duration', () {
      expect(
        HeavyVideoDetector.needsProxy(
          width: 1920,
          height: 1080,
          fileSizeBytes: 100 * 1024 * 1024,
          durationSeconds: 0,
        ),
        isTrue,
      );
    });
  });
}
