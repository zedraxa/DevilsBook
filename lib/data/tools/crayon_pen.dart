/// 🤖 Generated wholly or partially with Claude Sonnet 4.5; crayon pen
library;

import 'package:flutter/material.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/tools/pen.dart';
import 'package:saber/i18n/strings.g.dart';
import 'package:sbn/tool_id.dart';

/// A crayon pen with a rough, textured stroke.
///
/// Uses a dedicated GLSL shader to simulate the grainy, uneven texture
/// of a wax crayon on paper.
class CrayonPen extends Pen {
  CrayonPen()
    : super(
        name: t.editor.pens.crayonPen,
        sizeMin: 2,
        sizeMax: 20,
        sizeStep: 1,
        icon: Pen.crayonPenIcon,
        options: stows.lastCrayonPenOptions.value,
        pressureEnabled: true,
        color: Color(stows.lastCrayonPenColor.value),
        toolId: ToolId.crayonPen,
      );

  static CrayonPen currentCrayonPen = CrayonPen();
}
