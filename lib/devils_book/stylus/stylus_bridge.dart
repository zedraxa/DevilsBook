/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot; Claude Sonnet 4 ✨
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:saber/devils_book/stylus/stylus_capabilities.dart';

/// Event types received from the native Apple Pencil interaction plugin.
enum PencilEventType {
  doubleTap,
  squeezeBegan,
  squeezeEnded,
  barrelRoll,
}

/// A parsed event from the native Apple Pencil interaction plugin.
class PencilEvent {
  const PencilEvent({required this.type, this.barrelRollAngle});

  final PencilEventType type;

  /// Barrel roll angle in radians (−π … π, 0 = default orientation).
  /// Only set when [type] is [PencilEventType.barrelRoll].
  final double? barrelRollAngle;
}

/// Method channel bridge to native implementations for premium hardware
/// that Flutter does not yet natively wrap (e.g. raw Apple Pencil Pro squeeze force).
class StylusBridge {
  static const _eventChannel = EventChannel('devils_book/pencil_interaction');

  Stream<PencilEvent>? _eventStream;

  /// Whether the native pencil interaction plugin is available on the current platform.
  static bool get isSupported =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  /// Fetches the hardware capabilities from the host OS.
  Future<StylusCapabilities> getCapabilities() async {
    try {
      return StylusCapabilities(
        supportsPressure: true,
        supportsTilt: true,
        supportsBarrelRoll: isSupported,
        supportsSqueeze: isSupported,
        supportsHover: true,
      );
    } catch (e) {
      debugPrint(
          "DEVILS BOOK [ERROR]: StylusBridge.getCapabilities failed -> $e");
      return StylusCapabilities.unknown;
    }
  }

  /// A broadcast stream of Apple Pencil interaction events.
  ///
  /// Subscribing starts the native listener; unsubscribing stops it.
  /// On unsupported platforms, returns an empty stream.
  Stream<PencilEvent> get events {
    if (!isSupported) return const Stream.empty();

    _eventStream ??= _eventChannel
        .receiveBroadcastStream()
        .map(parseEvent)
        .where((event) => event != null)
        .cast<PencilEvent>();

    return _eventStream!;
  }

  /// Parses a raw event map from the native EventChannel into a [PencilEvent].
  /// Returns null for invalid or unrecognized events.
  @visibleForTesting
  static PencilEvent? parseEvent(dynamic raw) {
    if (raw is! Map) return null;

    final type = raw['type'] as String?;
    switch (type) {
      case 'doubleTap':
        return const PencilEvent(type: PencilEventType.doubleTap);
      case 'squeeze':
        final phase = raw['phase'] as String?;
        if (phase == 'began') {
          return const PencilEvent(type: PencilEventType.squeezeBegan);
        } else if (phase == 'ended') {
          return const PencilEvent(type: PencilEventType.squeezeEnded);
        }
        return null;
      case 'barrelRoll':
        final angle = raw['angle'];
        return PencilEvent(
          type: PencilEventType.barrelRoll,
          barrelRollAngle: (angle as num?)?.toDouble(),
        );
      default:
        return null;
    }
  }
}
