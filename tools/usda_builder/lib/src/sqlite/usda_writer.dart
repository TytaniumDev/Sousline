import 'dart:io';

import 'package:sqlite3/sqlite3.dart';
import 'package:usda_builder/src/model/usda_dataset.dart';
import 'package:usda_builder/src/sqlite/usda_schema.dart';

/// Writes [dataset] to a new SQLite file at [output], replacing any file
/// already there.
///
/// The same dataset always produces the same bytes (with the same SQLite
/// version), so regenerating an unchanged release leaves no Git diff. The
/// file is built next to [output] and renamed into place, so a failed build
/// never leaves a half-written file behind.
void writeUsdaDatabase(UsdaDataset dataset, File output) {
  output.parent.createSync(recursive: true);
  final temporary = File('${output.path}.tmp');
  if (temporary.existsSync()) temporary.deleteSync();

  final database = sqlite3.open(temporary.path);
  try {
    database
      ..execute('PRAGMA journal_mode = OFF')
      ..userVersion = usdaSchemaVersion;
    usdaSchema.forEach(database.execute);
    database.execute('BEGIN');
    _insertFoods(database, dataset);
    _insertReference(database, dataset);
    database
      ..execute('COMMIT')
      ..execute('VACUUM');
  } finally {
    database.close();
  }
  temporary.renameSync(output.path);
}

void _insertFoods(Database database, UsdaDataset dataset) {
  final food = database.prepare(
    'INSERT INTO foods (id, source, external_id, name) '
    "VALUES (?, 'usda', ?, ?)",
  );
  final nutrient = database.prepare(
    'INSERT INTO food_nutrients (food_id, nutrient_code, amount_per100g) '
    'VALUES (?, ?, ?)',
  );
  final portion = database.prepare(
    'INSERT INTO food_portions (id, food_id, amount_numerator, '
    'amount_denominator, gram_weight, unit, description) '
    'VALUES (?, ?, ?, ?, ?, ?, ?)',
  );
  try {
    for (final item in dataset.foods) {
      food.execute([item.id, '${item.fdcId}', item.name]);
      for (final MapEntry(:key, :value) in item.nutrients.entries) {
        nutrient.execute([item.id, key, value]);
      }
      for (final p in item.portions) {
        portion.execute([
          p.id,
          item.id,
          p.amountNumerator,
          p.amountDenominator,
          p.gramWeight,
          p.unit,
          p.description,
        ]);
      }
    }
  } finally {
    food.close();
    nutrient.close();
    portion.close();
  }
}

void _insertReference(Database database, UsdaDataset dataset) {
  final nutrient = database.prepare(
    'INSERT INTO nutrients (code, name, unit) VALUES (?, ?, ?)',
  );
  final metadata = database.prepare(
    'INSERT INTO metadata (key, value) VALUES (?, ?)',
  );
  try {
    for (final item in dataset.nutrients) {
      nutrient.execute([item.code, item.name, item.unit]);
    }
    for (final MapEntry(:key, :value) in dataset.metadata.entries) {
      metadata.execute([key, value]);
    }
  } finally {
    nutrient.close();
    metadata.close();
  }
}
