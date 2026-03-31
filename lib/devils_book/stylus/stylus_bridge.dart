/// 🤖 Generated wholely or partially with Claude Sonnet 4.5 ✨
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'stylus_capabilities.dart';

/// Method channel bridge to native implementations for premium hardware
/// that Flutter does not yet natively wrap (e.g. raw Apple Pencil Pro squeeze force).
class StylusBridge {
  static const MethodChannel _channel = MethodChannel('devilsbook.stylus/premium');

  /// Fetches the hardware capabilities from the host OS.
  ///
  /// Barrel roll is natively available via [PointerEvent.rotation] on iOS/macOS
  /// (Apple Pencil Pro, iPadOS 16+), so no native channel call is needed for it.
  /// Squeeze still requires a future native channel implementation.
  Future<StylusCapabilities> getCapabilities() async {
    try {
      final isApplePlatform = defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS;

      return StylusCapabilities(
        supportsPressure: true,
        supportsTilt: true,
        // Flutter exposes Apple Pencil Pro barrel roll via PointerEvent.rotation
        // on iOS/macOS natively — no native channel needed.
        supportsBarrelRoll: isApplePlatform,
        // Squeeze still requires the native premium channel (future work).
        supportsSqueeze: false,
        supportsHover: true,
      );
    } catch (e) {
      debugPrint("DEVILS BOOK [ERROR]: StylusBridge.getCapabilities failed -> $e");
      return StylusCapabilities.unknown;
    }
  }
  
  // Future: Event stream for continuous native squeeze broadcasting unhinged from PointerEvents
}
