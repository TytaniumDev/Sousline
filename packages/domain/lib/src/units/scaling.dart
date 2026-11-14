import 'package:domain/src/value_objects/quantity.dart';

/// The multiplier that scales a recipe written for [from] servings so it
/// makes [to] servings (PRD 7.6). Exact, so 4 to 6 servings is 3/2.
///
/// Scale each amount with `Amount.scaled`. Throws an [ArgumentError] when
/// [from] is zero.
Quantity servingsMultiplier({required Quantity from, required Quantity to}) =>
    to / from;
