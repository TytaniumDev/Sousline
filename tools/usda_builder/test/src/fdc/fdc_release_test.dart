import 'dart:io';

import 'package:test/test.dart';
import 'package:usda_builder/src/fdc/fdc_release.dart';

import '../../helpers/fixtures.dart';

void main() {
  group(FdcRelease, () {
    group('locate', () {
      test('finds a release inside its only subfolder', () {
        final release = FdcRelease.locate(foundationFixture);

        expect(release.name, 'FoodData_Central_foundation_food_csv_fixture');
      });

      test('finds a release at the top level', () {
        expect(FdcRelease.locate(srLegacyFixture).name, 'sr_legacy');
      });

      test('throws when the folder does not exist', () {
        expect(
          () => FdcRelease.locate(Directory('test/fixtures/missing')),
          throwsA(isA<FdcReleaseException>()),
        );
      });

      test('throws naming the files an incomplete release lacks', () {
        final temp = Directory.systemTemp.createTempSync('fdc_release');
        addTearDown(() => temp.deleteSync(recursive: true));
        File('${temp.path}/food.csv').writeAsStringSync('"fdc_id"\n');

        expect(
          () => FdcRelease.locate(temp),
          throwsA(
            isA<FdcReleaseException>().having(
              (e) => '$e',
              'message',
              allOf(contains('food_nutrient.csv'), contains('nutrient.csv')),
            ),
          ),
        );
      });
    });

    group('read', () {
      late FdcReleaseData data;

      setUpAll(() async {
        data = await FdcRelease.locate(foundationFixture)
            .read(dataType: 'foundation_food', nutrientNumbers: {'203', '958'});
      });

      test('keeps only foods of the data type, ordered by id', () {
        expect(data.foods.map((f) => f.fdcId), [100, 101, 103, 104, 105]);
        expect(data.foods.first.description, 'Strawberries, raw');
      });

      test('keeps only the requested nutrients with a value', () {
        final food = data.foods.first;

        expect(food.nutrients, {'958': 32.0, '203': 0.64});
        expect(data.foods.last.nutrients, {'203': 27.0});
      });

      test('reads portions, skipping rows without an id or weight', () {
        final broccoli = data.foods.firstWhere((f) => f.fdcId == 103);
        final cheese = data.foods.firstWhere((f) => f.fdcId == 105);

        expect(broccoli.portions.map((p) => p.id), [118864, 118865, 118866]);
        expect(cheese.portions.map((p) => p.id), [118869]);
      });

      test('names measure units, with null for undetermined', () {
        final broccoli = data.foods.firstWhere((f) => f.fdcId == 103);

        expect(broccoli.portions.map((p) => p.measureUnit), [
          'cup',
          'large',
          null,
        ]);
        expect(broccoli.portions.first.modifier, 'chopped');
        expect(broccoli.portions.first.amount, '1.0');
        expect(broccoli.portions.first.gramWeight, 76.0);
      });

      test('defines every nutrient by number', () {
        expect(data.nutrients['203']?.name, 'Protein');
        expect(data.nutrients['203']?.unitName, 'G');
      });
    });
  });
}
