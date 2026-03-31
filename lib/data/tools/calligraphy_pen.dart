/// 🤖 Generated wholly or partially with Claude Sonnet 4 ✨
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/tools/pen.dart';
import 'package:saber/i18n/strings.g.dart';

/// A pen tool that renders calligraphic strokes whose width varies with the
/// angle between the stroke direction and the physical nib orientation.
///
/// When used with an Apple Pencil Pro (which reports barrel-roll angle),
/// the nib orientation comes from the real hardware. On other devices,
/// a fixed 45° nib angle is used as a sensible default.
class CalligraphyPen extends Pen {
  CalligraphyPen()
    : super(
        name: t.editor.pens.calligraphyPen,
        sizeMin: 1,
        sizeMax: 25,
        sizeStep: 1,
        icon: calligraphyPenIcon,
        options: stows.lastCalligraphyPenOptions.value,
        pressureEnabled: true,
        color: Color(stows.lastCalligraphyPenColor.value),
        toolId: .calligraphyPen,
      );

  static const calligraphyPenIcon = FontAwesomeIcons.penNib;
}
