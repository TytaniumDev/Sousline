import 'package:domain/src/entities/user_recipe_prefs.dart';

/// What a [Unit] measures.
enum UnitDimension() {
  volume,
  mass,
  count,
}

/// A group of units that convert into each other exactly, such as US
/// volume (teaspoons to gallons).
///
/// Converting between families of the same [dimension], such as US volume
/// to metric volume, is approximate and goes through `AmountConversion`.
enum UnitFamily(
  /// What the units in this family measure.
  final UnitDimension dimension,

  /// The measuring system, or null for counts.
  final UnitSystem? system,
) {
  usVolume(.volume, .us),
  metricVolume(.volume, .metric),
  usMass(.mass, .us),
  metricMass(.mass, .metric),

  /// Counted things, such as a pinch. Each count unit only converts to
  /// itself.
  count(.count, null),
}

/// A measuring unit the app understands.
///
/// Display text (such as "Tbsp" or "cups") is not stored here. It is
/// formatted by `packages/measuring` and localized in the app.
enum Unit(
  /// The family this unit converts within.
  final UnitFamily family,

  /// How many of the family's smallest unit make one of this unit: the
  /// teaspoon for US volume, the milliliter for metric volume, the ounce
  /// for US mass, and the gram for metric mass. Always a whole number, so
  /// conversion within a family stays exact.
  final int baseUnits,
) {
  teaspoon(.usVolume, 1),
  tablespoon(.usVolume, 3),
  fluidOunce(.usVolume, 6),
  cup(.usVolume, 48),
  pint(.usVolume, 96),
  quart(.usVolume, 192),
  gallon(.usVolume, 768),
  milliliter(.metricVolume, 1),
  liter(.metricVolume, 1000),
  gram(.metricMass, 1),
  kilogram(.metricMass, 1000),
  ounce(.usMass, 1),
  pound(.usMass, 16),
  pinch(.count, 1),
  piece(.count, 1);

  /// What this unit measures.
  UnitDimension get dimension => family.dimension;

  /// The measuring system, or null for counts.
  UnitSystem? get system => family.system;

  /// Whether an amount in this unit converts exactly into [other].
  bool isConvertibleTo(Unit other) =>
      this == other || (family == other.family && family != .count);
}
