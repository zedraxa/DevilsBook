/// 🤖 Generated wholly or partially with Claude Sonnet 4.5; flat-nib calligraphy pen
library;

import 'package:flutter/material.dart';
import 'package:saber/components/canvas/_flat_nib_stroke.dart';
import 'package:saber/components/canvas/_stroke.dart';
import 'package:saber/data/editor/page.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/tools/pen.dart';
import 'package:saber/i18n/strings.g.dart';
import 'package:sbn/tool_id.dart';

/// A calligraphy pen with a flat nib.
///
/// The stroke width varies with the direction of movement relative to the
/// nib angle (default 45°), producing the classic thick/thin calligraphy effect.
class FlatNibPen extends Pen {
  FlatNibPen({this.nibAngle = 45.0})
    : super(
        name: t.editor.pens.flatNibPen,
        sizeMin: 1,
        sizeMax: 25,
        sizeStep: 1,
        icon: Pen.flatNibPenIcon,
        options: stows.lastFlatNibPenOptions.value,
        pressureEnabled: true,
        color: Color(stows.lastFlatNibPenColor.value),
        toolId: ToolId.flatNibPen,
      );

  /// The nib angle in degrees (clockwise from horizontal). Default is 45°.
  final double nibAngle;

  static FlatNibPen currentFlatNibPen = FlatNibPen();

  @override
  void onDragStart(
    Offset position,
    EditorPage page,
    int pageIndex,
    double? pressure, {
    double? shimmerIntensity,
    Color? shimmerColor,
    double? sheenIntensity,
    Color? sheenColor,
    double? shadingAmount,
    Duration? expiry,
  }) {
    Pen.currentStroke = FlatNibStroke(
      color: color,
      pressureEnabled: pressureEnabled,
      options: options.copyWith(isComplete: false),
      pageIndex: pageIndex,
      page: page,
      nibAngle: nibAngle,
      shimmerIntensity: shimmerIntensity ?? 0.0,
      shimmerColor: shimmerColor,
      sheenIntensity: sheenIntensity ?? 0.0,
      sheenColor: sheenColor,
      shadingAmount: shadingAmount ?? 0.0,
      expiry: expiry,
    );
    onDragUpdate(position, pressure);
  }

  @override
  Stroke? onDragEnd() {
    final stroke = Pen.currentStroke;
    Pen.currentStroke = null;
    if (stroke == null) return null;

    return stroke
      ..options.isComplete = true
      ..markPolygonNeedsUpdating();
  }
}
