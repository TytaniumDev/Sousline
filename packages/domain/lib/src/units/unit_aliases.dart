import 'package:domain/src/value_objects/unit.dart';

/// The [Unit] that [text] names, such as "Tbsp." or "cups", or null when
/// [text] is not a unit the app knows.
///
/// Matching ignores case, periods, and extra spaces, except for the
/// cookbook shorthand "T" (tablespoon) and "t" (teaspoon), which differ
/// only by case.
Unit? unitFromAlias(String text) {
  final trimmed = text.trim();
  final caseSensitive = _caseSensitiveAliases[trimmed];
  if (caseSensitive != null) return caseSensitive;

  final normalized = trimmed
      .toLowerCase()
      .replaceAll('.', ' ')
      .replaceAll(_whitespace, ' ')
      .trim();
  return _aliases[normalized];
}

final _whitespace = RegExp(r'\s+');

const _caseSensitiveAliases = <String, Unit>{
  'T': .tablespoon,
  'Tb': .tablespoon,
  't': .teaspoon,
};

const _aliases = <String, Unit>{
  // US volume.
  'tsp': .teaspoon,
  'tsps': .teaspoon,
  'ts': .teaspoon,
  'teaspoon': .teaspoon,
  'teaspoons': .teaspoon,
  'tbsp': .tablespoon,
  'tbsps': .tablespoon,
  'tbs': .tablespoon,
  'tbl': .tablespoon,
  'tblsp': .tablespoon,
  'tablespoon': .tablespoon,
  'tablespoons': .tablespoon,
  'fl oz': .fluidOunce,
  'floz': .fluidOunce,
  'fluid ounce': .fluidOunce,
  'fluid ounces': .fluidOunce,
  'c': .cup,
  'cup': .cup,
  'cups': .cup,
  'pt': .pint,
  'pts': .pint,
  'pint': .pint,
  'pints': .pint,
  'qt': .quart,
  'qts': .quart,
  'quart': .quart,
  'quarts': .quart,
  'gal': .gallon,
  'gals': .gallon,
  'gallon': .gallon,
  'gallons': .gallon,

  // Metric volume.
  'ml': .milliliter,
  'mls': .milliliter,
  'cc': .milliliter,
  'milliliter': .milliliter,
  'milliliters': .milliliter,
  'millilitre': .milliliter,
  'millilitres': .milliliter,
  'l': .liter,
  'liter': .liter,
  'liters': .liter,
  'litre': .liter,
  'litres': .liter,

  // Metric mass.
  'g': .gram,
  'gr': .gram,
  'gram': .gram,
  'grams': .gram,
  'gramme': .gram,
  'grammes': .gram,
  'kg': .kilogram,
  'kgs': .kilogram,
  'kilo': .kilogram,
  'kilos': .kilogram,
  'kilogram': .kilogram,
  'kilograms': .kilogram,

  // US mass.
  'oz': .ounce,
  'ounce': .ounce,
  'ounces': .ounce,
  'lb': .pound,
  'lbs': .pound,
  'pound': .pound,
  'pounds': .pound,

  // Counts.
  'pinch': .pinch,
  'pinches': .pinch,
  'pc': .piece,
  'pcs': .piece,
  'piece': .piece,
  'pieces': .piece,
};
