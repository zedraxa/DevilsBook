/// 🤖 Generated wholly or partially with Claude Code
library;

import 'package:flutter/material.dart';

/// Surface type of a paper, affecting how ink interacts with and
/// appears on the page.
enum PaperSurface {
  /// Standard smooth matte finish — balanced ink flow.
  matte,

  /// High-gloss reflective surface — ink sits on top, slower drying.
  glossy,

  /// Rough, tactile grain — ink spreads slightly, organic feel.
  textured,

  /// Highly absorbent — ink dries instantly, crisp lines.
  absorbent,

  /// Semi-transparent vellum — faint see-through effect.
  vellum,

  /// Thick, cold-pressed watercolor stock — visible tooth.
  watercolor,

  /// Recycled fibres with visible speckle.
  recycled,

  /// Heavy card-stock with a satin sheen.
  satin,
}

/// A paper type combining a surface, tint, and visual metadata.
class PaperType {
  final String id;
  final String name;
  final String description;
  final PaperSurface surface;

  /// Background tint applied to the page.
  final Color tint;

  /// 0.0 = fully matte, 1.0 = mirror-like gloss.
  final double glossiness;

  /// 0.0 = no grain, 1.0 = heavy grain overlay.
  final double grainAmount;

  /// Ink absorption rate: 0.0 = slow (glossy behaviour),
  /// 1.0 = instant (blotter paper).
  final double inkAbsorption;

  /// Optional icon to show in the selector UI.
  final IconData? icon;

  const PaperType({
    required this.id,
    required this.name,
    required this.description,
    required this.surface,
    required this.tint,
    this.glossiness = 0.0,
    this.grainAmount = 0.0,
    this.inkAbsorption = 0.5,
    this.icon,
  });

  /// Serialisation key used in page style JSON.
  static PaperType? fromId(String? id) {
    if (id == null) return null;
    for (final paper in PaperCatalog.all) {
      if (paper.id == id) return paper;
    }
    return null;
  }
}

/// Built-in paper catalogue.  Organised into families for the selector UI.
abstract final class PaperCatalog {
  // ── Classic whites & creams ────────────────────────────────────────
  static const classicWhite = PaperType(
    id: 'paper_classic_white',
    name: 'Classic White',
    description: 'Standard bright-white office paper.',
    surface: PaperSurface.matte,
    tint: Color(0xFFFFFFFF),
    inkAbsorption: 0.5,
    icon: Icons.description,
  );
  static const ivorySmooth = PaperType(
    id: 'paper_ivory_smooth',
    name: 'Ivory Smooth',
    description: 'Warm cream tone, easy on the eyes.',
    surface: PaperSurface.matte,
    tint: Color(0xFFFFF8E7),
    inkAbsorption: 0.5,
    icon: Icons.note,
  );
  static const antiqueCream = PaperType(
    id: 'paper_antique_cream',
    name: 'Antique Cream',
    description: 'Deep aged parchment colour.',
    surface: PaperSurface.textured,
    tint: Color(0xFFF2E8D5),
    grainAmount: 0.15,
    inkAbsorption: 0.6,
    icon: Icons.menu_book,
  );

  // ── Coloured papers ────────────────────────────────────────────────
  static const skyBlue = PaperType(
    id: 'paper_sky_blue',
    name: 'Sky Blue',
    description: 'Pale blue — calm and focused.',
    surface: PaperSurface.matte,
    tint: Color(0xFFE3F2FD),
    inkAbsorption: 0.5,
    icon: Icons.cloud,
  );
  static const mintGreen = PaperType(
    id: 'paper_mint_green',
    name: 'Mint Green',
    description: 'Fresh pastel green for brainstorming.',
    surface: PaperSurface.matte,
    tint: Color(0xFFE8F5E9),
    inkAbsorption: 0.5,
    icon: Icons.eco,
  );
  static const lavender = PaperType(
    id: 'paper_lavender',
    name: 'Lavender',
    description: 'Soft purple for creative thinking.',
    surface: PaperSurface.matte,
    tint: Color(0xFFF3E5F5),
    inkAbsorption: 0.5,
    icon: Icons.local_florist,
  );
  static const roseQuartz = PaperType(
    id: 'paper_rose_quartz',
    name: 'Rose Quartz',
    description: 'Gentle pink warmth.',
    surface: PaperSurface.matte,
    tint: Color(0xFFFCE4EC),
    inkAbsorption: 0.5,
    icon: Icons.favorite,
  );
  static const sunflower = PaperType(
    id: 'paper_sunflower',
    name: 'Sunflower',
    description: 'Warm yellow — energising and bright.',
    surface: PaperSurface.matte,
    tint: Color(0xFFFFF9C4),
    inkAbsorption: 0.5,
    icon: Icons.wb_sunny,
  );
  static const peach = PaperType(
    id: 'paper_peach',
    name: 'Peach',
    description: 'Soft warm orange-pink tone.',
    surface: PaperSurface.matte,
    tint: Color(0xFFFFE0B2),
    inkAbsorption: 0.5,
    icon: Icons.brightness_5,
  );

