import 'package:test/test.dart';
import 'package:usda_builder/src/fdc/fdc_food.dart';
import 'package:usda_builder/src/fdc/fdc_portion.dart';
import 'package:usda_builder/src/transform/food_conversion.dart';

void main() {
  FdcPortion portion({
    String amount = '1',
    String? measureUnit,
    String portionDescription = '',
    String modifier = '',
    double gramWeight = 100,
  }) => FdcPortion(
    id: 7,
    amount: amount,
    measureUnit: measureUnit,
    portionDescription: portionDescription,
    modifier: modifier,
    gramWeight: gramWeight,
  );

  group('convertPortion', () {
    test('reads an SR Legacy portion from its modifier', () {
      final converted = convertPortion(
        portion(amount: '0.33', modifier: 'cup, pureed', gramWeight: 77),
      )!;

      expect(converted.id, 'usda-portion:7');
      expect(converted.amountNumerator, 1);
      expect(converted.amountDenominator, 3);
      expect(converted.gramWeight, 77);
      expect(converted.unit, 'cup');
      expect(converted.description, '0.33 cup, pureed');
    });

    test('reads a Foundation portion from its measure unit', () {
      final converted = convertPortion(
        portion(
          amount: '1.0',
          measureUnit: 'cup',
          portionDescription: 'shredded',
          modifier: 'raw',
        ),
      )!;

      expect(converted.unit, 'cup');
      expect(converted.description, '1 cup shredded raw');
    });

    test('has no unit for a count', () {
      final converted = convertPortion(portion(measureUnit: 'large'))!;

      expect(converted.unit, isNull);
      expect(converted.description, '1 large');
    });

    test('drops a portion without a positive amount or weight', () {
      expect(convertPortion(portion(amount: '0')), isNull);
      expect(convertPortion(portion(gramWeight: 0)), isNull);
    });
  });

  group('convertFood', () {
    test('keeps selected nutrients and valid portions', () {
      final food = convertFood(
        FdcFood(
          fdcId: 171287,
          description: 'Egg, whole, raw, fresh',
          nutrients: const {'208': 143, '255': 76},
          portions: [
            portion(modifier: 'large'),
            portion(amount: '0'),
          ],
        ),
      )!;

      expect(food.id, 'usda:171287');
      expect(food.name, 'Egg, whole, raw, fresh');
      expect(food.nutrients, {'208': 143});
      expect(food.portions, hasLength(1));
    });

    test('drops a food without any selected nutrient', () {
      final food = convertFood(
        const FdcFood(
          fdcId: 1,
          description: 'Water, tap',
          nutrients: {'255': 99.9},
          portions: [],
        ),
      );

      expect(food, isNull);
    });
  });
}
