import 'package:domain/src/units/amount.dart';
import 'package:domain/src/value_objects/quantity.dart';
import 'package:domain/src/value_objects/unit.dart';

/// Milliliters in one US teaspoon. Exact: the US gallon is 231 cubic
/// inches and the inch is 2.54 cm.
const millilitersPerTeaspoon = 4.92892159375;

/// Grams in one avoirdupois ounce. Exact by definition.
const gramsPerOunce = 28.349523125;

/// Converting amounts between units.
extension AmountConversion on Amount {
  /// This amount in [target], or null when it does not convert exactly,
  /// because [target] is in another family (see [Unit.isConvertibleTo]) or
  /// this amount has no unit.
  ///
  /// Exact, so 3 tsp is 1 tbsp.
  Amount? convertTo(Unit target) {
    final unit = this.unit;
    if (unit == null || !unit.isConvertibleTo(target)) return null;
    final factor = Quantity(unit.baseUnits, target.baseUnits);
    return Amount(quantity * factor, target);
  }

  /// How many of [target] this amount is, or null when [target] measures
  /// something else.
  ///
  /// Unlike [convertTo], this also crosses between US and metric units,
  /// which is approximate, so it returns a [double]. Turn the result back
  /// into an amount someone can measure with `measurableAmount`.
  double? approximateValueIn(Unit target) {
    final unit = this.unit;
    if (unit == null) return null;
    if (unit.isConvertibleTo(target)) {
      return quantity.toDouble() * unit.baseUnits / target.baseUnits;
    }
    if (unit.dimension != target.dimension || unit.dimension == .count) {
      return null;
    }
    final ownBase = quantity.toDouble() * unit.baseUnits;
    final metricPerUs = unit.dimension == .volume
        ? millilitersPerTeaspoon
        : gramsPerOunce;
    final targetBase = target.system == .metric
        ? ownBase * metricPerUs
        : ownBase / metricPerUs;
    return targetBase / target.baseUnits;
  }
}
