import 'dart:io';

import 'package:usda_builder/src/csv/csv_records.dart';
import 'package:usda_builder/src/fdc/fdc_food.dart';
import 'package:usda_builder/src/fdc/fdc_nutrient.dart';
import 'package:usda_builder/src/fdc/fdc_portion.dart';

/// Thrown when a folder is not a complete FoodData Central CSV release.
final class const FdcReleaseException(
  /// What is wrong, naming the folder.
  final String message,
) implements Exception {
  @override
  String toString() => message;
}

/// The foods of one data type in a release, with the nutrient definitions.
final class const FdcReleaseData({
  /// The release's folder name, such as
  /// "FoodData_Central_foundation_food_csv_2026-04-30".
  required final String name,

  /// The foods, ordered by FDC id.
  required final List<FdcFood> foods,

  /// Every nutrient the release defines, keyed by nutrient number.
  required final Map<String, FdcNutrient> nutrients,
});

/// One unzipped FoodData Central CSV release, such as Foundation Foods or
/// SR Legacy, from https://fdc.nal.usda.gov/download-datasets.
final class const FdcRelease._(
  /// The folder that holds the release's CSV files.
  final Directory directory,
) {
  /// Finds the release in [directory], or in its only subfolder, which is
  /// how the official zip files unpack.
  ///
  /// Throws an [FdcReleaseException] when a required file is missing. Some
  /// published releases leave files out, so this fails before building.
  factory locate(Directory directory) {
    if (!directory.existsSync()) {
      throw FdcReleaseException('${directory.path} does not exist.');
    }
    final subfolders = directory.listSync().whereType<Directory>().toList();
    final folder = !_hasFile(directory, 'food.csv') && subfolders.length == 1
        ? subfolders.single
        : directory;
    final missing = requiredFiles.where((name) => !_hasFile(folder, name));
    if (missing.isNotEmpty) {
      throw FdcReleaseException(
        '${folder.path} is not a complete FoodData Central CSV release. '
        'Missing: ${missing.join(', ')}.',
      );
    }
    return FdcRelease._(folder);
  }

  /// The files [read] needs.
  static const requiredFiles = [
    'food.csv',
    'food_nutrient.csv',
    'food_portion.csv',
    'measure_unit.csv',
    'nutrient.csv',
  ];

  /// The `measure_unit.csv` name that means "no unit given".
  static const _undeterminedUnit = 'undetermined';

  /// The release's folder name.
  String get name => directory.uri.pathSegments.lastWhere((s) => s.isNotEmpty);

  /// Reads the foods whose `data_type` is [dataType] (such as
  /// "foundation_food"), keeping only nutrients whose number is in
  /// [nutrientNumbers].
  Future<FdcReleaseData> read({
    required String dataType,
    required Set<String> nutrientNumbers,
  }) async {
    final units = await _readMeasureUnits();
    final nutrientsById = await _readNutrients();
    final descriptions = await _readFoodDescriptions(dataType);
    final values = await _readNutrientValues(descriptions.keys.toSet(), {
      for (final MapEntry(:key, :value) in nutrientsById.entries)
        if (nutrientNumbers.contains(value.number)) key: value.number,
    });
    final portions = await _readPortions(descriptions.keys.toSet(), units);

    final ids = descriptions.keys.toList()..sort();
    return FdcReleaseData(
      name: name,
      foods: [
        for (final id in ids)
          FdcFood(
            fdcId: id,
            description: descriptions[id]!,
            nutrients: values[id] ?? const {},
            portions: portions[id] ?? const [],
          ),
      ],
      nutrients: {
        for (final nutrient in nutrientsById.values) nutrient.number: nutrient,
      },
    );
  }

  Stream<CsvRecord> _records(String file, Set<String> columns) =>
      readCsvRecords(File('${directory.path}/$file'), columns: columns);

  Future<Map<int, String>> _readMeasureUnits() async => {
    await for (final r in _records('measure_unit.csv', {'id', 'name'}))
      int.parse(r['id']): r['name'],
  };

  Future<Map<String, FdcNutrient>> _readNutrients() async => {
    await for (final r in _records('nutrient.csv', {
      'id',
      'name',
      'unit_name',
      'nutrient_nbr',
    }))
      if (r['nutrient_nbr'].isNotEmpty)
        r['id']: FdcNutrient(
          number: r['nutrient_nbr'],
          name: r['name'],
          unitName: r['unit_name'],
        ),
  };

  Future<Map<int, String>> _readFoodDescriptions(String dataType) async => {
    await for (final r in _records('food.csv', {
      'fdc_id',
      'data_type',
      'description',
    }))
      if (r['data_type'] == dataType) int.parse(r['fdc_id']): r['description'],
  };

  /// Amounts per 100 g by food, then by nutrient number.
  Future<Map<int, Map<String, double>>> _readNutrientValues(
    Set<int> foodIds,
    Map<String, String> numbersById,
  ) async {
    final values = <int, Map<String, double>>{};
    await for (final r in _records('food_nutrient.csv', {
      'fdc_id',
      'nutrient_id',
      'amount',
    })) {
      final foodId = int.tryParse(r['fdc_id']);
      final number = numbersById[r['nutrient_id']];
      final amount = double.tryParse(r['amount']);
      if (foodId == null || number == null || amount == null) continue;
      if (!foodIds.contains(foodId)) {
        continue;
      }
      (values[foodId] ??= {})[number] = amount;
    }
    return values;
  }

  Future<Map<int, List<FdcPortion>>> _readPortions(
    Set<int> foodIds,
    Map<int, String> units,
  ) async {
    final portions = <int, List<FdcPortion>>{};
    await for (final r in _records('food_portion.csv', {
      'id',
      'fdc_id',
      'amount',
      'measure_unit_id',
      'portion_description',
      'modifier',
      'gram_weight',
    })) {
      final id = int.tryParse(r['id']);
      final foodId = int.tryParse(r['fdc_id']);
      final gramWeight = double.tryParse(r['gram_weight']);
      if (id == null || foodId == null || gramWeight == null) continue;
      if (!foodIds.contains(foodId)) {
        continue;
      }
      final unit = units[int.tryParse(r['measure_unit_id'])];
      (portions[foodId] ??= []).add(
        FdcPortion(
          id: id,
          amount: r['amount'],
          measureUnit: unit == _undeterminedUnit ? null : unit,
          portionDescription: r['portion_description'],
          modifier: r['modifier'],
          gramWeight: gramWeight,
        ),
      );
    }
    for (final list in portions.values) {
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return portions;
  }

  static bool _hasFile(Directory folder, String name) =>
      File('${folder.path}/$name').existsSync();
}
