import '../models/crop.dart';
import '../models/rarity.dart';

/// The GrowVault crop catalogue.
///
/// Values are modelled on the Grow a Garden economy (sheckle base price at the
/// crop's average/base weight). Numbers are curated to stay internally
/// consistent for the calculator; they can be tuned in one place here without
/// touching UI or logic.
class CropData {
  CropData._();

  static const List<Crop> all = [
    // ---------------- Common ----------------
    Crop(id: 'carrot', name: 'Carrot', baseValue: 18, baseWeight: 0.24, rarity: Rarity.common, emoji: '🥕'),
    Crop(id: 'strawberry', name: 'Strawberry', baseValue: 14, baseWeight: 0.29, rarity: Rarity.common, emoji: '🍓', multiHarvest: true),
    Crop(id: 'blueberry', name: 'Blueberry', baseValue: 18, baseWeight: 0.17, rarity: Rarity.common, emoji: '🫐', multiHarvest: true),
    Crop(id: 'rose', name: 'Rose', baseValue: 20, baseWeight: 0.30, rarity: Rarity.common, emoji: '🌹'),
    Crop(id: 'chamomile', name: 'Chamomile', baseValue: 24, baseWeight: 0.10, rarity: Rarity.common, emoji: '🌼'),

    // ---------------- Uncommon ----------------
    Crop(id: 'tomato', name: 'Tomato', baseValue: 27, baseWeight: 0.44, rarity: Rarity.uncommon, emoji: '🍅', multiHarvest: true),
    Crop(id: 'corn', name: 'Corn', baseValue: 36, baseWeight: 1.90, rarity: Rarity.uncommon, emoji: '🌽', multiHarvest: true),
    Crop(id: 'daffodil', name: 'Daffodil', baseValue: 903, baseWeight: 0.16, rarity: Rarity.uncommon, emoji: '🌻'),
    Crop(id: 'orange-tulip', name: 'Orange Tulip', baseValue: 767, baseWeight: 0.05, rarity: Rarity.uncommon, emoji: '🌷'),
    Crop(id: 'raspberry', name: 'Raspberry', baseValue: 90, baseWeight: 0.71, rarity: Rarity.uncommon, emoji: '🍇', multiHarvest: true),

    // ---------------- Rare ----------------
    Crop(id: 'watermelon', name: 'Watermelon', baseValue: 2708, baseWeight: 7.30, rarity: Rarity.rare, emoji: '🍉'),
    Crop(id: 'pumpkin', name: 'Pumpkin', baseValue: 3069, baseWeight: 6.90, rarity: Rarity.rare, emoji: '🎃'),
    Crop(id: 'apple', name: 'Apple', baseValue: 248, baseWeight: 2.85, rarity: Rarity.rare, emoji: '🍎', multiHarvest: true),
    Crop(id: 'bamboo', name: 'Bamboo', baseValue: 3610, baseWeight: 3.80, rarity: Rarity.rare, emoji: '🎋', multiHarvest: true),
    Crop(id: 'blueberry-bush', name: 'Nightshade', baseValue: 934, baseWeight: 0.48, rarity: Rarity.rare, emoji: '🍆'),

    // ---------------- Legendary ----------------
    Crop(id: 'coconut', name: 'Coconut', baseValue: 361, baseWeight: 13.31, rarity: Rarity.legendary, emoji: '🥥'),
    Crop(id: 'cactus', name: 'Cactus', baseValue: 3068, baseWeight: 6.65, rarity: Rarity.legendary, emoji: '🌵', multiHarvest: true),
    Crop(id: 'dragon-fruit', name: 'Dragon Fruit', baseValue: 4287, baseWeight: 11.38, rarity: Rarity.legendary, emoji: '🐲', multiHarvest: true),
    Crop(id: 'mango', name: 'Mango', baseValue: 5866, baseWeight: 14.28, rarity: Rarity.legendary, emoji: '🥭', multiHarvest: true),
    Crop(id: 'pear', name: 'Pear', baseValue: 553, baseWeight: 2.85, rarity: Rarity.legendary, emoji: '🍐', multiHarvest: true),

    // ---------------- Mythical ----------------
    Crop(id: 'grape', name: 'Grape', baseValue: 7085, baseWeight: 2.85, rarity: Rarity.mythical, emoji: '🍇', multiHarvest: true),
    Crop(id: 'mushroom', name: 'Mushroom', baseValue: 136278, baseWeight: 25.90, rarity: Rarity.mythical, emoji: '🍄'),
    Crop(id: 'pepper', name: 'Pepper', baseValue: 7220, baseWeight: 4.75, rarity: Rarity.mythical, emoji: '🌶️', multiHarvest: true),
    Crop(id: 'cacao', name: 'Cacao', baseValue: 10456, baseWeight: 7.60, rarity: Rarity.mythical, emoji: '🍫', multiHarvest: true),
    Crop(id: 'lemon', name: 'Lemon', baseValue: 554, baseWeight: 0.60, rarity: Rarity.mythical, emoji: '🍋', multiHarvest: true),

    // ---------------- Divine ----------------
    Crop(id: 'beanstalk', name: 'Beanstalk', baseValue: 25270, baseWeight: 9.50, rarity: Rarity.divine, emoji: '🌱', multiHarvest: true),
    Crop(id: 'ember-lily', name: 'Ember Lily', baseValue: 50138, baseWeight: 11.40, rarity: Rarity.divine, emoji: '🔥', multiHarvest: true),
    Crop(id: 'sugar-apple', name: 'Sugar Apple', baseValue: 43320, baseWeight: 8.55, rarity: Rarity.divine, emoji: '🍏', multiHarvest: true),
    Crop(id: 'burning-bud', name: 'Burning Bud', baseValue: 70000, baseWeight: 11.50, rarity: Rarity.divine, emoji: '🌺', multiHarvest: true),

    // ---------------- Prismatic ----------------
    Crop(id: 'moon-melon', name: 'Moon Melon', baseValue: 16460, baseWeight: 7.20, rarity: Rarity.prismatic, emoji: '🌙'),
    Crop(id: 'celestiberry', name: 'Celestiberry', baseValue: 9100, baseWeight: 1.90, rarity: Rarity.prismatic, emoji: '✨', multiHarvest: true),
    Crop(id: 'soul-fruit', name: 'Soul Fruit', baseValue: 3328, baseWeight: 23.90, rarity: Rarity.prismatic, emoji: '👻', multiHarvest: true),

    // ---------------- Transcendent ----------------
    Crop(id: 'bone-blossom', name: 'Bone Blossom', baseValue: 175000, baseWeight: 3.00, rarity: Rarity.transcendent, emoji: '💀', multiHarvest: true),
    Crop(id: 'sun-blossom', name: 'Sun Blossom', baseValue: 90000, baseWeight: 5.20, rarity: Rarity.transcendent, emoji: '☀️', multiHarvest: true),
  ];

  static Crop byId(String id) =>
      all.firstWhere((c) => c.id == id, orElse: () => all.first);

  static List<Crop> ofRarity(Rarity rarity) =>
      all.where((c) => c.rarity == rarity).toList();

  static List<Crop> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((c) => c.name.toLowerCase().contains(q)).toList();
  }
}
