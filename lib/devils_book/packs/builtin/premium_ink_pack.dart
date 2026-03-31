/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot
library;

import 'package:saber/devils_book/packs/content_pack.dart';
import 'package:saber/devils_book/packs/pack_category.dart';
import 'package:saber/devils_book/packs/pack_manifest.dart';
import 'package:saber/devils_book/registry/devils_catalog.dart';

/// Premium Real-World Ink Pack — World-famous fountain pen inks simulated.
class PremiumInkPack {
  static final _manifest = PackManifest(
    id: 'pack_inks_premium_vault',
    name: 'Premium Ink Vault',
    description: 'A collection of world-famous fountain pen inks, meticulously analyzed for their unique sheen, shimmer, and shading properties.',
    categories: {PackCategory.inks},
    isBuiltIn: true,
  );

  static final _inks = [
    DevilsCatalog.inkSheenMachine,
    DevilsCatalog.inkEmeraldChivor,
    DevilsCatalog.inkOsNitrogen,
    DevilsCatalog.inkYamaBudo,
    DevilsCatalog.inkApacheSunset,
    DevilsCatalog.inkBlueLightning,
    DevilsCatalog.inkOxblood,
    DevilsCatalog.inkManyoHaha,
    DevilsCatalog.inkFireIce,
    DevilsCatalog.inkJackFrost,
  ];

  static ContentPack create() => ContentPack(manifest: _manifest, inks: _inks);
}
