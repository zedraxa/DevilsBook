/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; GitHub Copilot ✨
library;

import 'package:flutter/material.dart';

/// The type of a [WritingMode], used to distinguish between modes
/// without requiring object identity comparisons.
enum WritingModeType {
  clean,
  performanceSaver,
  ritual,
  infernal,
}

/// Configures the atmosphere and effects rendered on the canvas while writing.
///
/// Use [WritingMode.clean] in tests and performance-sensitive contexts to
/// disable all effects and ensure stable, deterministic rendering output.
class WritingMode {
  const WritingMode({
    required this.type,
    required this.name,
    required this.description,
    required this.fxEnabled,
    required this.ghostNibEnabled,
    this.shakeEnabled = false,
    this.comboScalingEnabled = false,
    required this.maxParticles,
    this.particleScaleMultiplier = 1.0,
    this.cooldownMultiplier = 1.0,
    this.strokeExpiry,
    this.texturePath,
    this.textureOpacity = 0.0,
    this.textureBlendMode = BlendMode.multiply,
  });

  final WritingModeType type;
  final String name;
  final String description;

  final bool fxEnabled;
  final bool ghostNibEnabled;
  final bool shakeEnabled;
  final bool comboScalingEnabled;
  final int maxParticles;
  final double particleScaleMultiplier;
  final double cooldownMultiplier;

  /// If non-null, strokes expire and fade away after this duration.
  final Duration? strokeExpiry;

  // Ritual texture properties
  final String? texturePath;
  final double textureOpacity;
  final BlendMode textureBlendMode;

  /// Distraction-free, pure ink. Maximum performance. No effects.
  ///
  /// Use this mode in tests to ensure golden images are stable.
  static const WritingMode clean = WritingMode(
    type: WritingModeType.clean,
    name: 'Clean',
    description: 'Distraction-free, pure ink. Maximum performance.',
    fxEnabled: false,
    ghostNibEnabled: false,
    maxParticles: 0,
  );

  /// Battery-conscious operation. Essential hover feedback only.
  static const WritingMode performanceSaver = WritingMode(
    type: WritingModeType.performanceSaver,
    name: 'Performance Saver',
    description: 'Battery-conscious operation. Essential hover feedback only.',
    fxEnabled: false,
    ghostNibEnabled: true,
    maxParticles: 0,
  );

  /// The standard Devils Book atmosphere. Controlled ignition and subtle embers.
  static const WritingMode ritual = WritingMode(
    type: WritingModeType.ritual,
    name: 'Ritual',
    description:
        'The standard Devils Book atmosphere. Controlled ignition and subtle embers.',
    fxEnabled: true,
    ghostNibEnabled: true,
    maxParticles: 150,
  );

  /// Maximum theatricality. Unbound particle emissions and heavy canvas recoil.
  static const WritingMode infernal = WritingMode(
    type: WritingModeType.infernal,
    name: 'Infernal',
    description:
        'Maximum theatricality. Unbound particle emissions, reactive combos, and heavy canvas recoil.',
    fxEnabled: true,
    ghostNibEnabled: true,
    shakeEnabled: true,
    comboScalingEnabled: true,
    maxParticles: 400,
    particleScaleMultiplier: 1.5,
    cooldownMultiplier: 2.5,
    strokeExpiry: Duration(minutes: 2),
  );

  static const List<WritingMode> values = [
    clean,
    performanceSaver,
    ritual,
    infernal,
  ];
}
