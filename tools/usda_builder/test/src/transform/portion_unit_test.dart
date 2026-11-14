import 'package:test/test.dart';
import 'package:usda_builder/src/transform/portion_unit.dart';

void main() {
  group('portionUnit', () {
    final cases = {
      'cup': 'cup',
      'Cups': 'cup',
      'cup, chopped': 'cup',
      'cup (8 fl oz)': 'cup',
      'cup slices': 'cup',
      'tbsp': 'tablespoon',
      'Tablespoons': 'tablespoon',
      'tablespoon': 'tablespoon',
      'tsp': 'teaspoon',
      'teaspoon': 'teaspoon',
      'fl oz': 'fluidOunce',
      'pint': 'pint',
      'quart': 'quart',
      'gallon': 'gallon',
      'milliliter': 'milliliter',
      'ml': 'milliliter',
      'liter': 'liter',
      'oz': 'ounce',
      'lb': 'pound',
      ' oz ': 'ounce',
    };
    for (final MapEntry(key: text, value: unit) in cases.entries) {
      test('reads "$text" as $unit', () => expect(portionUnit(text), unit));
    }

    for (final text in [
      '',
      'large',
      'slice',
      'cubic inch',
      'package (10 oz)',
      'cupcake',
      'ozone',
    ]) {
      test('has no unit for "$text"', () => expect(portionUnit(text), isNull));
    }
  });
}
