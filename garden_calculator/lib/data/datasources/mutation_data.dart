import '../models/mutation.dart';
import '../models/rarity.dart';

/// The GrowVault mutation catalogue.
///
/// Multipliers mirror the community-documented Grow a Garden values. Growth
/// mutations (Gold, Rainbow) are mutually exclusive; environmental mutations
/// stack via the `(1 + Σmultipliers − count)` term. Known conflicting groups
/// (e.g. Wet / Chilled / Frozen) are encoded via [Mutation.conflicts].
class MutationData {
  MutationData._();

  // Convenience ARGB ints matching the palette used elsewhere.
  static const int _gold = 0xFFF59E0B;
  static const int _sky = 0xFF38BDF8;
  static const int _blue = 0xFF60A5FA;
  static const int _violet = 0xFF8B5CF6;
  static const int _rose = 0xFFF43F5E;
  static const int _emerald = 0xFF34D399;

  // -------------------- Growth (mutually exclusive) --------------------
  static const List<Mutation> growth = [
    Mutation(
      id: 'gold',
      name: 'Golden',
      multiplier: 20,
      category: MutationCategory.growth,
      color: _gold,
      description: 'A shimmering gold coat. Applies a flat ×20 to the crop.',
      conflicts: ['rainbow'],
    ),
    Mutation(
      id: 'rainbow',
      name: 'Rainbow',
      multiplier: 50,
      category: MutationCategory.growth,
      color: _violet,
      description: 'The rarest growth mutation — a flat ×50 multiplier.',
      conflicts: ['gold'],
    ),
  ];

