/// 🤖 Generated wholly or partially with Claude Sonnet 4.5; flat-nib calligraphy stroke
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:saber/components/canvas/_stroke.dart';
import 'package:saber/data/editor/page.dart';
import 'package:sbn/has_size.dart';
import 'package:sbn/tool_id.dart';

/// A stroke that simulates a flat-nib calligraphy pen.
///
/// The stroke width varies based on the direction of movement relative to
/// the nib angle. Drawing perpendicular to the nib gives maximum width;
/// drawing parallel to the nib gives minimum width.
class FlatNibStroke extends Stroke {
  /// The angle of the nib in degrees, measured clockwise from horizontal.
  /// A value of 45° is the classic calligraphy angle.
  final double nibAngle;

  /// The minimum width fraction relative to base size (0 = hairline, 1 = full width).
  static const double _minWidthFactor = 0.07;

  FlatNibStroke({
    required super.color,
    required super.pressureEnabled,
    required super.options,
    required super.pageIndex,
    required super.page,
    this.nibAngle = 45.0,
    super.shimmerIntensity,
    super.shimmerColor,
    super.sheenIntensity,
    super.sheenColor,
    super.shadingAmount,
    super.createdAt,
    super.expiry,
  }) : super(toolId: ToolId.flatNibPen);

  @override
  List<Offset> getPolygon({required StrokeQuality quality}) {
    if (points.length < 2) {
      return super.getPolygon(quality: quality);
    }

    final nibAngleRad = nibAngle * pi / 180;
    final sourcePoints = Stroke.skipPoints(points, quality.N);

    // Compute a smoothed direction angle for each point.
    final angles = _computeSmoothedAngles(sourcePoints);

    // Build modified points where pressure encodes the calligraphic width.
    final modifiedPoints = <PointVector>[];
    for (int i = 0; i < sourcePoints.length; i++) {
      final point = sourcePoints[i];
      final angle = angles[i];

      // Width factor based on how perpendicular the stroke direction is to the nib.
      final dirFactor = sin(angle - nibAngleRad).abs();
      final calligraphicPressure =
          _minWidthFactor + dirFactor * (1.0 - _minWidthFactor);

      // Optionally blend with actual stylus pressure for added expressiveness.
      final rawPressure = point.pressure;
      final effectivePressure = rawPressure != null
          ? calligraphicPressure * (0.6 + 0.4 * rawPressure)
          : calligraphicPressure;

      modifiedPoints.add(
        PointVector(point.x, point.y, effectivePressure.clamp(0.0, 1.0)),
      );
    }

    final strokeOptions = switch (quality) {
      StrokeQuality.low => options.copyWith(
        simulatePressure: false,
        smoothing: 0,
        streamline: 0,
        thinning: 1.0,
      ),
      StrokeQuality.high => options.copyWith(thinning: 1.0),
    };

    return getStroke(
      modifiedPoints,
      options: strokeOptions,
      rememberSimulatedPressure: false,
    );
  }

  /// Computes a smoothed direction angle for each point using a sliding window.
  static List<double> _computeSmoothedAngles(List<PointVector> pts) {
    if (pts.length < 2) return [0.0];

    // Raw angles from consecutive segments.
    final rawAngles = List<double>.filled(pts.length, 0.0);
    for (int i = 0; i < pts.length; i++) {
      final prev = i > 0 ? pts[i - 1] : pts[i];
      final next = i < pts.length - 1 ? pts[i + 1] : pts[i];
      rawAngles[i] = atan2(next.y - prev.y, next.x - prev.x);
    }

    // Smooth over a small window to reduce noise.
    const windowSize = 3;
    final smoothed = List<double>.filled(pts.length, 0.0);
    for (int i = 0; i < rawAngles.length; i++) {
      final start = (i - windowSize ~/ 2).clamp(0, rawAngles.length - 1);
      final end = (i + windowSize ~/ 2 + 1).clamp(0, rawAngles.length);
      // Circular mean for angles.
      double sinSum = 0;
      double cosSum = 0;
      for (int j = start; j < end; j++) {
        sinSum += sin(rawAngles[j]);
        cosSum += cos(rawAngles[j]);
      }
      smoothed[i] = atan2(sinSum, cosSum);
    }
    return smoothed;
  }

  factory FlatNibStroke.fromStroke(Stroke stroke) {
    return FlatNibStroke(
      color: stroke.color,
      pressureEnabled: stroke.pressureEnabled,
      options: stroke.options.copyWith(),
      pageIndex: stroke.pageIndex,
      page: stroke.page,
      shimmerIntensity: stroke.shimmerIntensity,
      shimmerColor: stroke.shimmerColor,
      sheenIntensity: stroke.sheenIntensity,
      sheenColor: stroke.sheenColor,
      shadingAmount: stroke.shadingAmount,
      createdAt: stroke.createdAt,
      expiry: stroke.expiry,
    )..points.addAll(stroke.points);
  }
}
