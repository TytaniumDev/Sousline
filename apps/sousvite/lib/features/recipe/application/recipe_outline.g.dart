// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_outline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The recipe's ingredient lines grouped by section.

@ProviderFor(ingredientOutline)
final ingredientOutlineProvider = IngredientOutlineFamily._();

/// The recipe's ingredient lines grouped by section.

final class IngredientOutlineProvider
    extends
        $FunctionalProvider<
          AsyncValue<IngredientOutline>,
          AsyncValue<IngredientOutline>,
          AsyncValue<IngredientOutline>
        >
    with $Provider<AsyncValue<IngredientOutline>> {
  /// The recipe's ingredient lines grouped by section.
  IngredientOutlineProvider._({
    required IngredientOutlineFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'ingredientOutlineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientOutlineHash();

  @override
  String toString() {
    return r'ingredientOutlineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<IngredientOutline>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<IngredientOutline> create(Ref ref) {
    final argument = this.argument as RecipeId;
    return ingredientOutline(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<IngredientOutline> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<IngredientOutline>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientOutlineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientOutlineHash() => r'88375bf75236bcda53987be1923400b4b4932d13';

/// The recipe's ingredient lines grouped by section.

final class IngredientOutlineFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<IngredientOutline>, RecipeId> {
  IngredientOutlineFamily._()
    : super(
        retry: null,
        name: r'ingredientOutlineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe's ingredient lines grouped by section.

  IngredientOutlineProvider call(RecipeId recipeId) =>
      IngredientOutlineProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'ingredientOutlineProvider';
}

/// The recipe's steps grouped by section, in cooking order.

@ProviderFor(stepOutline)
final stepOutlineProvider = StepOutlineFamily._();

/// The recipe's steps grouped by section, in cooking order.

final class StepOutlineProvider
    extends
        $FunctionalProvider<
          AsyncValue<StepOutline>,
          AsyncValue<StepOutline>,
          AsyncValue<StepOutline>
        >
    with $Provider<AsyncValue<StepOutline>> {
  /// The recipe's steps grouped by section, in cooking order.
  StepOutlineProvider._({
    required StepOutlineFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'stepOutlineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stepOutlineHash();

  @override
  String toString() {
    return r'stepOutlineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<StepOutline>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<StepOutline> create(Ref ref) {
    final argument = this.argument as RecipeId;
    return stepOutline(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StepOutline> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<StepOutline>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StepOutlineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stepOutlineHash() => r'80f3d5caa98616881dddabd035ee96cc5fb1ea08';

/// The recipe's steps grouped by section, in cooking order.

final class StepOutlineFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<StepOutline>, RecipeId> {
  StepOutlineFamily._()
    : super(
        retry: null,
        name: r'stepOutlineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe's steps grouped by section, in cooking order.

  StepOutlineProvider call(RecipeId recipeId) =>
      StepOutlineProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'stepOutlineProvider';
}
