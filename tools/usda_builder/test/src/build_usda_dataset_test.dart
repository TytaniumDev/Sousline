import 'package:test/test.dart';
import 'package:usda_builder/src/transform/nutrient_selection.dart';
import 'package:usda_builder/usda_builder.dart';

import '../helpers/fixtures.dart';

void main() {
  group('buildUsdaDataset', () {
    late UsdaDataset dataset;

    setUpAll(() async {
      dataset = await buildUsdaDataset(
        foundation: FdcRelease.locate(foundationFixture),
        srLegacy: FdcRelease.locate(srLegacyFixture),
      );
    });

    UsdaFood food(String name) =>
        dataset.foods.singleWhere((f) => f.name == name);

    test('keeps one food per name, ordered by FDC id', () {
      expect(dataset.foods.map((f) => (f.fdcId, f.name)), [
        (100, 'Strawberries, raw'),
        (103, 'Broccoli, raw'),
        (105, 'Cheese, "Swiss", sliced'),
        (168894, 'Wheat flour, white, all-purpose, enriched, bleached'),
        (171287, 'Egg, whole, raw, fresh'),
      ]);
    });

    test('fills energy from Atwater values when kcal is missing', () {
      expect(food('Strawberries, raw').nutrients, {
        '208': 32.0,
        '203': 0.64,
        '269': 4.86,
      });
      expect(food('Broccoli, raw').nutrients['208'], 39.0);
    });

    test('borrows SR Legacy portions for a Foundation food without any', () {
      final portions = food('Strawberries, raw').portions;

      expect(portions.map((p) => p.description), [
        '1 cup, halves',
        '0.33 cup, pureed',
      ]);
      expect(portions.map((p) => p.unit), ['cup', 'cup']);
    });

    test('converts Foundation portions with their measure units', () {
      final portions = food('Broccoli, raw').portions;

      expect(portions.map((p) => (p.unit, p.description, p.gramWeight)), [
        ('cup', '1 cup chopped', 76.0),
        (null, '1 large', 170.0),
        (null, '1 stalk', 151.0),
      ]);
    });

    test('converts SR Legacy portions from their modifiers', () {
      final portions = food('Egg, whole, raw, fresh').portions;

      expect(portions.map((p) => (p.unit, p.description)), [
        (null, '1 large'),
        ('cup', '1 cup (4.86 large eggs)'),
      ]);
      expect(food('Egg, whole, raw, fresh').nutrients['601'], 372.0);
    });

    test('describes every selected nutrient', () {
      expect(dataset.nutrients, hasLength(selectedNutrients.length));
      expect(dataset.nutrients.firstWhere((n) => n.code == '208').unit, 'kcal');
    });

    test('records the releases and schema version', () {
      expect(dataset.metadata, {
        'schema_version': '$usdaSchemaVersion',
        'foundation_release': 'FoodData_Central_foundation_food_csv_fixture',
        'sr_legacy_release': 'sr_legacy',
        'source': contains('FoodData Central'),
      });
    });
  });
}
