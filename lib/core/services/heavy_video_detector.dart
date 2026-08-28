/// Heuristics for DJI / high-bitrate 4K 10-bit HEVC clips that need a proxy.
class HeavyVideoDetector {
  HeavyVideoDetector._();

  /// Bitrate above this (Mbps) usually means software-decode stutter on mid-range phones.
  static const double highBitrateMbps = 45;

  /// File larger than this at 1080p+ is treated as heavy.
  static const int largeFileBytes = 80 * 1024 * 1024;

  static bool needsProxy({
    required int width,
    required int height,
    required int fileSizeBytes,
    required int durationSeconds,
  }) {
    if (width <= 0 || height <= 0 || fileSizeBytes <= 0) return false;

    final is4K = width >= 3840 || height >= 2160;
    if (is4K) return true;

    final bitrateMbps = durationSeconds > 0
        ? (fileSizeBytes * 8) / durationSeconds / 1000000
        : 0.0;
    if (bitrateMbps >= highBitrateMbps) return true;

    final is1080pPlus = width >= 1920 || height >= 1080;
    if (is1080pPlus && fileSizeBytes >= largeFileBytes) return true;

    return false;
  }
}
