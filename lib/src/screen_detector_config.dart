import 'adaptive_breakpoints.dart';

/// Global configuration for screen detection behavior.
class ScreenDetectorConfig {
  /// Enable hardware-accelerated detection where available.
  final bool enableHardwareAcceleration;

  /// Enable sensor-based posture detection (requires permissions).
  final bool enableSensorDetection;

  /// Custom breakpoints for screen type detection.
  final AdaptiveBreakpoints breakpoints;

  /// Cache duration for detection results (in milliseconds).
  final int cacheDurationMs;

  /// Enable debug logging.
  final bool debugMode;

  const ScreenDetectorConfig({
    this.enableHardwareAcceleration = true,
    this.enableSensorDetection = false,
    this.breakpoints = AdaptiveBreakpoints.material,
    this.cacheDurationMs = 100,
    this.debugMode = false,
  });

  /// Performance-optimized configuration.
  static const performance = ScreenDetectorConfig(
    enableHardwareAcceleration: true,
    enableSensorDetection: false,
    cacheDurationMs: 50,
    debugMode: false,
  );

  /// Debug configuration with logging.
  static const debug = ScreenDetectorConfig(
    enableHardwareAcceleration: true,
    enableSensorDetection: true,
    cacheDurationMs: 0,
    debugMode: true,
  );
}
