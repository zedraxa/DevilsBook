/// 🤖 Generated wholly or partially with Claude Sonnet 4.5; felt-tip marker pen
library;

import 'package:flutter/material.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/tools/pen.dart';
import 'package:saber/i18n/strings.g.dart';
import 'package:sbn/tool_id.dart';

/// A felt-tip marker pen.
///
/// Produces a uniform-width stroke with a semi-transparent, saturated color.
/// Unlike the fountain pen, it does not taper or thin with pressure.
class MarkerPen extends Pen {
  MarkerPen()
    : super(
        name: t.editor.pens.markerPen,
        sizeMin: 5,
        sizeMax: 60,
        sizeStep: 5,
        icon: Pen.markerPenIcon,
        options: stows.lastMarkerPenOptions.value,
        pressureEnabled: false,
        color: Color(stows.lastMarkerPenColor.value),
        toolId: ToolId.markerPen,
      );

  static MarkerPen currentMarkerPen = MarkerPen();
}
