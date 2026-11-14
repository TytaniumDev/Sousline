/// Release unit words, lowercased, mapped to the names of the app's `Unit`
/// values. Only volumes and weights: counts ("large", "slice") have no unit
/// and are described by the portion's wording instead.
const _unitNames = {
  'cup': 'cup',
  'cups': 'cup',
  'tablespoon': 'tablespoon',
  'tablespoons': 'tablespoon',
  'tbsp': 'tablespoon',
  'teaspoon': 'teaspoon',
  'teaspoons': 'teaspoon',
  'tsp': 'teaspoon',
  'fl oz': 'fluidOunce',
  'pint': 'pint',
  'quart': 'quart',
  'gallon': 'gallon',
  'milliliter': 'milliliter',
  'ml': 'milliliter',
  'liter': 'liter',
  'oz': 'ounce',
  'lb': 'pound',
};

/// Matches a unit word at the start of the text, followed by the end, a
/// space, a comma, or a parenthesis: "cup", "cup, chopped", "cup (8 fl oz)".
/// "fl oz" comes first so it wins over "oz".
final _leadingUnit = RegExp(
  '^(fl oz|${_unitNames.keys.where((u) => u != 'fl oz').join('|')})'
  r'(?=$|[\s,(])',
  caseSensitive: false,
);

/// The app `Unit` name for a portion whose unit wording is [text], such as
/// "cup" for "cup, chopped", or null when the portion is a count or uses a
/// unit the app does not have ("cubic inch", "package (10 oz)").
String? portionUnit(String text) {
  final match = _leadingUnit.firstMatch(text.trim());
  return match == null ? null : _unitNames[match[1]!.toLowerCase()];
}
