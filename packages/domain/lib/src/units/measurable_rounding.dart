import 'package:domain/src/entities/user_recipe_prefs.dart';
import 'package:domain/src/units/amount.dart';
import 'package:domain/src/units/unit_conversion.dart';
import 'package:domain/src/value_objects/quantity.dart';
import 'package:domain/src/value_objects/unit.dart';

/// The largest relative error a friendly amount, such as ⅓ cup, may have
/// before rounding falls back to a smaller unit (PRD 7.6).
const measurableTolerance = 0.05;

/// The amount closest to [value] (counted in [unit]) that someone can
/// measure with ordinary kitchen tools.
///
/// Rounding picks the unit as well as the amount:
///
/// - **US volume:** teaspoons to the nearest ⅛ below 1 tbsp; tablespoons
///   to the nearest ½ below ¼ cup (teaspoons to the nearest ¼ when that is
///   more than [measurableTolerance] off); cups as a whole number plus ¼,
///   ⅓, ½, ⅔, or ¾ (tablespoons below 1 cup, or the nearest ⅛ cup above,
///   when that is too far off). Fluid ounces, pints, quarts, and gallons
///   stay in their unit, to the nearest ¼, once there is at least one.
/// - **Metric:** milliliters or grams to the nearest ½ below 10, 1 below
///   100, and 5 below 1000; liters or kilograms to the nearest 0.05 above.
/// - **US mass:** ounces to the nearest ¼ below 1 lb; pounds to the
///   nearest ¼ above.
/// - **Counts and no unit:** the nearest ¼ below 1, ½ below 10, and whole
///   numbers above.
///
/// A positive value never rounds to zero: it becomes the smallest step.
/// A value of zero or less gives zero.
Amount measurableAmount(double value, Unit? unit) {
  if (value <= 0) return Amount(Quantity.zero, unit);
  if (unit == null) return Amount(_count(value), unit);
  final base = value * unit.baseUnits;
  return switch (unit.family) {
    .usVolume => _usVolume(base, unit),
    .metricVolume => _metric(base, small: .milliliter, large: .liter),
    .usMass => _usMass(base),
    .metricMass => _metric(base, small: .gram, large: .kilogram),
    .count => Amount(_count(value), unit),
  };
}

/// Rounding amounts to something people can measure.
extension MeasurableRounding on Amount {
  /// This amount rounded with [measurableAmount], in the same family.
  ///
  /// Use it after scaling. Unscaled amounts are shown as written.
  Amount roundedToMeasurable() => measurableAmount(quantity.toDouble(), unit);

  /// This amount converted to [system] if it is in the other one, then
  /// rounded with [measurableAmount].
  ///
  /// [UnitSystem.original], counts, and amounts without a unit are only
  /// rounded.
  Amount measurableIn(UnitSystem system) {
    final target = _conversionTarget(system);
    final value = target == null ? null : approximateValueIn(target);
    return value == null
        ? roundedToMeasurable()
        : measurableAmount(value, target);
  }

  /// The smallest unit of [system] for this amount's dimension, or null
  /// when no conversion is needed.
  Unit? _conversionTarget(UnitSystem system) {
    final own = unit?.system;
    if (own == null || system == .original || own == system) return null;
    final isVolume = unit?.dimension == .volume;
    return switch (system) {
      .metric => isVolume ? Unit.milliliter : Unit.gram,
      _ => isVolume ? Unit.teaspoon : Unit.ounce,
    };
  }
}

/// US volume units kept as written once the amount is at least one.
const Set<Unit> _keptUsVolumeUnits = {
  Unit.fluidOunce,
  Unit.pint,
  Unit.quart,
  Unit.gallon,
};

/// The fractions of a cup that standard measuring cups hold.
final List<Quantity> _cupFractions = [
  Quantity.zero,
  Quantity(1, 4),
  Quantity(1, 3),
  Quantity(1, 2),
  Quantity(2, 3),
  Quantity(3, 4),
  Quantity.one,
];

Amount _usVolume(double teaspoons, Unit unit) {
  if (_keptUsVolumeUnits.contains(unit) && teaspoons >= unit.baseUnits) {
    return Amount(_snap(teaspoons / unit.baseUnits, Quantity(1, 4)), unit);
  }

  final inTeaspoons = _snap(teaspoons, Quantity(1, 8));
  if (inTeaspoons < Quantity(3)) return Amount(inTeaspoons, .teaspoon);

  final tablespoons = teaspoons / 3;
  final inTablespoons = _snap(tablespoons, Quantity(1, 2));
  if (inTablespoons < Quantity(4)) {
    return _isClose(inTablespoons, tablespoons)
        ? Amount(inTablespoons, .tablespoon)
        : Amount(_snap(teaspoons, Quantity(1, 4)), .teaspoon);
  }

  final cups = teaspoons / 48;
  final friendlyCups = _nearestCupFraction(cups);
  if (_isClose(friendlyCups, cups)) return Amount(friendlyCups, .cup);
  if (cups < 1) return Amount(inTablespoons, .tablespoon);
  return Amount(_snap(cups, Quantity(1, 8)), .cup);
}

Amount _metric(double value, {required Unit small, required Unit large}) {
  final step = value < 10
      ? Quantity(1, 2)
      : value < 100
      ? Quantity.one
      : Quantity(5);
  final inSmall = _snap(value, step);
  if (inSmall < Quantity(large.baseUnits)) return Amount(inSmall, small);
  return Amount(_snap(value / large.baseUnits, Quantity(1, 20)), large);
}

Amount _usMass(double ounces) {
  final inOunces = _snap(ounces, Quantity(1, 4));
  if (inOunces < Quantity(Unit.pound.baseUnits)) {
    return Amount(inOunces, .ounce);
  }
  return Amount(_snap(ounces / Unit.pound.baseUnits, Quantity(1, 4)), .pound);
}

Quantity _count(double value) {
  final step = value < 1
      ? Quantity(1, 4)
      : value < 10
      ? Quantity(1, 2)
      : Quantity.one;
  return _snap(value, step);
}

Quantity _nearestCupFraction(double cups) {
  final whole = Quantity(cups.floor());
  var best = whole;
  var bestError = double.infinity;
  for (final fraction in _cupFractions) {
    final candidate = whole + fraction;
    final error = (candidate.toDouble() - cups).abs();
    if (error < bestError) {
      best = candidate;
      bestError = error;
    }
  }
  return best;
}

/// [value] rounded to the nearest multiple of [step], and at least [step].
Quantity _snap(double value, Quantity step) {
  final steps = (value / step.toDouble()).round();
  return step * Quantity(steps < 1 ? 1 : steps);
}

bool _isClose(Quantity rounded, double value) =>
    (rounded.toDouble() - value).abs() <= value * measurableTolerance;
