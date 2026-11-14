// An interface has no code to run; only its empty primary constructor
// would show up, as an uncovered line.
// coverage:ignore-file

import 'package:domain/src/entities/food.dart';
import 'package:domain/src/entities/food_nutrient.dart';
import 'package:domain/src/entities/food_portion.dart';
import 'package:domain/src/entities/nutrition_match.dart';
import 'package:domain/src/value_objects/ids.dart';

/// Foods with their nutrients and portions, and the matches from
/// ingredient lines to foods.
abstract interface class FoodRepository() {
  Future<Food?> getFood(FoodId id);

  Future<List<FoodNutrient>> getNutrients(FoodId foodId);

  Future<List<FoodPortion>> getPortions(FoodId foodId);

  /// Bundled and cached foods whose names match [query], best first, for
  /// changing a match by hand (PRD 7.4). Branded products found online
  /// come from the app's `NutritionApi` instead.
  Future<List<Food>> searchFoods(String query, {int limit = 20});

  /// Caches a food fetched online, so recipes using it work offline.
  Future<void> saveFood(
    Food food, {
    required List<FoodNutrient> nutrients,
    required List<FoodPortion> portions,
  });

  /// The match for each of a recipe's lines that has one.
  Stream<List<NutritionMatch>> watchMatches(RecipeId recipeId);

  Future<void> saveMatch(NutritionMatch match);

  Future<void> deleteMatch(NutritionMatchId id);
}
