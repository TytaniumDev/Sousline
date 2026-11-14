import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('unitFromAlias', () {
    const table = <String, Unit>{
      'tsp': Unit.teaspoon,
      'Tsp.': Unit.teaspoon,
      'teaspoons': Unit.teaspoon,
      't': Unit.teaspoon,
      'T': Unit.tablespoon,
      'Tb': Unit.tablespoon,
      'Tbsp.': Unit.tablespoon,
      'TBSP': Unit.tablespoon,
      'tablespoon': Unit.tablespoon,
      'fl. oz.': Unit.fluidOunce,
      'fl  oz': Unit.fluidOunce,
      'fluid ounces': Unit.fluidOunce,
      'c': Unit.cup,
      'C.': Unit.cup,
      'cups': Unit.cup,
      'pt': Unit.pint,
      'qt': Unit.quart,
      'gal': Unit.gallon,
      'ml': Unit.milliliter,
      'mL': Unit.milliliter,
      'millilitres': Unit.milliliter,
      'L': Unit.liter,
      'litre': Unit.liter,
      'g': Unit.gram,
      'grams': Unit.gram,
      'kg': Unit.kilogram,
      'kilos': Unit.kilogram,
      'oz': Unit.ounce,
      'lbs': Unit.pound,
      'Pound': Unit.pound,
      'pinch': Unit.pinch,
      'pcs': Unit.piece,
      '  cup  ': Unit.cup,
    };

    for (final MapEntry(key: alias, value: unit) in table.entries) {
      test('reads "$alias" as ${unit.name}', () {
        expect(unitFromAlias(alias), unit);
      });
    }

    test('returns null for words that are not units', () {
      expect(unitFromAlias('onion'), isNull);
      expect(unitFromAlias(''), isNull);
    });
  });
}
