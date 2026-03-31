/// 🤖 Generated wholly or partially with Claude Code (claude-sonnet-4-5-20250929)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saber/devils_book/models/theme_preset.dart';
import 'package:saber/devils_book/registry/devils_catalog.dart';
import 'package:saber/data/editor/canvas_background_pattern.dart';

void main() {
  group('DevilsCatalog themes registration', () {
    test('themes map contains themeCrimsonRed', () {
      expect(DevilsCatalog.themes.containsKey('theme_crimson_red'), isTrue);
      final theme = DevilsCatalog.themes['theme_crimson_red']!;
      expect(theme.name, 'Crimson Red');
      expect(theme.packId, 'pack_notebooks_mystic');
    });

    test('themes map contains themeOldDesk', () {
      expect(DevilsCatalog.themes.containsKey('theme_old_desk'), isTrue);
      final theme = DevilsCatalog.themes['theme_old_desk']!;
      expect(theme.name, 'Old Desk');
      expect(theme.packId, 'pack_notebooks_mystic');
    });

    test('themes map contains themePoison', () {
      expect(DevilsCatalog.themes.containsKey('theme_poison'), isTrue);
      final theme = DevilsCatalog.themes['theme_poison']!;
      expect(theme.name, 'Poison');
      expect(theme.packId, 'pack_notebooks_mystic');
    });

    test('themes map contains themePurpleKill', () {
      expect(DevilsCatalog.themes.containsKey('theme_purple_kill'), isTrue);
      final theme = DevilsCatalog.themes['theme_purple_kill']!;
      expect(theme.name, 'Purple Kill');
      expect(theme.packId, 'pack_notebooks_mystic');
    });

    test('themes map contains themeHolyWhite', () {
      expect(DevilsCatalog.themes.containsKey('theme_holy_white'), isTrue);
      final theme = DevilsCatalog.themes['theme_holy_white']!;
      expect(theme.name, 'Holy White');
      expect(theme.packId, 'pack_notebooks_mystic');
    });

    test('themeCrimsonRed has correct color palette', () {
      final theme = DevilsCatalog.themeCrimsonRed;
      expect(theme.backgroundColor, const Color(0xFF8B0000));
      expect(theme.secondaryColor, const Color(0xFFDC143C));
      expect(theme.accentGlow, const Color(0xFFFF0000));
      expect(theme.surfaceColor, const Color(0xFFA00000));
      expect(theme.lineColor, const Color(0x33FFFFFF));
      expect(theme.customAuraColor, const Color(0xFFDC143C));
      expect(theme.pattern, CanvasBackgroundPattern.none);
    });

    test('themeCrimsonRed has correct visual effects', () {
      final theme = DevilsCatalog.themeCrimsonRed;
      expect(theme.vignetteIntensity, 0.4);
      expect(theme.grainIntensity, 0.08);
      expect(theme.backgroundGradient, isNotNull);
      expect(theme.backgroundGradient!.length, 2);
      expect(theme.backgroundGradient![0], const Color(0xFFB22222));
      expect(theme.backgroundGradient![1], const Color(0xFF8B0000));
    });

    test('themeOldDesk has correct color palette', () {
      final theme = DevilsCatalog.themeOldDesk;
      expect(theme.backgroundColor, const Color(0xFFDEB887));
      expect(theme.secondaryColor, const Color(0xFFD2B48C));
      expect(theme.accentGlow, const Color(0xFF8B4513));
      expect(theme.surfaceColor, const Color(0xFFCD853F));
      expect(theme.lineColor, const Color(0x558B4513));
      expect(theme.pattern, CanvasBackgroundPattern.lined);
    });

    test('themeOldDesk has correct visual effects', () {
      final theme = DevilsCatalog.themeOldDesk;
      expect(theme.vignetteIntensity, 0.3);
      expect(theme.grainIntensity, 0.25);
      expect(theme.backgroundGradient, isNotNull);
      expect(theme.backgroundGradient!.length, 2);
      expect(theme.backgroundGradient![0], const Color(0xFFF5DEB3));
      expect(theme.backgroundGradient![1], const Color(0xFFDEB887));
    });

    test('themePoison has correct color palette', () {
      final theme = DevilsCatalog.themePoison;
      expect(theme.backgroundColor, const Color(0xFF0A1A0A));
      expect(theme.secondaryColor, const Color(0xFF1A3A1A));
      expect(theme.accentGlow, const Color(0xFF00FF00));
      expect(theme.surfaceColor, const Color(0xFF0D2A0D));
      expect(theme.lineColor, const Color(0x4400FF00));
      expect(theme.customAuraColor, const Color(0xFF39FF14));
      expect(theme.pattern, CanvasBackgroundPattern.dots);
    });

    test('themePoison has correct visual effects', () {
      final theme = DevilsCatalog.themePoison;
      expect(theme.vignetteIntensity, 0.65);
      expect(theme.grainIntensity, 0.1);
      expect(theme.backgroundGradient, isNotNull);
      expect(theme.backgroundGradient!.length, 2);
      expect(theme.backgroundGradient![0], const Color(0xFF0F2F0F));
      expect(theme.backgroundGradient![1], const Color(0xFF050F05));
    });

    test('themePurpleKill has correct color palette', () {
      final theme = DevilsCatalog.themePurpleKill;
      expect(theme.backgroundColor, const Color(0xFF1A0A1A));
      expect(theme.secondaryColor, const Color(0xFF2A0A2A));
      expect(theme.accentGlow, const Color(0xFF9400D3));
      expect(theme.surfaceColor, const Color(0xFF1F0F1F));
      expect(theme.lineColor, const Color(0x44AA00FF));
      expect(theme.customAuraColor, const Color(0xFF8A2BE2));
      expect(theme.pattern, CanvasBackgroundPattern.grid);
    });

    test('themePurpleKill has correct visual effects', () {
      final theme = DevilsCatalog.themePurpleKill;
      expect(theme.vignetteIntensity, 0.7);
      expect(theme.grainIntensity, 0.12);
      expect(theme.backgroundGradient, isNotNull);
      expect(theme.backgroundGradient!.length, 2);
      expect(theme.backgroundGradient![0], const Color(0xFF2A0A2A));
      expect(theme.backgroundGradient![1], const Color(0xFF0A000A));
    });

    test('themeHolyWhite has correct color palette', () {
      final theme = DevilsCatalog.themeHolyWhite;
      expect(theme.backgroundColor, const Color(0xFFFFFFF0));
      expect(theme.secondaryColor, const Color(0xFFFFFAFA));
      expect(theme.accentGlow, const Color(0xFFFFD700));
      expect(theme.surfaceColor, const Color(0xFFFFFAF0));
      expect(theme.lineColor, const Color(0x22D4AF37));
      expect(theme.customAuraColor, const Color(0xFFFFFFFF));
      expect(theme.pattern, CanvasBackgroundPattern.none);
    });

    test('themeHolyWhite has correct visual effects', () {
      final theme = DevilsCatalog.themeHolyWhite;
      expect(theme.vignetteIntensity, 0.15);
      expect(theme.grainIntensity, 0.02);
      expect(theme.backgroundGradient, isNotNull);
      expect(theme.backgroundGradient!.length, 2);
      expect(theme.backgroundGradient![0], const Color(0xFFFFFFFF));
      expect(theme.backgroundGradient![1], const Color(0xFFFFFFF0));
    });
  });

  group('ThemePreset model validation', () {
    test('all new themes have valid IDs', () {
      final themeIds = [
        DevilsCatalog.themeCrimsonRed.id,
        DevilsCatalog.themeOldDesk.id,
        DevilsCatalog.themePoison.id,
        DevilsCatalog.themePurpleKill.id,
        DevilsCatalog.themeHolyWhite.id,
      ];

      for (final id in themeIds) {
        expect(id, isNotEmpty);
        expect(id, startsWith('theme_'));
      }
    });

    test('all new themes have non-null required properties', () {
      final themes = [
        DevilsCatalog.themeCrimsonRed,
        DevilsCatalog.themeOldDesk,
        DevilsCatalog.themePoison,
        DevilsCatalog.themePurpleKill,
        DevilsCatalog.themeHolyWhite,
      ];

      for (final theme in themes) {
        expect(theme.id, isNotEmpty);
        expect(theme.name, isNotEmpty);
        expect(theme.backgroundColor, isNotNull);
        expect(theme.secondaryColor, isNotNull);
        expect(theme.pattern, isNotNull);
        expect(theme.lineColor, isNotNull);
        expect(theme.accentGlow, isNotNull);
        expect(theme.surfaceColor, isNotNull);
      }
    });

    test('all new themes have valid intensity values', () {
      final themes = [
        DevilsCatalog.themeCrimsonRed,
        DevilsCatalog.themeOldDesk,
        DevilsCatalog.themePoison,
        DevilsCatalog.themePurpleKill,
        DevilsCatalog.themeHolyWhite,
      ];

      for (final theme in themes) {
        expect(theme.vignetteIntensity, inInclusiveRange(0.0, 1.0),
            reason: '${theme.name} vignetteIntensity should be between 0 and 1');
        expect(theme.grainIntensity, inInclusiveRange(0.0, 1.0),
            reason: '${theme.name} grainIntensity should be between 0 and 1');
      }
    });

    test('all new themes are properly registered in themes map', () {
      final themes = [
        DevilsCatalog.themeCrimsonRed,
        DevilsCatalog.themeOldDesk,
        DevilsCatalog.themePoison,
        DevilsCatalog.themePurpleKill,
        DevilsCatalog.themeHolyWhite,
      ];

      for (final theme in themes) {
        expect(DevilsCatalog.themes.containsKey(theme.id), isTrue,
            reason: '${theme.name} should be registered in themes map');
        expect(DevilsCatalog.themes[theme.id], equals(theme),
            reason: 'themes map should contain the same instance');
      }
    });
  });

  group('Theme contrast and accessibility', () {
    test('dark themes have dark backgrounds', () {
      final darkThemes = [
        DevilsCatalog.themeCrimsonRed,
        DevilsCatalog.themePoison,
        DevilsCatalog.themePurpleKill,
      ];

      for (final theme in darkThemes) {
        final luminance = theme.backgroundColor.computeLuminance();
        expect(luminance, lessThan(0.3),
            reason: '${theme.name} should have a dark background (low luminance)');
      }
    });

    test('light themes have light backgrounds', () {
      final lightThemes = [
        DevilsCatalog.themeOldDesk,
        DevilsCatalog.themeHolyWhite,
      ];

      for (final theme in lightThemes) {
        final luminance = theme.backgroundColor.computeLuminance();
        expect(luminance, greaterThan(0.5),
            reason: '${theme.name} should have a light background (high luminance)');
      }
    });
  });
}