  // ── Dark papers ────────────────────────────────────────────────────
  static const midnightBlack = PaperType(
    id: 'paper_midnight_black',
    name: 'Midnight Black',
    description: 'Pure black — best with white or metallic ink.',
    surface: PaperSurface.matte,
    tint: Color(0xFF121212),
    inkAbsorption: 0.4,
    icon: Icons.nights_stay,
  );
  static const deepNavy = PaperType(
    id: 'paper_deep_navy',
    name: 'Deep Navy',
    description: 'Rich dark blue for high-contrast notes.',
    surface: PaperSurface.matte,
    tint: Color(0xFF0D1B2A),
    inkAbsorption: 0.4,
    icon: Icons.dark_mode,
  );
  static const charcoal = PaperType(
    id: 'paper_charcoal',
    name: 'Charcoal',
    description: 'Dark grey for subdued contrast.',
    surface: PaperSurface.matte,
    tint: Color(0xFF2A2A2A),
    inkAbsorption: 0.4,
    icon: Icons.filter_drama,
  );
  static const forestDark = PaperType(
    id: 'paper_forest_dark',
    name: 'Forest Dark',
    description: 'Deep green, natural nocturnal ambience.',
    surface: PaperSurface.matte,
    tint: Color(0xFF0A1F0A),
    inkAbsorption: 0.4,
    icon: Icons.park,
  );
  static const crimsonVoid = PaperType(
    id: 'paper_crimson_void',
    name: 'Crimson Void',
    description: 'Blood-red darkness — infernal aesthetic.',
    surface: PaperSurface.matte,
    tint: Color(0xFF1A0505),
    inkAbsorption: 0.4,
    icon: Icons.local_fire_department,
  );

  // ── Specialty surfaces ─────────────────────────────────────────────
  static const glossyPhoto = PaperType(
    id: 'paper_glossy_photo',
    name: 'Glossy Photo',
    description: 'High-gloss finish — vivid colours, slow ink dry.',
    surface: PaperSurface.glossy,
    tint: Color(0xFFFDFDFD),
    glossiness: 0.7,
    inkAbsorption: 0.2,
    icon: Icons.photo,
  );
  static const satinPremium = PaperType(
    id: 'paper_satin_premium',
    name: 'Satin Premium',
    description: 'Subtle sheen without harsh reflections.',
    surface: PaperSurface.satin,
    tint: Color(0xFFF5F5F0),
    glossiness: 0.35,
    inkAbsorption: 0.4,
    icon: Icons.auto_awesome,
  );
  static const fastAbsorb = PaperType(
    id: 'paper_fast_absorb',
    name: 'Fast Absorb',
    description: 'Ultra-absorbent — ink dries on contact, crisp lines.',
    surface: PaperSurface.absorbent,
    tint: Color(0xFFFAF9F6),
    inkAbsorption: 1.0,
    grainAmount: 0.05,
    icon: Icons.speed,
  );
  static const watercolorColdPress = PaperType(
    id: 'paper_watercolor_cold',
    name: 'Watercolor Cold Press',
    description: 'Thick textured stock with visible tooth.',
    surface: PaperSurface.watercolor,
    tint: Color(0xFFF8F4EF),
    grainAmount: 0.3,
    inkAbsorption: 0.7,
    icon: Icons.brush,
  );
  static const recycledNatural = PaperType(
    id: 'paper_recycled_natural',
    name: 'Recycled Natural',
    description: 'Eco-friendly with visible fibre speckle.',
    surface: PaperSurface.recycled,
    tint: Color(0xFFE8E0D0),
    grainAmount: 0.2,
    inkAbsorption: 0.6,
    icon: Icons.recycling,
  );
  static const kraftBrown = PaperType(
    id: 'paper_kraft_brown',
    name: 'Kraft Brown',
    description: 'Natural brown kraft — rustic and organic.',
    surface: PaperSurface.recycled,
    tint: Color(0xFFC4A97D),
    grainAmount: 0.2,
    inkAbsorption: 0.6,
    icon: Icons.inventory_2,
  );
  static const velvetVellum = PaperType(
    id: 'paper_velvet_vellum',
    name: 'Velvet Vellum',
    description: 'Semi-transparent parchment with a soft touch.',
    surface: PaperSurface.vellum,
    tint: Color(0xFFF5EFE0),
    glossiness: 0.1,
    grainAmount: 0.08,
    inkAbsorption: 0.55,
    icon: Icons.layers,
  );
  static const texturedLinen = PaperType(
    id: 'paper_textured_linen',
    name: 'Textured Linen',
    description: 'Woven linen surface — elegant and tactile.',
    surface: PaperSurface.textured,
    tint: Color(0xFFF0EBE3),
    grainAmount: 0.25,
    inkAbsorption: 0.55,
    icon: Icons.texture,
  );

  // ── Families for UI grouping ──────────────────────────────────────
  static const List<PaperType> classics = [
    classicWhite,
    ivorySmooth,
    antiqueCream,
  ];

  static const List<PaperType> colours = [
    skyBlue,
    mintGreen,
    lavender,
    roseQuartz,
    sunflower,
    peach,
  ];

  static const List<PaperType> darks = [
    midnightBlack,
    deepNavy,
    charcoal,
    forestDark,
    crimsonVoid,
  ];

  static const List<PaperType> specialty = [
    glossyPhoto,
    satinPremium,
    fastAbsorb,
    watercolorColdPress,
    recycledNatural,
    kraftBrown,
    velvetVellum,
    texturedLinen,
  ];

  static const List<PaperType> all = [
    ...classics,
    ...colours,
    ...darks,
    ...specialty,
  ];
}
