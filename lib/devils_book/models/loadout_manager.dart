/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot
library;

import 'package:flutter/material.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/tools/pen.dart';
import 'package:saber/devils_book/ambience/ambience_registry.dart';
import 'package:saber/devils_book/ambience/ambient_audio_controller.dart';
import 'package:saber/devils_book/models/effect_preset.dart';
import 'package:saber/devils_book/models/ink_preset.dart';
import 'package:saber/devils_book/models/loadout.dart';
import 'package:saber/devils_book/models/relic_element.dart';
import 'package:saber/devils_book/models/theme_preset.dart';
import 'package:saber/devils_book/registry/devils_catalog.dart';

class LoadoutManager extends ChangeNotifier {
  static final _instance = LoadoutManager._internal();
  factory LoadoutManager() => _instance;
  LoadoutManager._internal() {
    _loadFromPrefs();
  }

  late Loadout _currentLoadout;
  EffectPreset? _customEffect;
  ThemePreset? _customTheme;
  InkPreset? _customInk;
  RelicElement? _customRelic;
  var _isSessionOverride = false;

  Loadout get currentLoadout => _currentLoadout;
  EffectPreset? get customEffect => _customEffect;
  ThemePreset? get customTheme => _customTheme;
  InkPreset? get customInk => _customInk;
  RelicElement? get customRelic => _customRelic;
  bool get isSessionOverride => _isSessionOverride;

  /// The effective ink, considering custom overrides.
  InkPreset get activeInk => _customInk ?? _currentLoadout.ink;

  void _loadFromPrefs() {
    final id = stows.activeLoadoutId.value;
    _currentLoadout = DevilsCatalog.loadouts[id] ?? DevilsCatalog.defaultLoadout;

    final effectId = stows.activeEffectId.value;
    if (effectId.isNotEmpty) {
      _customEffect = DevilsCatalog.effects[effectId];
    }
    
    final themeId = stows.activeThemeId.value;
    if (themeId.isNotEmpty) {
      _customTheme = DevilsCatalog.themes[themeId];
    }

    final inkId = stows.activeInkId.value;
    if (inkId.isNotEmpty) {
      _customInk = DevilsCatalog.inks[inkId];
    }

    final relicId = stows.activeRelicId.value;
    if (relicId.isNotEmpty) {
      _customRelic = DevilsCatalog.relics[relicId];
    }
    
    _isSessionOverride = false;
    _updateAmbience();
  }

  void _updateAmbience() {
    final theme = _customTheme ?? _currentLoadout.theme;
    if (theme.ambientId != null) {
      final ambience = AmbienceRegistry.all[theme.ambientId];
      AmbientAudioController().setAmbience(ambience);
    } else {
      AmbientAudioController().setAmbience(null);
    }
  }

  /// Sets the loadout for the current session.
  /// If [persist] is true, it also updates the global default in [stows].
  void setLoadout(Loadout loadout, {bool persist = true}) {
    if (_currentLoadout.id != loadout.id) {
      _currentLoadout = loadout;
      _customEffect = null; 
      _customTheme = null;
      _customInk = null;
      _customRelic = null;
      if (persist) {
        stows.activeLoadoutId.value = loadout.id;
        stows.activeEffectId.value = ''; 
        stows.activeThemeId.value = '';
        stows.activeInkId.value = '';
        stows.activeRelicId.value = '';
        _isSessionOverride = false;
      } else {
        _isSessionOverride = true;
      }
      _updateAmbience();
      notifyListeners();
    }
  }

  void setCustomEffect(EffectPreset effect, {bool persist = true}) {
    if (_customEffect?.id != effect.id) {
      _customEffect = effect;
      if (persist) {
        stows.activeEffectId.value = effect.id;
      }
      notifyListeners();
    }
  }

  void setCustomTheme(ThemePreset theme, {bool persist = true}) {
    if (_customTheme?.id != theme.id) {
      _customTheme = theme;
      if (persist) {
        stows.activeThemeId.value = theme.id;
      }
      _updateAmbience();
      notifyListeners();
    }
  }

  void setCustomInk(InkPreset ink, {bool persist = true}) {
    if (_customInk?.id != ink.id) {
      _customInk = ink;
      if (persist) {
        stows.activeInkId.value = ink.id;
      }
      notifyListeners();
    }
  }

  void setCustomRelic(RelicElement relic, {bool persist = true}) {
    if (_customRelic?.id != relic.id) {
      _customRelic = relic;
      if (persist) {
        stows.activeRelicId.value = relic.id;
      }
      notifyListeners();
    }
  }

  /// Applies the current loadout's ink and size directly to the provided [pen].
  void applyToPen(Pen pen) {
    final ink = activeInk;
    pen.color = ink.baseColor;
    pen.options = pen.options.copyWith(size: ink.defaultThickness);
  }
}
