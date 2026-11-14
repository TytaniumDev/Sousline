/// Builds the bundled USDA SQLite file from the FoodData Central CSV release.
/// See ENGINEERING.md §11.1 and this package's README.
library;

export 'src/build_usda_dataset.dart';
export 'src/cli/usda_builder_command.dart';
export 'src/fdc/fdc_release.dart';
export 'src/model/usda_dataset.dart';
export 'src/model/usda_food.dart';
export 'src/model/usda_nutrient.dart';
export 'src/model/usda_portion.dart';
export 'src/sqlite/usda_schema.dart';
export 'src/sqlite/usda_writer.dart';
