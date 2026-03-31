/// 🤖 Generated wholely or partially with Claude Sonnet 4.5 ✨
library;

import 'dart:math';
import 'ink_sample.dart';

/// Defines the physical geometry and dynamic behavior of a writer's nib.
abstract class NibProfile {
  /// Computes the thickness of the line at a given [sample].
  ///
  /// The optional [prevSample] allows velocity-aware profiles (e.g. calligraphic nibs)
  /// to compare the stroke direction against the nib orientation for authentic
  /// thick/thin contrasts. When null, implementations fall back to a pressure-only model.
  double computeThickness(InkSample sample, {required double baseThickness, InkSample? prevSample});

  /// Computes the angular deformation (calligraphic angle) mapping to the 
  /// organic rotation of the stroke joint.
  double computeAngle(InkSample sample);
}

/// A classic ballpoint profile that scales predominantly with pressure, 
/// ignoring specific hardware orientation.
class BallpointNibProfile extends NibProfile {
  @override
  double computeThickness(InkSample sample, {required double baseThickness, InkSample? prevSample}) {
    // Pure linear scaling based on pressure
    return baseThickness * max(0.1, sample.pressure);
  }

  @override
  double computeAngle(InkSample sample) => 0.0;
}

/// A premium calligraphic fountain nib that reacts heavily to the physical orientation
/// and barrel roll of the stylus to create organic thin/thick contrasts dynamically.
class CalligraphicNibProfile extends NibProfile {
  @override
  double computeThickness(InkSample sample, {required double baseThickness, InkSample? prevSample}) {
    // A nib laid flatter (lower altitude) produces thinner strokes.
    final altitudeFactor = sin(sample.altitude.clamp(0.2, pi / 2));

    // When we have a previous sample, compute the stroke direction and compare
    // it against the physical nib orientation (effectiveRotation = azimuth + barrelRoll).
    // A stroke perpendicular to the nib wide-edge is thick; parallel is thin.
    double strokeAngleFactor = 1.0;
    if (prevSample != null) {
      final dx = sample.x - prevSample.x;
      final dy = sample.y - prevSample.y;
      if (dx.abs() + dy.abs() > 0.5) {
        final strokeDirection = atan2(dy, dx);
        final angleDiff = strokeDirection - sample.effectiveRotation;
        // |sin| of the angle difference: 1.0 when perpendicular, 0 when parallel.
        // Clamped to [0.2, 1.0] so parallel strokes still have some minimum width.
        strokeAngleFactor = sin(angleDiff).abs().clamp(0.2, 1.0);
      }
    }

    return baseThickness * sample.pressure * altitudeFactor * strokeAngleFactor;
  }

  @override
  double computeAngle(InkSample sample) {
    // The angle of the stroke joint is explicitly locked to the true rotation of the hardware instrument!
    return sample.effectiveRotation;
  }
}
