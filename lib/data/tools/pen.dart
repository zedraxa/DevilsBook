/// 🤖 Generated wholly or partially with Claude Sonnet 4.5; pen modes expansion
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:saber/components/canvas/_stroke.dart';
import 'package:saber/data/editor/page.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/tools/_tool.dart';
import 'package:saber/data/tools/highlighter.dart';
import 'package:saber/data/tools/pencil.dart';
import 'package:saber/i18n/strings.g.dart';
import 'package:sbn/tool_id.dart';

class Pen extends Tool {
  @protected
  @visibleForTesting
  Pen({
    required this.name,
    required this.sizeMin,
    required this.sizeMax,
    required this.sizeStep,
    required this.icon,
    required this.options,
    required this.pressureEnabled,
    required this.color,
    required this.toolId,
  });

  Pen.fountainPen()
    : name = t.editor.pens.fountainPen,
      sizeMin = 1,
      sizeMax = 25,
      sizeStep = 1,
      icon = fountainPenIcon,
      options = stows.lastFountainPenOptions.value,
      pressureEnabled = true,
      color = Color(stows.lastFountainPenColor.value),
      toolId = .fountainPen;

  Pen.ballpointPen()
    : name = t.editor.pens.ballpointPen,
      sizeMin = 1,
      sizeMax = 25,
      sizeStep = 1,
      icon = ballpointPenIcon,
      options = stows.lastBallpointPenOptions.value,
      pressureEnabled = false,
      color = Color(stows.lastBallpointPenColor.value),
      toolId = .ballpointPen;

  final String name;
  final double sizeMin, sizeMax, sizeStep;
  late final int sizeStepsBetweenMinAndMax = ((sizeMax - sizeMin) / sizeStep)
      .round();
  final Object icon;

  @override
  final ToolId toolId;

  static const fountainPenIcon = FontAwesomeIcons.penFancy;
  static const ballpointPenIcon = FontAwesomeIcons.pen;
  static const flatNibPenIcon = FontAwesomeIcons.italic;
  static const markerPenIcon = FontAwesomeIcons.paintbrush;
  static const crayonPenIcon = FontAwesomeIcons.penRuler;

  static Stroke? currentStroke;
  Color color;
  bool pressureEnabled;
  StrokeOptions options;

  static var _currentPen = Pen.fountainPen();
  static Pen get currentPen => _currentPen;
  static set currentPen(Pen currentPen) {
    assert(
      currentPen is! Highlighter,
      'Use Highlighter.currentHighlighter instead',
    );
    assert(currentPen is! Pencil, 'Use Pencil.currentPencil instead');
    _currentPen = currentPen;
  }

  /// Creates a pen from a [ToolId], restoring preferences for the given pen type.
  static Pen fromToolId(ToolId toolId) {
    return switch (toolId) {
      ToolId.fountainPen => Pen.fountainPen(),
      ToolId.ballpointPen => Pen.ballpointPen(),
      ToolId.flatNibPen => Pen(
        name: t.editor.pens.flatNibPen,
        sizeMin: 1,
        sizeMax: 25,
        sizeStep: 1,
        icon: flatNibPenIcon,
        options: stows.lastFlatNibPenOptions.value,
        pressureEnabled: true,
        color: Color(stows.lastFlatNibPenColor.value),
        toolId: ToolId.flatNibPen,
      ),
      ToolId.markerPen => Pen(
        name: t.editor.pens.markerPen,
        sizeMin: 5,
        sizeMax: 60,
        sizeStep: 5,
        icon: markerPenIcon,
        options: stows.lastMarkerPenOptions.value,
        pressureEnabled: false,
        color: Color(stows.lastMarkerPenColor.value),
        toolId: ToolId.markerPen,
      ),
      ToolId.crayonPen => Pen(
        name: t.editor.pens.crayonPen,
        sizeMin: 2,
        sizeMax: 20,
        sizeStep: 1,
        icon: crayonPenIcon,
        options: stows.lastCrayonPenOptions.value,
        pressureEnabled: true,
        color: Color(stows.lastCrayonPenColor.value),
        toolId: ToolId.crayonPen,
      ),
      _ => Pen.fountainPen(),
    };
  }

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
    currentStroke = Stroke(
      color: color,
      pressureEnabled: pressureEnabled,
      options: options.copyWith(isComplete: false),
      pageIndex: pageIndex,
      page: page,
      toolId: toolId,
      shimmerIntensity: shimmerIntensity ?? 0.0,
      shimmerColor: shimmerColor,
      sheenIntensity: sheenIntensity ?? 0.0,
      sheenColor: sheenColor,
      shadingAmount: shadingAmount ?? 0.0,
      expiry: expiry,
    );
    onDragUpdate(position, pressure);
  }

  void onDragUpdate(Offset position, double? pressure) {
    currentStroke?.addPoint(position, pressure);
  }

  Stroke? onDragEnd() {
    final stroke = currentStroke;
    currentStroke = null;
    if (stroke == null) return null;

    return stroke
      ..options.isComplete = true
      ..markPolygonNeedsUpdating();
  }

  /// The default stroke options.
  ///
  /// Note that these are different to the default options in [StrokeOptions]
  /// e.g. [StrokeOptions.defaultSize] for historical reasons
  /// (i.e. [StrokeOptions.toJson] does not include default values.)
  static final defaultOptions = StrokeOptions(size: 5);

  static StrokeOptions get fountainPenOptions => defaultOptions.copyWith();
  static StrokeOptions get ballpointPenOptions => defaultOptions.copyWith();
  static StrokeOptions get flatNibPenOptions => defaultOptions.copyWith(
    thinning: 0.9,
    smoothing: 0.5,
    streamline: 0.4,
    start: StrokeEndOptions.start(taperEnabled: true, customTaper: 0.5),
    end: StrokeEndOptions.end(taperEnabled: true, customTaper: 0.5),
  );
  static StrokeOptions get markerPenOptions => defaultOptions.copyWith(
    size: 12,
    thinning: 0.0,
    smoothing: 0.5,
    streamline: 0.5,
  );
  static StrokeOptions get crayonPenOptions => defaultOptions.copyWith(
    thinning: 0.6,
    smoothing: 0.3,
    streamline: 0.2,
    start: StrokeEndOptions.start(taperEnabled: true, customTaper: 0.8),
    end: StrokeEndOptions.end(taperEnabled: true, customTaper: 0.8),
  );
  static StrokeOptions get shapePenOptions =>
      defaultOptions.copyWith(smoothing: 0, streamline: 0);
  static StrokeOptions get highlighterOptions =>
      defaultOptions.copyWith(size: 50);
  static StrokeOptions get pencilOptions => defaultOptions.copyWith(
    streamline: 0.1,
    start: StrokeEndOptions.start(taperEnabled: true, customTaper: 1),
    end: StrokeEndOptions.end(taperEnabled: true, customTaper: 1),
  );
}
