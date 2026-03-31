/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot; Claude Sonnet 4 ✨
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:saber/devils_book/stylus/devils_stylus_event.dart';
import 'package:saber/devils_book/stylus/stylus_bridge.dart';
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

  /// The latest barrel roll angle from the native plugin, in radians.
  double? latestBarrelRoll;

  StreamSubscription<PencilEvent>? _nativeSubscription;

  void updateCapabilities(StylusCapabilities newCaps) {
    if (capabilities != newCaps) {
      capabilities = newCaps;
      notifyListeners();
    }
  }

  /// Starts listening to the native Apple Pencil event stream via [StylusBridge].
  void listenToNativePencilEvents(StylusBridge bridge) {
    _nativeSubscription?.cancel();
    _nativeSubscription = bridge.events.listen(onNativePencilEvent);
  }

  @visibleForTesting
  void onNativePencilEvent(PencilEvent event) {
    switch (event.type) {
      case PencilEventType.barrelRoll:
        latestBarrelRoll = event.barrelRollAngle;
        notifyListeners();
      case PencilEventType.squeezeBegan:
        if (!isSqueezing) {
          isSqueezing = true;
          notifyListeners();
        }
      case PencilEventType.squeezeEnded:
        if (isSqueezing) {
          isSqueezing = false;
          notifyListeners();
        }
      case PencilEventType.doubleTap:
        notifyListeners();
    }
  }

  void updateEvent(DevilsStylusEvent event) {
    // Enrich the event with native barrel roll data if available.
    if (latestBarrelRoll != null && event.barrelRoll == null) {
      currentEvent = DevilsStylusEvent(
        position: event.position,
        pressure: event.pressure,
        altitude: event.altitude,
        azimuth: event.azimuth,
        barrelRoll: latestBarrelRoll,
        squeeze: event.squeeze,
        isHovering: event.isHovering,
      );
    } else {
      currentEvent = event;
    }

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

  @override
  void dispose() {
    _nativeSubscription?.cancel();
    super.dispose();
  }
}
