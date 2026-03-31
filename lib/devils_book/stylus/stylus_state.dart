/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot
library;

import 'package:flutter/foundation.dart';
import 'package:saber/devils_book/stylus/devils_stylus_event.dart';
import 'package:saber/devils_book/stylus/stylus_capabilities.dart';

/// Central state holder for the stylus hardware.
/// Allows decoupled components (e.g. EffectEngine, Hover Engine) to probe the current physical pen state
/// without being explicitly piped through the interactive canvas callbacks.
class StylusState extends ChangeNotifier {
  var capabilities = StylusCapabilities.unknown;
  
  DevilsStylusEvent? currentEvent;
  
  /// Tracks if the user is currently squeezing the pen shell.
  /// This is separate from drawing pressure and invokes UI/Effect changes.
  var isSqueezing = false;
  
  /// Tracks if the pen is within hover distance of the screen.
  var isHovering = false;

  void updateCapabilities(StylusCapabilities newCaps) {
    if (capabilities != newCaps) {
      capabilities = newCaps;
      notifyListeners();
    }
  }

  void updateEvent(DevilsStylusEvent event) {
    currentEvent = event;

    if (isHovering != event.isHovering) {
      isHovering = event.isHovering;
    }

    if (event.squeeze != null) {
      final squeezeDetected = event.squeeze! > 0.5; // Threshold for explicit squeeze
      if (isSqueezing != squeezeDetected) {
        isSqueezing = squeezeDetected;
      }
    }

    // Always notify listeners for continuous updates like hover coordinates moving
    notifyListeners();
  }
}
