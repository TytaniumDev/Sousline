import 'package:usda_builder/src/fdc/fdc_nutrient.dart';
import 'package:usda_builder/src/fdc/fdc_release.dart';
import 'package:usda_builder/src/model/usda_nutrient.dart';

/// A nutrient the bundled file keeps, and where its value comes from.
final class const NutrientSpec(
  /// The USDA nutrient number the app reads, such as "208".
  final String code, {

  /// Nutrient numbers to try after [code], in order, when a food has no
  /// value for [code]. Foundation Foods often reports energy only as
  /// Atwater energy (958, 957) and sugars as "269.3".
  final List<String> fallbacks = const [],
}) {
  /// [code] and then its fallbacks.
  List<String> get sources => [code, ...fallbacks];
}

/// The nutrients the app shows (PRD §7.4): energy and macros, the rest of a
/// US nutrition label, and common vitamins and minerals. Keeping only these
/// keeps the file a few MB.
const selectedNutrients = [
  NutrientSpec('208', fallbacks: ['958', '957']), // Energy, kcal
  NutrientSpec('203'), // Protein
  NutrientSpec('204', fallbacks: ['298']), // Total fat
  NutrientSpec('606'), // Saturated fat
  NutrientSpec('605'), // Trans fat
  NutrientSpec('645'), // Monounsaturated fat
  NutrientSpec('646'), // Polyunsaturated fat
  NutrientSpec('601'), // Cholesterol
  NutrientSpec('205', fallbacks: ['205.2']), // Carbohydrate
  NutrientSpec('291'), // Fiber
  NutrientSpec('269', fallbacks: ['269.3']), // Total sugars
  NutrientSpec('539'), // Added sugars
  NutrientSpec('221'), // Alcohol
  NutrientSpec('307'), // Sodium
  NutrientSpec('306'), // Potassium
  NutrientSpec('301'), // Calcium
  NutrientSpec('303'), // Iron
  NutrientSpec('304'), // Magnesium
  NutrientSpec('305'), // Phosphorus
  NutrientSpec('309'), // Zinc
  NutrientSpec('320'), // Vitamin A, RAE
  NutrientSpec('401'), // Vitamin C
  NutrientSpec('328'), // Vitamin D (D2 + D3)
  NutrientSpec('323'), // Vitamin E
  NutrientSpec('430'), // Vitamin K
  NutrientSpec('404'), // Thiamin
  NutrientSpec('405'), // Riboflavin
  NutrientSpec('406'), // Niacin
  NutrientSpec('415'), // Vitamin B6
  NutrientSpec('417'), // Folate
  NutrientSpec('418'), // Vitamin B12
];

/// Every nutrient number a release needs to read for [specs].
Set<String> sourceNumbers([List<NutrientSpec> specs = selectedNutrients]) => {
  for (final spec in specs) ...spec.sources,
};

/// Picks each spec's value from a food's [values] (keyed by nutrient
/// number): the spec's own code if present, else its first fallback that is.
Map<String, double> selectNutrientValues(
  Map<String, double> values, [
  List<NutrientSpec> specs = selectedNutrients,
]) => {
  for (final spec in specs)
    spec.code: ?spec.sources.map((n) => values[n]).nonNulls.firstOrNull,
};

/// The definition of each spec's code, from a release's [definitions].
///
/// Throws an [FdcReleaseException] when a code is undefined, or when a
/// fallback uses a different unit than its code, since its values would
/// then be wrong.
List<UsdaNutrient> describeNutrients(
  Map<String, FdcNutrient> definitions, [
  List<NutrientSpec> specs = selectedNutrients,
]) {
  final described = <UsdaNutrient>[];
  for (final spec in specs) {
    final nutrient = definitions[spec.code];
    if (nutrient == null) {
      throw FdcReleaseException(
        'The release does not define nutrient ${spec.code}.',
      );
    }
    final unit = nutrient.unitName.toLowerCase();
    for (final fallback in spec.fallbacks) {
      final fallbackUnit = definitions[fallback]?.unitName.toLowerCase();
      if (fallbackUnit != null && fallbackUnit != unit) {
        throw FdcReleaseException(
          'Nutrient $fallback is in $fallbackUnit, but ${spec.code} is in '
          '$unit.',
        );
      }
    }
    described.add(
      UsdaNutrient(code: spec.code, name: nutrient.name, unit: unit),
    );
  }
  return described..sort((a, b) => a.code.compareTo(b.code));
}
