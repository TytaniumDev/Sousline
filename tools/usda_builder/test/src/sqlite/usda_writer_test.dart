import 'dart:io';

import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:usda_builder/usda_builder.dart';

void main() {
  const dataset = UsdaDataset(
    foods: [
      UsdaFood(
        fdcId: 171287,
        name: 'Egg, whole, raw, fresh',
        nutrients: {'203': 12.56, '208': 143},
        portions: [
          UsdaPortion(
            sourceId: 92000,
            amountNumerator: 1,
            amountDenominator: 1,
            gramWeight: 50,
            unit: null,
            description: '1 large',
          ),
          UsdaPortion(
            sourceId: 92001,
            amountNumerator: 1,
            amountDenominator: 2,
            gramWeight: 121.5,
            unit: 'cup',
            description: '0.5 cup',
          ),
        ],
      ),
    ],
    nutrients: [
      UsdaNutrient(code: '203', name: 'Protein', unit: 'g'),
      UsdaNutrient(code: '208', name: 'Energy', unit: 'kcal'),
    ],
    metadata: {'schema_version': '1', 'source': 'USDA'},
  );

  group('writeUsdaDatabase', () {
    late Directory temp;
    late File output;

    setUp(() {
      temp = Directory.systemTemp.createTempSync('usda_writer');
      output = File('${temp.path}/nested/usda_foods.sqlite');
    });
    tearDown(() => temp.deleteSync(recursive: true));

    Database open() {
      final database = sqlite3.open(output.path, mode: OpenMode.readOnly);
      addTearDown(database.close);
      return database;
    }

    test('writes foods in the shape of the app tables', () {
      writeUsdaDatabase(dataset, output);
      final database = open();

      expect(database.select('SELECT * FROM foods'), [
        {
          'id': 'usda:171287',
          'source': 'usda',
          'external_id': '171287',
          'name': 'Egg, whole, raw, fresh',
          'brand': null,
        },
      ]);
      expect(
        database.select('SELECT * FROM food_nutrients ORDER BY nutrient_code'),
        [
          {
            'food_id': 'usda:171287',
            'nutrient_code': '203',
            'amount_per100g': 12.56,
          },
          {
            'food_id': 'usda:171287',
            'nutrient_code': '208',
            'amount_per100g': 143.0,
          },
        ],
      );
      expect(database.select('SELECT * FROM food_portions ORDER BY id'), [
        {
          'id': 'usda-portion:92000',
          'food_id': 'usda:171287',
          'amount_numerator': 1,
          'amount_denominator': 1,
          'gram_weight': 50.0,
          'unit': null,
          'description': '1 large',
        },
        {
          'id': 'usda-portion:92001',
          'food_id': 'usda:171287',
          'amount_numerator': 1,
          'amount_denominator': 2,
          'gram_weight': 121.5,
          'unit': 'cup',
          'description': '0.5 cup',
        },
      ]);
    });

    test('writes nutrients, metadata, and the schema version', () {
      writeUsdaDatabase(dataset, output);
      final database = open();

      expect(database.userVersion, usdaSchemaVersion);
      expect(
        database.select('SELECT code, unit FROM nutrients ORDER BY code'),
        [
          {'code': '203', 'unit': 'g'},
          {'code': '208', 'unit': 'kcal'},
        ],
      );
      expect(database.select('SELECT * FROM metadata ORDER BY key'), [
        {'key': 'schema_version', 'value': '1'},
        {'key': 'source', 'value': 'USDA'},
      ]);
    });

    test('writes the same bytes every time', () {
      writeUsdaDatabase(dataset, output);
      final first = output.readAsBytesSync();
      writeUsdaDatabase(dataset, output);

      expect(output.readAsBytesSync(), first);
    });

    test('replaces an existing file and leftovers of a failed build', () {
      output.parent.createSync(recursive: true);
      output.writeAsStringSync('old');
      File('${output.path}.tmp').writeAsStringSync('partial');

      writeUsdaDatabase(dataset, output);

      expect(open().select('SELECT id FROM foods'), hasLength(1));
      expect(File('${output.path}.tmp').existsSync(), isFalse);
    });
  });
}
