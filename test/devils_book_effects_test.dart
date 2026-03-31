/// 🤖 Generated wholly or partially with Claude Sonnet 4.6
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saber/devils_book/effects/live_effect_engine.dart';
import 'package:saber/devils_book/models/effect_preset.dart';
import 'package:saber/devils_book/registry/devils_catalog.dart';

void main() {
  group('ParticleType enum', () {
    test('contains the three new particle types', () {
      expect(ParticleType.values, contains(ParticleType.flameV2));
      expect(ParticleType.values, contains(ParticleType.blood));
      expect(ParticleType.values, contains(ParticleType.smoke));
    });

    test('has 10 total particle types', () {
      expect(ParticleType.values.length, 10);
    });
  });

  group('EffectPreset model', () {
    test('constructs with required fields and default values', () {
      final preset = EffectPreset(
        id: 'test_id',
        name: 'Test Effect',
      );

      expect(preset.id, 'test_id');
      expect(preset.name, 'Test Effect');
      expect(preset.particleType, ParticleType.ember);
      expect(preset.cooldownMs, 800);
      expect(preset.ignitionIntensity, 0.5);
      expect(preset.trailDensity, 0.5);
      expect(preset.fadeDuration, 0.5);
      expect(preset.particleScale, 1.0);
      expect(preset.secondaryColor, isNull);
      expect(preset.packId, isNull);
      expect(preset.character, isNull);
    });

    test('constructs flameV2 preset with all custom parameters', () {
      final preset = EffectPreset(
        id: 'effect_fire_v2',
        name: 'Hellfire Reborn',
        particleType: ParticleType.flameV2,
        ignitionColor: const Color(0xFFFFEE88),
        trailColor: const Color(0xFFFF6600),
        secondaryColor: const Color(0xFFCC1100),
        fadeColor: const Color(0xFF1A0A00),
        cooldownMs: 1400,
        trailDensity: 0.85,
        particleScale: 1.3,
        ignitionIntensity: 0.75,
        packId: 'pack_effects_premium',
      );

      expect(preset.particleType, ParticleType.flameV2);
      expect(preset.cooldownMs, 1400);
      expect(preset.secondaryColor, isNotNull);
      expect(preset.trailDensity, 0.85);
      expect(preset.particleScale, 1.3);
    });
  });

  group('DevilsCatalog effects registration', () {
    test('effects map contains effectFireV2', () {
      expect(DevilsCatalog.effects.containsKey('effect_fire_v2'), isTrue);
      final effect = DevilsCatalog.effects['effect_fire_v2']!;
      expect(effect.name, 'Hellfire Reborn');
      expect(effect.particleType, ParticleType.flameV2);
      expect(effect.packId, 'pack_effects_premium');
    });

    test('effects map contains effectBlood', () {
      expect(DevilsCatalog.effects.containsKey('effect_blood'), isTrue);
      final effect = DevilsCatalog.effects['effect_blood']!;
      expect(effect.name, 'Blood Ink');
      expect(effect.particleType, ParticleType.blood);
      expect(effect.packId, 'pack_effects_premium');
    });

    test('effects map contains effectSmoke', () {
      expect(DevilsCatalog.effects.containsKey('effect_smoke'), isTrue);
      final effect = DevilsCatalog.effects['effect_smoke']!;
      expect(effect.name, 'Dark Smoke');
      expect(effect.particleType, ParticleType.smoke);
      expect(effect.packId, 'pack_effects_premium');
    });

    test('effectFireV2 has correct color palette', () {
      final effect = DevilsCatalog.effectFireV2;
      expect(effect.ignitionColor, const Color(0xFFFFEE88));
      expect(effect.trailColor, const Color(0xFFFF6600));
      expect(effect.secondaryColor, const Color(0xFFCC1100));
      expect(effect.fadeColor, const Color(0xFF1A0A00));
      expect(effect.cooldownMs, 1400);
    });

    test('effectBlood has correct configuration', () {
      final effect = DevilsCatalog.effectBlood;
      expect(effect.ignitionColor, const Color(0xFFFF1111));
      expect(effect.trailColor, const Color(0xFFCC0011));
      expect(effect.fadeColor, const Color(0xFF330000));
      expect(effect.cooldownMs, 1100);
      expect(effect.trailDensity, 0.65);
    });

    test('effectSmoke has correct configuration', () {
      final effect = DevilsCatalog.effectSmoke;
      expect(effect.ignitionColor, const Color(0xFF888888));
      expect(effect.trailColor, const Color(0xFF555555));
      expect(effect.fadeColor, const Color(0xFF1A1A1A));
      expect(effect.cooldownMs, 1800);
      expect(effect.particleScale, 1.6);
    });
  });

  group('ComboState', () {
    test('starts with zero hits', () {
      final combo = ComboState();
      expect(combo.hitCount, 0);
      expect(combo.comboMultiplier, 1.0);
    });

    test('registerHit increments hitCount', () {
      final combo = ComboState();
      combo.registerHit();
      expect(combo.hitCount, 1);
    });

    test('comboMultiplier scales with hitCount', () {
      final combo = ComboState();
      for (int i = 0; i < 10; i++) {
        combo.registerHit();
      }
      // 1.0 + (10.clamp(0,50) / 100.0) = 1.1
      expect(combo.comboMultiplier, 1.1);
    });

    test('comboMultiplier caps at 50 hits', () {
      final combo = ComboState();
      for (int i = 0; i < 100; i++) {
        combo.registerHit();
      }
      // 1.0 + (50 / 100.0) = 1.5
      expect(combo.comboMultiplier, 1.5);
    });

    test('registerHit resets hitCount after 2000ms gap', () async {
      final combo = ComboState();
      combo.registerHit();
      combo.registerHit();
      combo.registerHit();
      expect(combo.hitCount, 3);

      // Simulate 2+ second gap by manually setting lastHit in the past
      combo.lastHit = DateTime.now().subtract(const Duration(milliseconds: 2500));
      combo.registerHit();
      expect(combo.hitCount, 1);
    });

    test('tick resets hitCount after timeout', () {
      final combo = ComboState();
      combo.registerHit();
      combo.registerHit();
      expect(combo.hitCount, 2);

      // Simulate timeout
      combo.lastHit = DateTime.now().subtract(const Duration(milliseconds: 2500));
      combo.tick();
      expect(combo.hitCount, 0);
    });

    test('tick does nothing when hitCount is already zero', () {
      final combo = ComboState();
      combo.tick();
      expect(combo.hitCount, 0);
    });
  });

  group('EmberParticle', () {
    test('constructs with default values', () {
      final particle = EmberParticle(
        position: const Offset(100, 200),
        spawnTime: DateTime.now(),
        initialSize: 10.0,
        color: Colors.red,
      );

      expect(particle.position, const Offset(100, 200));
      expect(particle.initialSize, 10.0);
      expect(particle.velocity, Offset.zero);
      expect(particle.spin, 0.0);
      expect(particle.type, ParticleType.ember);
      expect(particle.heading, 0.0);
      expect(particle.noiseOffset, 0.0);
    });

    test('constructs with flameV2 particle type', () {
      final particle = EmberParticle(
        position: Offset.zero,
        spawnTime: DateTime.now(),
        initialSize: 8.0,
        color: const Color(0xFFFFEE88),
        velocity: const Offset(1.0, -2.0),
        type: ParticleType.flameV2,
        heading: 1.5,
        noiseOffset: 42.0,
      );

      expect(particle.type, ParticleType.flameV2);
      expect(particle.velocity, const Offset(1.0, -2.0));
      expect(particle.heading, 1.5);
      expect(particle.noiseOffset, 42.0);
    });

    test('constructs with blood particle type', () {
      final particle = EmberParticle(
        position: Offset.zero,
        spawnTime: DateTime.now(),
        initialSize: 6.0,
        color: const Color(0xFFCC0011),
        type: ParticleType.blood,
      );

      expect(particle.type, ParticleType.blood);
    });

    test('constructs with smoke particle type', () {
      final particle = EmberParticle(
        position: Offset.zero,
        spawnTime: DateTime.now(),
        initialSize: 12.0,
        color: const Color(0xFF555555),
        type: ParticleType.smoke,
      );

      expect(particle.type, ParticleType.smoke);
    });
  });

  group('LiveEffectEngine', () {
    test('starts with empty particle list', () {
      final engine = LiveEffectEngine();
      expect(engine.particles, isEmpty);
      expect(engine.impactFlashes, isEmpty);
      expect(engine.screenShakeOffset, Offset.zero);
      expect(engine.auraIntensity, 0.0);
      expect(engine.isEnabled, isTrue);
    });

    test('setPreset updates activePreset', () {
      final engine = LiveEffectEngine();
      final preset = EffectPreset(
        id: 'test',
        name: 'Test',
        particleType: ParticleType.flameV2,
      );

      engine.setPreset(preset);
      expect(engine.activePreset, preset);
    });

    test('clear removes all particles and resets state', () {
      final engine = LiveEffectEngine();

      // Manually add a particle
      engine.particles.add(EmberParticle(
        position: Offset.zero,
        spawnTime: DateTime.now(),
        initialSize: 10.0,
        color: Colors.red,
      ));
      engine.screenShakeOffset = const Offset(1.0, 1.0);
      engine.combo.registerHit();

      expect(engine.particles, isNotEmpty);
      expect(engine.screenShakeOffset, isNot(Offset.zero));
      expect(engine.combo.hitCount, greaterThan(0));

      engine.clear();
      expect(engine.particles, isEmpty);
      expect(engine.screenShakeOffset, Offset.zero);
      expect(engine.combo.hitCount, 0);
    });

    test('setPreset notifies listeners', () {
      final engine = LiveEffectEngine();
      int notifyCount = 0;
      engine.addListener(() => notifyCount++);

      engine.setPreset(EffectPreset(id: 'test', name: 'Test'));
      expect(notifyCount, 1);
    });

    test('clear notifies listeners', () {
      final engine = LiveEffectEngine();
      int notifyCount = 0;
      engine.addListener(() => notifyCount++);

      engine.clear();
      expect(notifyCount, 1);
    });
  });
}
