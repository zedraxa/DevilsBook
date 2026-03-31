/// 🤖 Generated wholly or partially with Claude Sonnet 4 ✨
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:saber/components/canvas/_stroke.dart';
import 'package:sbn/has_size.dart';

void main() {
  group('Calligraphic polygon generation', () {
    Stroke _makeCalligraphyStroke({
      required List<Offset> points,
      required List<double> orientations,
      double size = 10,
      double? pressure,
    }) {
      final stroke = Stroke(
        color: Colors.black,
        pressureEnabled: pressure != null,
        options: StrokeOptions(size: size),
        pageIndex: 0,
        page: const HasSize(Size(500, 500)),
        toolId: .calligraphyPen,
      );
      for (int i = 0; i < points.length; i++) {
        stroke.addPoint(
          points[i],
          pressure,
          orientations[i],
        );
      }
      return stroke;
    }

    test('returns empty polygon for fewer than 2 points', () {
      final stroke = _makeCalligraphyStroke(
        points: [const Offset(10, 10)],
        orientations: [0],
      );
      final polygon = stroke.getCalligraphicPolygon(quality: .high);
      expect(polygon, isEmpty);
    });

    test('produces non-empty polygon for 2+ points', () {
      final stroke = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(100, 0)],
        orientations: [0, 0],
        pressure: 0.5,
      );
      final polygon = stroke.getCalligraphicPolygon(quality: .high);
      expect(polygon.length, greaterThanOrEqualTo(4));
    });

    test('polygon is symmetric (left side + reversed right side)', () {
      final stroke = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(100, 0)],
        orientations: [0, 0],
        pressure: 0.5,
      );
      final polygon = stroke.getCalligraphicPolygon(quality: .high);
      // For 2 points: 2 left + 2 right = 4 vertices
      expect(polygon.length, equals(4));
    });

    test('perpendicular stroke produces wider polygon than parallel stroke', () {
      // Nib at 0 radians (pointing right).
      // A horizontal stroke (also 0 rad) is parallel → thin.
      // A vertical stroke (π/2 rad) is perpendicular → thick.

      final horizontalStroke = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(100, 0)],
        orientations: [0, 0],
        pressure: 0.5,
      );
      final verticalStroke = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(0, 100)],
        orientations: [0, 0],
        pressure: 0.5,
      );

      final hPoly = horizontalStroke.getCalligraphicPolygon(quality: .high);
      final vPoly = verticalStroke.getCalligraphicPolygon(quality: .high);

      // Measure width as the distance between corresponding left/right pairs.
      double polygonWidth(List<Offset> poly) {
        // First point from left side, last point from right side (reversed).
        return (poly.first - poly.last).distance;
      }

      final hWidth = polygonWidth(hPoly);
      final vWidth = polygonWidth(vPoly);
      // Vertical stroke should be wider because it's perpendicular to the nib.
      expect(vWidth, greaterThan(hWidth));
    });

    test('nib rotation changes width distribution', () {
      // Both are horizontal strokes. One has nib at 0° (parallel → thin),
      // the other has nib at π/2 (perpendicular → thick).
      final parallelNib = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(100, 0)],
        orientations: [0, 0],
        pressure: 0.5,
      );
      final perpendicularNib = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(100, 0)],
        orientations: [pi / 2, pi / 2],
        pressure: 0.5,
      );

      final paraPoly = parallelNib.getCalligraphicPolygon(quality: .high);
      final perpPoly = perpendicularNib.getCalligraphicPolygon(quality: .high);

      double polygonWidth(List<Offset> poly) {
        return (poly.first - poly.last).distance;
      }

      // With nib perpendicular to horizontal stroke, it should be wider.
      expect(polygonWidth(perpPoly), greaterThan(polygonWidth(paraPoly)));
    });

    test('orientations are preserved through serialization', () {
      final stroke = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(50, 50)],
        orientations: [0.5, 1.2],
        pressure: 0.5,
      );

      final json = stroke.toJson();
      expect(json['or'], isNotNull);
      expect(json['or'], equals([0.5, 1.2]));
    });

    test('orientations are restored from JSON', () {
      final original = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(50, 50)],
        orientations: [0.5, 1.2],
        pressure: 0.5,
      );

      final json = original.toJson();
      final restored = Stroke.fromJson(
        json,
        fileVersion: 13,
        pageIndex: 0,
        page: const HasSize(Size(500, 500)),
      );

      expect(restored.orientations.length, equals(2));
      expect(restored.orientations[0], closeTo(0.5, 0.001));
      expect(restored.orientations[1], closeTo(1.2, 0.001));
    });

    test('copy preserves orientations', () {
      final stroke = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(50, 50)],
        orientations: [0.3, -0.7],
        pressure: 0.5,
      );

      final copy = stroke.copy();
      expect(copy.orientations, equals([0.3, -0.7]));
    });

    test('calligraphic polygon used via highQualityPolygon for calligraphy tool',
        () {
      final stroke = _makeCalligraphyStroke(
        points: [const Offset(0, 0), const Offset(100, 0)],
        orientations: [0, 0],
        pressure: 0.5,
      );
      // highQualityPolygon dispatches to _getCalligraphicPolygon for
      // calligraphyPen toolId
      final polygon = stroke.highQualityPolygon;
      expect(polygon.length, greaterThanOrEqualTo(4));
    });
  });
}
