import 'package:usda_builder/src/fdc/fdc_food.dart';
import 'package:usda_builder/src/fdc/fdc_portion.dart';
import 'package:usda_builder/src/model/usda_food.dart';
import 'package:usda_builder/src/model/usda_portion.dart';
import 'package:usda_builder/src/transform/amount_fraction.dart';
import 'package:usda_builder/src/transform/nutrient_selection.dart';
import 'package:usda_builder/src/transform/portion_unit.dart';

/// Converts a release food to the bundled form, keeping only the
/// [selectedNutrients] and the portions that have an amount and a weight.
///
/// Returns null for a food with none of the selected nutrients, since it
/// could not contribute to a recipe's nutrition.
UsdaFood? convertFood(FdcFood food) {
  final nutrients = selectNutrientValues(food.nutrients);
  if (nutrients.isEmpty) return null;
  return UsdaFood(
    fdcId: food.fdcId,
    name: food.description,
    nutrients: nutrients,
    portions: food.portions.map(convertPortion).nonNulls.toList(),
  );
}

/// Converts a release portion, or returns null when its amount or gram
/// weight is missing or not positive.
UsdaPortion? convertPortion(FdcPortion portion) {
  final amount = amountFraction(portion.amount);
  if (amount == null || portion.gramWeight <= 0) return null;
  final unitText = portion.measureUnit ?? portion.modifier;
  return UsdaPortion(
    sourceId: portion.id,
    amountNumerator: amount.numerator,
    amountDenominator: amount.denominator,
    gramWeight: portion.gramWeight,
    unit: portionUnit(unitText),
    description: [
      _trimDecimal(portion.amount),
      ?portion.measureUnit,
      portion.portionDescription,
      portion.modifier,
    ].where((part) => part.isNotEmpty).join(' '),
  );
}

/// "1.0" reads as "1" in a description.
String _trimDecimal(String amount) =>
    amount.endsWith('.0') ? amount.substring(0, amount.length - 2) : amount;
