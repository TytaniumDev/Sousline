import 'package:usda_builder/src/model/usda_food.dart';

/// Combines Foundation Foods and SR Legacy into one list with one food per
/// name, ordered by FDC id.
///
/// Many names appear more than once: "Broccoli, raw" is in both releases,
/// and "Strawberries, raw" is in Foundation Foods four times, from separate
/// sample sets. Matching needs one food per name, so the best one is kept:
/// Foundation Foods first (newer analyses), then the food with the most
/// nutrient values, then the newest (highest FDC id).
///
/// Foundation foods often lack household portions. When the kept food has
/// none, it takes the portions of the best same-name food that has some: a
/// cup of sliced strawberries weighs the same whichever analysis it was in.
List<UsdaFood> mergeReleases({
  required List<UsdaFood> foundation,
  required List<UsdaFood> srLegacy,
}) {
  final groups = <String, List<_Candidate>>{};
  for (final (release, foods) in [(0, foundation), (1, srLegacy)]) {
    for (final food in foods) {
      (groups[_key(food.name)] ??= []).add(_Candidate(food, release));
    }
  }
  return [for (final group in groups.values) _best(group)]
    ..sort((a, b) => a.fdcId.compareTo(b.fdcId));
}

UsdaFood _best(List<_Candidate> group) {
  final ranked = [...group]..sort(_Candidate.compare);
  final kept = ranked.first.food;
  if (kept.portions.isNotEmpty) return kept;
  final withPortions = ranked.where((c) => c.food.portions.isNotEmpty);
  if (withPortions.isEmpty) return kept;
  return UsdaFood(
    fdcId: kept.fdcId,
    name: kept.name,
    nutrients: kept.nutrients,
    portions: withPortions.first.food.portions,
  );
}

String _key(String name) => name.trim().toLowerCase();

/// A food and the release it came from (0 for Foundation Foods).
final class const _Candidate(final UsdaFood food, final int release) {
  /// Best first: earlier release, more nutrients, then higher FDC id.
  static int compare(_Candidate a, _Candidate b) {
    if (a.release != b.release) return a.release.compareTo(b.release);
    final byNutrients = b.food.nutrients.length.compareTo(
      a.food.nutrients.length,
    );
    if (byNutrients != 0) return byNutrients;
    return b.food.fdcId.compareTo(a.food.fdcId);
  }
}
