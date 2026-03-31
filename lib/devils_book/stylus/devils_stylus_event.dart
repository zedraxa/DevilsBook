/// 🤖 Generated wholely or partially with Claude Sonnet 4.5 ✨
library;

import 'package:flutter/gestures.dart';

/// A premium abstraction over Flutter's native PointerEvent.
/// Captures enhanced metrics required for atmospheric 'Devils Book' interactions.
class DevilsStylusEvent {
  final Offset position;
  final double pressure;
  
  /// The altitude angle of the stylus, in radians.
  /// 0 is flat on the screen, pi/2 is perpendicular.
  final double altitude;
  
  /// The azimuth angle of the stylus, in radians.
  /// Represents the direction the stylus is pointing in the X-Y plane.
  final double azimuth;
  
  /// The rotation of the stylus around its own axis, in radians.
  /// Requires hardware support (e.g. Apple Pencil Pro or Wacom Art Pen).
  final double? barrelRoll;
  
  /// How hard the user is squeezing the stylus shell.
  /// Used for invoking the ephemeral tool palette.
  final double? squeeze;
  
  /// Is the stylus currently just hovering over the screen without touching?
  final bool isHovering;

  const DevilsStylusEvent({
    required this.position,
    required this.pressure,
    required this.altitude,
    required this.azimuth,
    this.barrelRoll,
    this.squeeze,
    this.isHovering = false,
  });

  /// Constructs a base event from a native Flutter PointerEvent.
  ///
  /// For stylus devices, Flutter natively exposes barrel roll via [PointerEvent.rotation]
  /// (e.g. Apple Pencil Pro on iOS ≥ 16). Squeeze remains null until injected
  /// by the [StylusBridge] native channel.
  factory DevilsStylusEvent.fromPointerEvent(PointerEvent event) {
    return DevilsStylusEvent(
      position: event.localPosition,
      pressure: event.pressure,
      altitude: event.tilt,
      azimuth: event.orientation,
      // Flutter provides barrel roll for stylus devices (e.g. Apple Pencil Pro)
      // via PointerEvent.rotation. Non-stylus events always return 0.0, so we
      // store null for those to distinguish "not supported" from "at neutral angle".
      barrelRoll: event.kind == PointerDeviceKind.stylus ? event.rotation : null,
      isHovering: event is PointerHoverEvent,
    );
  }
}
