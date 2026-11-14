# usda_builder

Builds `apps/sousvite/assets/nutrition/usda_foods.sqlite`, the read-only food database the app ships with (ENGINEERING.md §11.1). It reads two USDA FoodData Central CSV releases:

- **Foundation Foods**: newer lab analyses of common ingredients.
- **SR Legacy**: the older Standard Reference, with far more foods and household portions.

The output file is committed to the repo as a normal file (BUILD_PLAN §9.1). Never edit it by hand; regenerate it with this tool.

## Regenerating the file

USDA publishes Foundation Foods about twice a year. SR Legacy is frozen at its 2018 release.

1. Download the CSV zips from <https://fdc.nal.usda.gov/download-datasets> and unzip them:

   ```sh
   cd "$(mktemp -d)"
   curl -O https://fdc.nal.usda.gov/fdc-datasets/FoodData_Central_foundation_food_csv_2026-04-30.zip
   curl -O https://fdc.nal.usda.gov/fdc-datasets/FoodData_Central_sr_legacy_food_csv_2018-04.zip
   unzip -q FoodData_Central_foundation_food_csv_2026-04-30.zip
   unzip -q FoodData_Central_sr_legacy_food_csv_2018-04.zip
   ```

2. From `tools/usda_builder`, run:

   ```sh
   dart run usda_builder \
     --foundation <tmp>/FoodData_Central_foundation_food_csv_2026-04-30 \
     --sr-legacy <tmp>/FoodData_Central_sr_legacy_food_csv_2018-04 \
     --output ../../apps/sousvite/assets/nutrition/usda_foods.sqlite
   ```

3. Commit the new file. The same releases always produce the same bytes, so an unchanged release leaves no diff.

The tool checks that each folder has `food.csv`, `food_nutrient.csv`, `food_portion.csv`, `measure_unit.csv`, and `nutrient.csv` before it builds. The Foundation Foods zip dated 2026-10-29 is missing three of them, so the committed file uses the 2026-04-30 release. Use a newer one once USDA publishes a complete zip.

## What goes in

- **Foods:** every `foundation_food` row of the Foundation release and every `sr_legacy_food` row of SR Legacy. Foods with none of the nutrients below are dropped.
- **One food per name.** Some names repeat: "Broccoli, raw" is in both releases, and "Strawberries, raw" is in Foundation Foods four times. Matching needs one food per name, so the tool keeps Foundation over SR Legacy, then the food with the most nutrient values, then the newest FDC id. When the kept food has no portions, it takes them from the best same-name food that has some, since a cup of sliced strawberries weighs the same in either analysis.
- **Nutrients:** 31 nutrients from `lib/src/transform/nutrient_selection.dart`: energy, macros, the rest of a US nutrition label, and common vitamins and minerals. Values are per 100 g. Where a food lacks a nutrient's own number, the tool uses a fallback with the same unit:

  | Code | Nutrient | Fallbacks |
  |---|---|---|
  | 208 | Energy (kcal) | 958 (Atwater specific), 957 (Atwater general) |
  | 204 | Total fat | 298 (total fat, NLEA) |
  | 205 | Carbohydrate, by difference | 205.2 (by summation) |
  | 269 | Total sugars | 269.3 (sugars, total NLEA) |

  Foundation Foods reports energy as Atwater energy for most foods, so without the fallbacks most of them would have no calories.

- **Portions:** each `food_portion.csv` row with a positive amount and gram weight. Amounts become exact fractions: USDA's rounded "0.33" becomes 1/3 (any sixteenth, twelfth, or third within 0.01), and other decimals are exact ("0.2" is 1/5). Volume and weight words become the app's `Unit` names (`cup`, `tablespoon`, `fluidOunce`, `ounce`, ...). Counts such as "1 large" have no unit and keep the wording in `description`.

## Schema (version 1)

`PRAGMA user_version` and the `schema_version` metadata row hold the schema version. Bump `usdaSchemaVersion` in `lib/src/sqlite/usda_schema.dart` and document the new version here whenever the tables change.

`foods`, `food_nutrients`, and `food_portions` have the same columns as the Drift tables in `packages/data/lib/src/tables/food_tables.dart`, so the app can attach this file and read it with the same queries (ENGINEERING.md §7.1).

| Table | Columns | Notes |
|---|---|---|
| `foods` | `id` TEXT PK, `source` TEXT, `external_id` TEXT, `name` TEXT, `brand` TEXT NULL | `id` is `usda:<fdc id>`, `source` is always `usda`, `external_id` is the FDC id, `brand` is always null. Unique index `foods_source_external` on (`source`, `external_id`) |
| `food_nutrients` | `food_id` TEXT, `nutrient_code` TEXT, `amount_per100g` REAL | Primary key (`food_id`, `nutrient_code`), `WITHOUT ROWID`. `nutrient_code` is the USDA nutrient number |
| `food_portions` | `id` TEXT PK, `food_id` TEXT, `amount_numerator` INTEGER, `amount_denominator` INTEGER, `gram_weight` REAL, `unit` TEXT NULL, `description` TEXT | `id` is `usda-portion:<food_portion.csv id>`. `unit` is a `Unit` name, or null for counts. `description` is the release's wording, such as "1 cup, chopped". Index `food_portions_food` on `food_id` |
| `nutrients` | `code` TEXT PK, `name` TEXT, `unit` TEXT | The 31 nutrients above. `unit` is `g`, `mg`, `ug`, or `kcal` |
| `metadata` | `key` TEXT PK, `value` TEXT | `schema_version`, `foundation_release`, `sr_legacy_release` (the release folder names), and `source` (the USDA citation) |

## Size

About 9 MB on disk and under 2 MB compressed, which is how Git, app stores, and web hosting carry it. Most of it is `food_nutrients` (about 214,000 rows).

## License

FoodData Central data is in the public domain. The `source` metadata row holds the citation USDA asks for.
