/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot
library;

import 'package:saber/devils_book/models/effect_preset.dart';
import 'package:saber/devils_book/models/ink_preset.dart';
import 'package:saber/devils_book/models/loadout.dart';
import 'package:saber/devils_book/models/theme_preset.dart';
import 'package:saber/devils_book/models/writing_mode.dart';

/// A combined configuration bridging Theme, Ink, Effect, and WritingMode.
/// Used to represent a specialized "Writing Instrument" or mood setting.
class Loadout {
  final String id;
  final String name;
  final ThemePreset theme;
  final InkPreset ink;
  final EffectPreset effect;
  final WritingMode? preferredMode;

  Loadout({
    required this.id,
    required this.name,
    required this.theme,
    required this.ink,
    required this.effect,
    this.preferredMode,
  });
}
