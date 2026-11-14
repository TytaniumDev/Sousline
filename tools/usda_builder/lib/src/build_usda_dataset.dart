import 'package:usda_builder/src/fdc/fdc_release.dart';
import 'package:usda_builder/src/model/usda_dataset.dart';
import 'package:usda_builder/src/sqlite/usda_schema.dart';
import 'package:usda_builder/src/transform/food_conversion.dart';
import 'package:usda_builder/src/transform/nutrient_selection.dart';
import 'package:usda_builder/src/transform/release_merge.dart';

/// Reads the Foundation Foods and SR Legacy releases and combines them into
/// the dataset the bundled file holds.
Future<UsdaDataset> buildUsdaDataset({
  required FdcRelease foundation,
  required FdcRelease srLegacy,
}) async {
  final numbers = sourceNumbers();
  final foundationData = await foundation.read(
    dataType: 'foundation_food',
    nutrientNumbers: numbers,
  );
  final srLegacyData = await srLegacy.read(
    dataType: 'sr_legacy_food',
    nutrientNumbers: numbers,
  );
  return UsdaDataset(
    foods: mergeReleases(
      foundation: foundationData.foods.map(convertFood).nonNulls.toList(),
      srLegacy: srLegacyData.foods.map(convertFood).nonNulls.toList(),
    ),
    // The newer release's names win where both define a nutrient.
    nutrients: describeNutrients({
      ...srLegacyData.nutrients,
      ...foundationData.nutrients,
    }),
    metadata: {
      'schema_version': '$usdaSchemaVersion',
      'foundation_release': foundationData.name,
      'sr_legacy_release': srLegacyData.name,
      'source':
          'U.S. Department of Agriculture, Agricultural Research Service. '
          'FoodData Central, fdc.nal.usda.gov. Public domain.',
    },
  );
}
