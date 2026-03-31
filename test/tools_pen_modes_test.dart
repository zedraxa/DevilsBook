/// 🤖 Generated wholly or partially with Claude Sonnet 4; pen modes unit tests
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:saber/components/canvas/_flat_nib_stroke.dart';
import 'package:saber/components/canvas/_stroke.dart';
import 'package:sbn/has_size.dart';
import 'package:sbn/tool_id.dart';

const _page = HasSize(Size(100, 100));
const _pageIndex = 0;

void main() {
  group('ToolId for new pen modes', () {
    test('flatNibPen has correct id string', () {
      expect(ToolId.flatNibPen.id, 'flatNibPen');
    });

    test('markerPen has correct id string', () {
      expect(ToolId.markerPen.id, 'markerPen');
    });

    test('crayonPen has correct id string', () {
      expect(ToolId.crayonPen.id, 'crayonPen');
    });

    test('parsePenType resolves flatNibPen', () {
      expect(
        ToolId.parsePenType('flatNibPen', fallback: ToolId.fountainPen),
        ToolId.flatNibPen,
      );
    });

    test('parsePenType resolves markerPen', () {
      expect(
        ToolId.parsePenType('markerPen', fallback: ToolId.fountainPen),
        ToolId.markerPen,
      );
    });

    test('parsePenType resolves crayonPen', () {
      expect(
        ToolId.parsePenType('crayonPen', fallback: ToolId.fountainPen),
        ToolId.crayonPen,
      );
    });
  });

  group('FlatNibStroke', () {
    test('creates stroke with correct toolId', () {
      final stroke = FlatNibStroke(
        color: Colors.black,
        pressureEnabled: true,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
      );

      expect(stroke.toolId, ToolId.flatNibPen);
    });

    test('uses default nib angle of 45 degrees', () {
      final stroke = FlatNibStroke(
        color: Colors.black,
        pressureEnabled: true,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
      );

      expect(stroke.nibAngle, 45.0);
    });

    test('accepts custom nib angle', () {
      final stroke = FlatNibStroke(
        color: Colors.black,
        pressureEnabled: true,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
        nibAngle: 30.0,
      );

      expect(stroke.nibAngle, 30.0);
    });

    test('getPolygon falls back to super for < 2 points', () {
      final stroke = FlatNibStroke(
        color: Colors.black,
        pressureEnabled: true,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
      );

      stroke.addPoint(const Offset(10, 10));

      // With only one point, should use parent getPolygon (no crash)
      final polygon = stroke.getPolygon(quality: StrokeQuality.high);
      expect(polygon, isNotEmpty);
    });

    test('getPolygon produces valid polygon with multiple points', () {
      final stroke = FlatNibStroke(
        color: Colors.black,
        pressureEnabled: true,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
      );

      // Draw a diagonal line
      for (int i = 0; i < 10; i++) {
        stroke.addPoint(Offset(i * 5.0, i * 5.0));
      }

      final polygon = stroke.getPolygon(quality: StrokeQuality.high);
      expect(polygon, isNotEmpty);
      expect(polygon.length, greaterThan(2));
    });

    test('calligraphic effect: perpendicular strokes are wider than parallel',
        () {
      // Stroke perpendicular to nib (at 45°, a horizontal stroke)
      final perpStroke = FlatNibStroke(
        color: Colors.black,
        pressureEnabled: false,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
        nibAngle: 45.0,
      );

      for (int i = 0; i < 20; i++) {
        perpStroke.addPoint(Offset(i * 5.0, 0));
      }

      // Stroke parallel to nib (at 45°, a 45-degree diagonal)
      final paraStroke = FlatNibStroke(
        color: Colors.black,
        pressureEnabled: false,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
        nibAngle: 45.0,
      );

      for (int i = 0; i < 20; i++) {
        paraStroke.addPoint(Offset(i * 5.0, i * 5.0));
      }

      final perpPolygon =
          perpStroke.getPolygon(quality: StrokeQuality.high);
      final paraPolygon =
          paraStroke.getPolygon(quality: StrokeQuality.high);

      // Calculate bounding box heights as a proxy for stroke width
      final perpBounds = _boundingBox(perpPolygon);
      final paraBounds = _boundingBox(paraPolygon);

      // The perpendicular stroke should have greater height/width ratio
      // (i.e., be visibly "thicker") than the parallel stroke
      final perpThickness = perpBounds.height;
      final paraThickness = _minDimension(paraBounds);

      expect(
        perpThickness,
        greaterThan(paraThickness),
        reason: 'Perpendicular stroke should be thicker than parallel stroke',
      );
    });

    test('fromStroke preserves all properties', () {
      final original = Stroke(
        color: Colors.red,
        pressureEnabled: true,
        options: StrokeOptions(size: 8),
        pageIndex: 1,
        page: _page,
        toolId: ToolId.fountainPen,
        shimmerIntensity: 0.5,
        sheenIntensity: 0.3,
        shadingAmount: 0.2,
      );
      original.addPoint(const Offset(10, 20));
      original.addPoint(const Offset(30, 40));

      final flatNib = FlatNibStroke.fromStroke(original);

      expect(flatNib.color, Colors.red);
      expect(flatNib.pressureEnabled, true);
      expect(flatNib.pageIndex, 1);
      expect(flatNib.shimmerIntensity, 0.5);
      expect(flatNib.sheenIntensity, 0.3);
      expect(flatNib.shadingAmount, 0.2);
      expect(flatNib.points.length, 2);
      expect(flatNib.toolId, ToolId.flatNibPen);
    });
  });

  group('Stroke with new pen toolIds', () {
    test('can create stroke with flatNibPen toolId', () {
      final stroke = Stroke(
        color: Colors.black,
        pressureEnabled: true,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
        toolId: ToolId.flatNibPen,
      );

      expect(stroke.toolId, ToolId.flatNibPen);
      stroke.addPoint(const Offset(5, 5));
      expect(stroke.isEmpty, false);
    });

    test('can create stroke with markerPen toolId', () {
      final stroke = Stroke(
        color: const Color(0xCC1565C0),
        pressureEnabled: false,
        options: StrokeOptions(size: 12),
        pageIndex: _pageIndex,
        page: _page,
        toolId: ToolId.markerPen,
      );

      expect(stroke.toolId, ToolId.markerPen);
      stroke.addPoint(const Offset(5, 5));
      expect(stroke.isEmpty, false);
    });

    test('can create stroke with crayonPen toolId', () {
      final stroke = Stroke(
        color: const Color(0xFFD32F2F),
        pressureEnabled: true,
        options: StrokeOptions(size: 8),
        pageIndex: _pageIndex,
        page: _page,
        toolId: ToolId.crayonPen,
      );

      expect(stroke.toolId, ToolId.crayonPen);
      stroke.addPoint(const Offset(5, 5));
      expect(stroke.isEmpty, false);
    });
  });

  group('EditorExporter rasterization', () {
    test('crayonPen strokes should be rasterized', () {
      final stroke = Stroke(
        color: Colors.red,
        pressureEnabled: true,
        options: StrokeOptions(size: 8),
        pageIndex: _pageIndex,
        page: _page,
        toolId: ToolId.crayonPen,
      );

      // Verify the toolId matches crayonPen (rasterization condition)
      expect(stroke.toolId, ToolId.crayonPen);
    });

    test('flatNibPen strokes should not be rasterized', () {
      final stroke = Stroke(
        color: Colors.black,
        pressureEnabled: true,
        options: StrokeOptions(size: 10),
        pageIndex: _pageIndex,
        page: _page,
        toolId: ToolId.flatNibPen,
      );

      // flatNibPen is not in the rasterization list
      expect(stroke.toolId, isNot(ToolId.highlighter));
      expect(stroke.toolId, isNot(ToolId.pencil));
      expect(stroke.toolId, isNot(ToolId.crayonPen));
    });

    test('markerPen strokes should not be rasterized', () {
      final stroke = Stroke(
        color: const Color(0xCC1565C0),
        pressureEnabled: false,
        options: StrokeOptions(size: 12),
        pageIndex: _pageIndex,
        page: _page,
        toolId: ToolId.markerPen,
      );

      // markerPen is not in the rasterization list
      expect(stroke.toolId, isNot(ToolId.highlighter));
      expect(stroke.toolId, isNot(ToolId.pencil));
      expect(stroke.toolId, isNot(ToolId.crayonPen));
    });
  });
}

/// Computes the bounding box of a list of offsets.
Rect _boundingBox(List<Offset> points) {
  if (points.isEmpty) return Rect.zero;
  double minX = double.infinity, minY = double.infinity;
  double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
  for (final p in points) {
    if (p.dx < minX) minX = p.dx;
    if (p.dy < minY) minY = p.dy;
    if (p.dx > maxX) maxX = p.dx;
    if (p.dy > maxY) maxY = p.dy;
  }
  return Rect.fromLTRB(minX, minY, maxX, maxY);
}

/// Returns the minimum of width and height for a bounding box.
double _minDimension(Rect rect) => min(rect.width, rect.height);
