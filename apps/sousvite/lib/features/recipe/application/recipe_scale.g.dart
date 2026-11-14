// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_scale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// How much this recipe is scaled for cooking: 2 is a double batch
/// (PRD 7.6). Shared by the recipe page and cooking mode, so amounts in the
/// steps follow the scaling chosen on the page.
///
/// This is not the serving size that per-serving nutrition divides by;
/// that is remembered in `UserRecipePrefs` (PRD 7.4). The scale lasts while
/// the app runs.

@ProviderFor(RecipeScale)
final recipeScaleProvider = RecipeScaleFamily._();

/// How much this recipe is scaled for cooking: 2 is a double batch
/// (PRD 7.6). Shared by the recipe page and cooking mode, so amounts in the
/// steps follow the scaling chosen on the page.
///
/// This is not the serving size that per-serving nutrition divides by;
/// that is remembered in `UserRecipePrefs` (PRD 7.4). The scale lasts while
/// the app runs.
final class RecipeScaleProvider
    extends $NotifierProvider<RecipeScale, Quantity> {
  /// How much this recipe is scaled for cooking: 2 is a double batch
  /// (PRD 7.6). Shared by the recipe page and cooking mode, so amounts in the
  /// steps follow the scaling chosen on the page.
  ///
  /// This is not the serving size that per-serving nutrition divides by;
  /// that is remembered in `UserRecipePrefs` (PRD 7.4). The scale lasts while
  /// the app runs.
  RecipeScaleProvider._({
    required RecipeScaleFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'recipeScaleProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeScaleHash();

  @override
  String toString() {
    return r'recipeScaleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RecipeScale create() => RecipeScale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Quantity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Quantity>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeScaleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeScaleHash() => r'83ac7a06df12acd86de81d840ff0a1266b27c82a';

/// How much this recipe is scaled for cooking: 2 is a double batch
/// (PRD 7.6). Shared by the recipe page and cooking mode, so amounts in the
/// steps follow the scaling chosen on the page.
///
/// This is not the serving size that per-serving nutrition divides by;
/// that is remembered in `UserRecipePrefs` (PRD 7.4). The scale lasts while
/// the app runs.

final class RecipeScaleFamily extends $Family
    with
        $ClassFamilyOverride<
          RecipeScale,
          Quantity,
          Quantity,
          Quantity,
          RecipeId
        > {
  RecipeScaleFamily._()
    : super(
        retry: null,
        name: r'recipeScaleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// How much this recipe is scaled for cooking: 2 is a double batch
  /// (PRD 7.6). Shared by the recipe page and cooking mode, so amounts in the
  /// steps follow the scaling chosen on the page.
  ///
  /// This is not the serving size that per-serving nutrition divides by;
  /// that is remembered in `UserRecipePrefs` (PRD 7.4). The scale lasts while
  /// the app runs.

  RecipeScaleProvider call(RecipeId recipeId) =>
      RecipeScaleProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeScaleProvider';
}

/// How much this recipe is scaled for cooking: 2 is a double batch
/// (PRD 7.6). Shared by the recipe page and cooking mode, so amounts in the
/// steps follow the scaling chosen on the page.
///
/// This is not the serving size that per-serving nutrition divides by;
/// that is remembered in `UserRecipePrefs` (PRD 7.4). The scale lasts while
/// the app runs.

abstract class _$RecipeScale extends $Notifier<Quantity> {
  late final _$args = ref.$arg as RecipeId;
  RecipeId get recipeId => _$args;

  Quantity build(RecipeId recipeId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Quantity, Quantity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Quantity, Quantity>,
              Quantity,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// How many servings the batch makes at the current scale. Null until the
/// recipe loads.

@ProviderFor(scaledServings)
final scaledServingsProvider = ScaledServingsFamily._();

/// How many servings the batch makes at the current scale. Null until the
/// recipe loads.

final class ScaledServingsProvider
    extends $FunctionalProvider<Quantity?, Quantity?, Quantity?>
    with $Provider<Quantity?> {
  /// How many servings the batch makes at the current scale. Null until the
  /// recipe loads.
  ScaledServingsProvider._({
    required ScaledServingsFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'scaledServingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scaledServingsHash();

  @override
  String toString() {
    return r'scaledServingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Quantity?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Quantity? create(Ref ref) {
    final argument = this.argument as RecipeId;
    return scaledServings(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Quantity? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Quantity?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScaledServingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scaledServingsHash() => r'd673e5b863aff183dc7cf57978c2a2c8b9c2ccee';

/// How many servings the batch makes at the current scale. Null until the
/// recipe loads.

final class ScaledServingsFamily extends $Family
    with $FunctionalFamilyOverride<Quantity?, RecipeId> {
  ScaledServingsFamily._()
    : super(
        retry: null,
        name: r'scaledServingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// How many servings the batch makes at the current scale. Null until the
  /// recipe loads.

  ScaledServingsProvider call(RecipeId recipeId) =>
      ScaledServingsProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'scaledServingsProvider';
}

/// One line's amount at the current scale. Null while loading or when the
/// line is gone.
///
/// Unit conversion and rounding to amounts people can measure come from
/// `FND-1` and are applied here once it lands.

@ProviderFor(scaledLineAmount)
final scaledLineAmountProvider = ScaledLineAmountFamily._();

/// One line's amount at the current scale. Null while loading or when the
/// line is gone.
///
/// Unit conversion and rounding to amounts people can measure come from
/// `FND-1` and are applied here once it lands.

final class ScaledLineAmountProvider
    extends $FunctionalProvider<ScaledAmount?, ScaledAmount?, ScaledAmount?>
    with $Provider<ScaledAmount?> {
  /// One line's amount at the current scale. Null while loading or when the
  /// line is gone.
  ///
  /// Unit conversion and rounding to amounts people can measure come from
  /// `FND-1` and are applied here once it lands.
  ScaledLineAmountProvider._({
    required ScaledLineAmountFamily super.from,
    required (RecipeId, IngredientLineId) super.argument,
  }) : super(
         retry: null,
         name: r'scaledLineAmountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scaledLineAmountHash();

  @override
  String toString() {
    return r'scaledLineAmountProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<ScaledAmount?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScaledAmount? create(Ref ref) {
    final argument = this.argument as (RecipeId, IngredientLineId);
    return scaledLineAmount(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScaledAmount? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScaledAmount?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScaledLineAmountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scaledLineAmountHash() => r'a40964b516c06e08589fe0402b37a5109f807c25';

/// One line's amount at the current scale. Null while loading or when the
/// line is gone.
///
/// Unit conversion and rounding to amounts people can measure come from
/// `FND-1` and are applied here once it lands.

final class ScaledLineAmountFamily extends $Family
    with
        $FunctionalFamilyOverride<ScaledAmount?, (RecipeId, IngredientLineId)> {
  ScaledLineAmountFamily._()
    : super(
        retry: null,
        name: r'scaledLineAmountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One line's amount at the current scale. Null while loading or when the
  /// line is gone.
  ///
  /// Unit conversion and rounding to amounts people can measure come from
  /// `FND-1` and are applied here once it lands.

  ScaledLineAmountProvider call(RecipeId recipeId, IngredientLineId lineId) =>
      ScaledLineAmountProvider._(argument: (recipeId, lineId), from: this);

  @override
  String toString() => r'scaledLineAmountProvider';
}
