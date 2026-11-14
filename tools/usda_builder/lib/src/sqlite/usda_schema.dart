/// The bundled file's schema version, also stored as `PRAGMA user_version`.
///
/// Bump it whenever [usdaSchema] changes, so the app can tell which shape
/// it attached. The README documents every version.
const usdaSchemaVersion = 1;

/// The statements that create the bundled file's tables.
///
/// `foods`, `food_nutrients`, and `food_portions` have the same columns as
/// the Drift tables in `packages/data/lib/src/tables/food_tables.dart`, so
/// the app can attach this file and read it with the same queries.
const usdaSchema = [
  '''
  CREATE TABLE foods (
    id TEXT NOT NULL PRIMARY KEY,
    source TEXT NOT NULL,
    external_id TEXT NOT NULL,
    name TEXT NOT NULL,
    brand TEXT
  )''',
  'CREATE UNIQUE INDEX foods_source_external ON foods (source, external_id)',
  '''
  CREATE TABLE food_nutrients (
    food_id TEXT NOT NULL,
    nutrient_code TEXT NOT NULL,
    amount_per100g REAL NOT NULL,
    PRIMARY KEY (food_id, nutrient_code)
  ) WITHOUT ROWID''',
  '''
  CREATE TABLE food_portions (
    id TEXT NOT NULL PRIMARY KEY,
    food_id TEXT NOT NULL,
    amount_numerator INTEGER NOT NULL,
    amount_denominator INTEGER NOT NULL,
    gram_weight REAL NOT NULL,
    unit TEXT,
    description TEXT NOT NULL DEFAULT ''
  )''',
  'CREATE INDEX food_portions_food ON food_portions (food_id)',
  '''
  CREATE TABLE nutrients (
    code TEXT NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    unit TEXT NOT NULL
  )''',
  '''
  CREATE TABLE metadata (
    key TEXT NOT NULL PRIMARY KEY,
    value TEXT NOT NULL
  )''',
];