  // -------------------- Environmental / stacking --------------------
  static const List<Mutation> environmental = [
    // Temperature / water group (mutually exclusive with each other)
    Mutation(id: 'wet', name: 'Wet', multiplier: 2, category: MutationCategory.temperature, color: _sky, description: 'Soaked by rain. ×2.', conflicts: ['chilled', 'frozen', 'drenched']),
    Mutation(id: 'chilled', name: 'Chilled', multiplier: 2, category: MutationCategory.temperature, color: _blue, description: 'Cooled by frost. ×2.', conflicts: ['wet', 'frozen']),
    Mutation(id: 'drenched', name: 'Drenched', multiplier: 5, category: MutationCategory.temperature, color: _sky, description: 'Thoroughly soaked. ×5.', conflicts: ['wet', 'frozen']),
    Mutation(id: 'frozen', name: 'Frozen', multiplier: 10, category: MutationCategory.temperature, color: _blue, description: 'Wet + Chilled during snow. ×10.', conflicts: ['wet', 'chilled', 'drenched']),
    Mutation(id: 'heated', name: 'Heated', multiplier: 3, category: MutationCategory.temperature, color: _rose, description: 'Warmed up. ×3.', conflicts: ['frozen', 'cooked', 'burnt']),
    Mutation(id: 'cooked', name: 'Cooked', multiplier: 10, category: MutationCategory.temperature, color: _rose, description: 'Cooked by fire. ×10.', conflicts: ['burnt']),
    Mutation(id: 'burnt', name: 'Burnt', multiplier: 4, category: MutationCategory.temperature, color: _rose, description: 'Scorched. ×4.', conflicts: ['cooked']),
    Mutation(id: 'molten', name: 'Molten', multiplier: 25, category: MutationCategory.temperature, color: _rose, description: 'Superheated by an eruption. ×25.'),

    // Nature / environmental
    Mutation(id: 'chocolate', name: 'Chocolate', multiplier: 2, category: MutationCategory.environmental, color: _gold, description: 'Chocolate-coated. ×2.'),
    Mutation(id: 'pollinated', name: 'Pollinated', multiplier: 3, category: MutationCategory.environmental, color: _gold, description: 'Bee-blessed. ×3.'),
    Mutation(id: 'sandy', name: 'Sandy', multiplier: 3, category: MutationCategory.environmental, color: _gold, description: 'Coated in sand. ×3.'),
    Mutation(id: 'clay', name: 'Clay', multiplier: 3, category: MutationCategory.environmental, color: _gold, description: 'Clay-dusted. ×3.'),
    Mutation(id: 'honeyglazed', name: 'Honey Glazed', multiplier: 5, category: MutationCategory.environmental, color: _gold, description: 'Coated in honey. ×5.'),
    Mutation(id: 'plasma', name: 'Plasma', multiplier: 5, category: MutationCategory.environmental, color: _violet, description: 'Charged with plasma. ×5.'),
    Mutation(id: 'twisted', name: 'Twisted', multiplier: 5, category: MutationCategory.environmental, color: _emerald, description: 'Warped by a tornado. ×5.'),
    Mutation(id: 'verdant', name: 'Verdant', multiplier: 4, category: MutationCategory.environmental, color: _emerald, description: 'Lush and verdant. ×4.'),
    Mutation(id: 'wiltproof', name: 'Wiltproof', multiplier: 4, category: MutationCategory.environmental, color: _emerald, description: 'Resistant to wilting. ×4.'),
    Mutation(id: 'ceramic', name: 'Ceramic', multiplier: 30, category: MutationCategory.environmental, color: _gold, description: 'Kiln-hardened. ×30.'),
    Mutation(id: 'amber', name: 'Amber', multiplier: 10, category: MutationCategory.environmental, color: _gold, description: 'Encased in amber. ×10.'),
    Mutation(id: 'radioactive', name: 'Radioactive', multiplier: 20, category: MutationCategory.environmental, color: _emerald, description: 'Irradiated glow. ×20.'),
    Mutation(id: 'zombified', name: 'Zombified', multiplier: 25, category: MutationCategory.environmental, color: _emerald, description: 'Undead touch. ×25.'),

    // Cosmic
    Mutation(id: 'moonlit', name: 'Moonlit', multiplier: 2, category: MutationCategory.cosmic, color: _violet, description: 'Bathed in moonlight. ×2.'),
    Mutation(id: 'bloodlit', name: 'Bloodlit', multiplier: 4, category: MutationCategory.cosmic, color: _rose, description: 'Blood-moon glow. ×4.'),
    Mutation(id: 'aurora', name: 'Aurora', multiplier: 90, category: MutationCategory.cosmic, color: _violet, description: 'Aurora-charged. ×90.'),
    Mutation(id: 'shocked', name: 'Shocked', multiplier: 100, category: MutationCategory.cosmic, color: _gold, description: 'Struck by lightning. ×100.'),
    Mutation(id: 'celestial', name: 'Celestial', multiplier: 120, category: MutationCategory.cosmic, color: _violet, description: 'Touched by the stars. ×120.'),
    Mutation(id: 'disco', name: 'Disco', multiplier: 125, category: MutationCategory.cosmic, color: _rose, description: 'Groovy disco shimmer. ×125.'),
    Mutation(id: 'meteoric', name: 'Meteoric', multiplier: 125, category: MutationCategory.cosmic, color: _rose, description: 'Meteor-forged. ×125.'),
    Mutation(id: 'voidtouched', name: 'Voidtouched', multiplier: 135, category: MutationCategory.cosmic, color: _violet, description: 'Warped by the void. ×135.'),

    // Special / event
    Mutation(id: 'dawnlit', name: 'Dawnlit', multiplier: 4, category: MutationCategory.special, color: _gold, description: 'Kissed by dawn. ×4.'),
    Mutation(id: 'paradisal', name: 'Paradisal', multiplier: 100, category: MutationCategory.special, color: _emerald, description: 'Paradise event. ×100.'),
    Mutation(id: 'alienlike', name: 'Alienlike', multiplier: 100, category: MutationCategory.special, color: _emerald, description: 'Otherworldly. ×100.'),
    Mutation(id: 'galactic', name: 'Galactic', multiplier: 120, category: MutationCategory.special, color: _sky, description: 'Galaxy-infused. ×120.'),
    Mutation(id: 'sundried', name: 'Sundried', multiplier: 85, category: MutationCategory.special, color: _gold, description: 'Dried under a harsh sun. ×85.'),
    Mutation(id: 'friendbound', name: 'Friendbound', multiplier: 70, category: MutationCategory.special, color: _rose, description: 'Bound by friendship. ×70.'),
  ];

  static List<Mutation> get all => [...growth, ...environmental];

  static Mutation? byId(String id) {
    for (final m in all) {
      if (m.id == id) return m;
    }
    return null;
  }

  static List<Mutation> ofCategory(MutationCategory category) =>
      all.where((m) => m.category == category).toList();
}
