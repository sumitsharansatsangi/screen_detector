/// Performance metrics for screen detection operations.
class DetectionMetrics {
  /// Time taken for detection in microseconds.
  final int detectionTimeUs;

  /// Whether hardware acceleration was used.
  final bool hardwareAccelerated;

  /// Whether cached results were used.
  final bool fromCache;

  /// Number of MediaQuery accesses performed.
  final int mediaQueryAccesses;

  const DetectionMetrics({
    required this.detectionTimeUs,
    required this.hardwareAccelerated,
    required this.fromCache,
    required this.mediaQueryAccesses,
  });

  @override
  String toString() {
    return 'DetectionMetrics(time: $detectionTimeUsμs, hw: $hardwareAccelerated, cached: $fromCache, queries: $mediaQueryAccesses)';
  }
}

/// Performance monitoring for screen detection.
class PerformanceMonitor {
  static DetectionMetrics? _lastMetrics;

  /// Get the last detection performance metrics.
  static DetectionMetrics? get lastMetrics => _lastMetrics;

  /// Reset performance metrics.
  static void reset() {
    _lastMetrics = null;
  }

  /// Measure execution time of a function.
  static T measure<T>(T Function() function,
      {bool isHardwareAccelerated = false,
      bool fromCache = false,
      int mediaQueryAccesses = 1}) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = function();
      stopwatch.stop();

      _lastMetrics = DetectionMetrics(
        detectionTimeUs: stopwatch.elapsedMicroseconds,
        hardwareAccelerated: isHardwareAccelerated,
        fromCache: fromCache,
        mediaQueryAccesses: mediaQueryAccesses,
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      rethrow;
    }
  }
}
