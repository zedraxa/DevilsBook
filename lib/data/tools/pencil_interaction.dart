/// 🤖 Generated wholly or partially with Claude Sonnet 4.5; Claude Sonnet 4 ✨
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The type of a [PencilInteractionEvent].
enum PencilInteractionEventType {
  /// The user double-tapped the flat side of Apple Pencil (2nd gen or Pro).
  doubleTap,

  /// The user squeezed Apple Pencil Pro (iOS 17.5+, squeeze began).
  squeezeBegin,

  /// The user released a squeeze on Apple Pencil Pro (iOS 17.5+).
  squeezeEnd,

  /// The barrel roll angle of Apple Pencil Pro changed (iOS 16.0+).
  barrelRoll,
}

/// An event from the Apple Pencil hardware interaction pipeline.
class PencilInteractionEvent {
  const PencilInteractionEvent({required this.type, this.barrelRollAngle});

  final PencilInteractionEventType type;

  /// Barrel roll angle in radians (−π … π, 0 = default orientation).
  /// Only set when [type] is [PencilInteractionEventType.barrelRoll].
  final double? barrelRollAngle;
}

/// Listens to native Apple Pencil interactions (double-tap, squeeze,
/// barrel roll) on iOS and exposes them as a [Stream].
///
/// On non-iOS platforms the stream is empty and [isSupported] is `false`.
abstract class PencilInteractionService {
  PencilInteractionService._();

  static const _eventChannel = EventChannel('saber/pencil_interaction');

  static Stream<PencilInteractionEvent>? _stream;

  /// Whether the current platform exposes any pencil interaction events.
  static bool get isSupported => defaultTargetPlatform == TargetPlatform.iOS;

  /// A broadcast stream of Apple Pencil interaction events.
  ///
  /// Subscribing starts the native listener; unsubscribing stops it.
  static Stream<PencilInteractionEvent> get events {
    if (!isSupported) return const Stream.empty();

    _stream ??= _eventChannel
        .receiveBroadcastStream()
        .map(parseEvent)
        .where((event) => event != null)
        .cast<PencilInteractionEvent>();

    return _stream!;
  }

  @visibleForTesting
  static PencilInteractionEvent? parseEvent(dynamic raw) {
    if (raw is! Map) return null;

    final type = raw['type'] as String?;
    switch (type) {
      case 'doubleTap':
        return const PencilInteractionEvent(
          type: PencilInteractionEventType.doubleTap,
        );
      case 'squeeze':
        final phase = raw['phase'] as String?;
        if (phase == 'began') {
          return const PencilInteractionEvent(
            type: PencilInteractionEventType.squeezeBegin,
          );
        } else if (phase == 'ended') {
          return const PencilInteractionEvent(
            type: PencilInteractionEventType.squeezeEnd,
          );
        }
        return null;
      case 'barrelRoll':
        final angle = raw['angle'];
        return PencilInteractionEvent(
          type: PencilInteractionEventType.barrelRoll,
          barrelRollAngle: (angle as num?)?.toDouble(),
        );
      default:
        return null;
    }
  }
}
