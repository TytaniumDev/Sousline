// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One recipe, or null once it is deleted.

@ProviderFor(recipe)
final recipeProvider = RecipeFamily._();

/// One recipe, or null once it is deleted.

final class RecipeProvider
    extends $FunctionalProvider<AsyncValue<Recipe?>, Recipe?, Stream<Recipe?>>
    with $FutureModifier<Recipe?>, $StreamProvider<Recipe?> {
  /// One recipe, or null once it is deleted.
  RecipeProvider._({
    required RecipeFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'recipeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeHash();

  @override
  String toString() {
    return r'recipeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Recipe?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Recipe?> create(Ref ref) {
    final argument = this.argument as RecipeId;
    return recipe(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeHash() => r'0231532408f9a274aae88bfeb06fb0a993c5be5e';

/// One recipe, or null once it is deleted.

final class RecipeFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Recipe?>, RecipeId> {
  RecipeFamily._()
    : super(
        retry: null,
        name: r'recipeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One recipe, or null once it is deleted.

  RecipeProvider call(RecipeId recipeId) =>
      RecipeProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeProvider';
}

/// The recipe's ingredient sections, in sort order.

@ProviderFor(ingredientSections)
final ingredientSectionsProvider = IngredientSectionsFamily._();

/// The recipe's ingredient sections, in sort order.

final class IngredientSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IngredientSection>>,
          List<IngredientSection>,
          Stream<List<IngredientSection>>
        >
    with
        $FutureModifier<List<IngredientSection>>,
        $StreamProvider<List<IngredientSection>> {
  /// The recipe's ingredient sections, in sort order.
  IngredientSectionsProvider._({
    required IngredientSectionsFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'ingredientSectionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientSectionsHash();

  @override
  String toString() {
    return r'ingredientSectionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<IngredientSection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<IngredientSection>> create(Ref ref) {
    final argument = this.argument as RecipeId;
    return ingredientSections(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientSectionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientSectionsHash() =>
    r'32f68f57d79c04424fa3336a6972d05a9d382370';

/// The recipe's ingredient sections, in sort order.

final class IngredientSectionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<IngredientSection>>, RecipeId> {
  IngredientSectionsFamily._()
    : super(
        retry: null,
        name: r'ingredientSectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe's ingredient sections, in sort order.

  IngredientSectionsProvider call(RecipeId recipeId) =>
      IngredientSectionsProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'ingredientSectionsProvider';
}

/// The recipe's ingredient lines, in sort order.

@ProviderFor(ingredientLines)
final ingredientLinesProvider = IngredientLinesFamily._();

/// The recipe's ingredient lines, in sort order.

final class IngredientLinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IngredientLine>>,
          List<IngredientLine>,
          Stream<List<IngredientLine>>
        >
    with
        $FutureModifier<List<IngredientLine>>,
        $StreamProvider<List<IngredientLine>> {
  /// The recipe's ingredient lines, in sort order.
  IngredientLinesProvider._({
    required IngredientLinesFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'ingredientLinesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientLinesHash();

  @override
  String toString() {
    return r'ingredientLinesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<IngredientLine>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<IngredientLine>> create(Ref ref) {
    final argument = this.argument as RecipeId;
    return ingredientLines(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientLinesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientLinesHash() => r'9dd1689118f6f0681137b9426690eb5089d70610';

/// The recipe's ingredient lines, in sort order.

final class IngredientLinesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<IngredientLine>>, RecipeId> {
  IngredientLinesFamily._()
    : super(
        retry: null,
        name: r'ingredientLinesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe's ingredient lines, in sort order.

  IngredientLinesProvider call(RecipeId recipeId) =>
      IngredientLinesProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'ingredientLinesProvider';
}

/// The recipe's step sections, in sort order.

@ProviderFor(stepSections)
final stepSectionsProvider = StepSectionsFamily._();

/// The recipe's step sections, in sort order.

final class StepSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StepSection>>,
          List<StepSection>,
          Stream<List<StepSection>>
        >
    with
        $FutureModifier<List<StepSection>>,
        $StreamProvider<List<StepSection>> {
  /// The recipe's step sections, in sort order.
  StepSectionsProvider._({
    required StepSectionsFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'stepSectionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stepSectionsHash();

  @override
  String toString() {
    return r'stepSectionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<StepSection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<StepSection>> create(Ref ref) {
    final argument = this.argument as RecipeId;
    return stepSections(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StepSectionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stepSectionsHash() => r'f3a76355f1f80a693e5c183a207f9bf59d173212';

/// The recipe's step sections, in sort order.

final class StepSectionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<StepSection>>, RecipeId> {
  StepSectionsFamily._()
    : super(
        retry: null,
        name: r'stepSectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe's step sections, in sort order.

  StepSectionsProvider call(RecipeId recipeId) =>
      StepSectionsProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'stepSectionsProvider';
}

/// The recipe's steps, in sort order.

@ProviderFor(recipeSteps)
final recipeStepsProvider = RecipeStepsFamily._();

/// The recipe's steps, in sort order.

final class RecipeStepsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecipeStep>>,
          List<RecipeStep>,
          Stream<List<RecipeStep>>
        >
    with $FutureModifier<List<RecipeStep>>, $StreamProvider<List<RecipeStep>> {
  /// The recipe's steps, in sort order.
  RecipeStepsProvider._({
    required RecipeStepsFamily super.from,
    required RecipeId super.argument,
  }) : super(
         retry: null,
         name: r'recipeStepsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeStepsHash();

  @override
  String toString() {
    return r'recipeStepsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RecipeStep>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecipeStep>> create(Ref ref) {
    final argument = this.argument as RecipeId;
    return recipeSteps(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeStepsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeStepsHash() => r'baa276a887d511d4e184abe438661c4b5c249172';

/// The recipe's steps, in sort order.

final class RecipeStepsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RecipeStep>>, RecipeId> {
  RecipeStepsFamily._()
    : super(
        retry: null,
        name: r'recipeStepsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe's steps, in sort order.

  RecipeStepsProvider call(RecipeId recipeId) =>
      RecipeStepsProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeStepsProvider';
}

/// One ingredient line. Notifies only when this line changes, not when a
/// sibling does. Null while the lines load or once the line is deleted.

@ProviderFor(ingredientLine)
final ingredientLineProvider = IngredientLineFamily._();

/// One ingredient line. Notifies only when this line changes, not when a
/// sibling does. Null while the lines load or once the line is deleted.

final class IngredientLineProvider
    extends
        $FunctionalProvider<IngredientLine?, IngredientLine?, IngredientLine?>
    with $Provider<IngredientLine?> {
  /// One ingredient line. Notifies only when this line changes, not when a
  /// sibling does. Null while the lines load or once the line is deleted.
  IngredientLineProvider._({
    required IngredientLineFamily super.from,
    required (RecipeId, IngredientLineId) super.argument,
  }) : super(
         retry: null,
         name: r'ingredientLineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientLineHash();

  @override
  String toString() {
    return r'ingredientLineProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<IngredientLine?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IngredientLine? create(Ref ref) {
    final argument = this.argument as (RecipeId, IngredientLineId);
    return ingredientLine(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientLine? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientLine?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientLineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientLineHash() => r'314f4376605a4fe4a9200968251e4b5f53297930';

/// One ingredient line. Notifies only when this line changes, not when a
/// sibling does. Null while the lines load or once the line is deleted.

final class IngredientLineFamily extends $Family
    with
        $FunctionalFamilyOverride<
          IngredientLine?,
          (RecipeId, IngredientLineId)
        > {
  IngredientLineFamily._()
    : super(
        retry: null,
        name: r'ingredientLineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One ingredient line. Notifies only when this line changes, not when a
  /// sibling does. Null while the lines load or once the line is deleted.

  IngredientLineProvider call(RecipeId recipeId, IngredientLineId lineId) =>
      IngredientLineProvider._(argument: (recipeId, lineId), from: this);

  @override
  String toString() => r'ingredientLineProvider';
}

/// One step. Notifies only when this step changes.

@ProviderFor(recipeStep)
final recipeStepProvider = RecipeStepFamily._();

/// One step. Notifies only when this step changes.

final class RecipeStepProvider
    extends $FunctionalProvider<RecipeStep?, RecipeStep?, RecipeStep?>
    with $Provider<RecipeStep?> {
  /// One step. Notifies only when this step changes.
  RecipeStepProvider._({
    required RecipeStepFamily super.from,
    required (RecipeId, RecipeStepId) super.argument,
  }) : super(
         retry: null,
         name: r'recipeStepProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeStepHash();

  @override
  String toString() {
    return r'recipeStepProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<RecipeStep?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeStep? create(Ref ref) {
    final argument = this.argument as (RecipeId, RecipeStepId);
    return recipeStep(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeStep? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeStep?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeStepProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeStepHash() => r'c10114f8410e9d4fbeb6a573b4977f2d1540e9e6';

/// One step. Notifies only when this step changes.

final class RecipeStepFamily extends $Family
    with $FunctionalFamilyOverride<RecipeStep?, (RecipeId, RecipeStepId)> {
  RecipeStepFamily._()
    : super(
        retry: null,
        name: r'recipeStepProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One step. Notifies only when this step changes.

  RecipeStepProvider call(RecipeId recipeId, RecipeStepId stepId) =>
      RecipeStepProvider._(argument: (recipeId, stepId), from: this);

  @override
  String toString() => r'recipeStepProvider';
}

/// The name of one ingredient section.

@ProviderFor(ingredientSectionName)
final ingredientSectionNameProvider = IngredientSectionNameFamily._();

/// The name of one ingredient section.

final class IngredientSectionNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// The name of one ingredient section.
  IngredientSectionNameProvider._({
    required IngredientSectionNameFamily super.from,
    required (RecipeId, IngredientSectionId) super.argument,
  }) : super(
         retry: null,
         name: r'ingredientSectionNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientSectionNameHash();

  @override
  String toString() {
    return r'ingredientSectionNameProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as (RecipeId, IngredientSectionId);
    return ingredientSectionName(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientSectionNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientSectionNameHash() =>
    r'356c3b7cb07f387f3ac7b5197df3154f329d188a';

/// The name of one ingredient section.

final class IngredientSectionNameFamily extends $Family
    with $FunctionalFamilyOverride<String?, (RecipeId, IngredientSectionId)> {
  IngredientSectionNameFamily._()
    : super(
        retry: null,
        name: r'ingredientSectionNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The name of one ingredient section.

  IngredientSectionNameProvider call(
    RecipeId recipeId,
    IngredientSectionId sectionId,
  ) => IngredientSectionNameProvider._(
    argument: (recipeId, sectionId),
    from: this,
  );

  @override
  String toString() => r'ingredientSectionNameProvider';
}

/// The name of one step section.

@ProviderFor(stepSectionName)
final stepSectionNameProvider = StepSectionNameFamily._();

/// The name of one step section.

final class StepSectionNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// The name of one step section.
  StepSectionNameProvider._({
    required StepSectionNameFamily super.from,
    required (RecipeId, StepSectionId) super.argument,
  }) : super(
         retry: null,
         name: r'stepSectionNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stepSectionNameHash();

  @override
  String toString() {
    return r'stepSectionNameProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as (RecipeId, StepSectionId);
    return stepSectionName(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StepSectionNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stepSectionNameHash() => r'af810c80a8feeb51a994b397e99d9acc693c3983';

/// The name of one step section.

final class StepSectionNameFamily extends $Family
    with $FunctionalFamilyOverride<String?, (RecipeId, StepSectionId)> {
  StepSectionNameFamily._()
    : super(
        retry: null,
        name: r'stepSectionNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The name of one step section.

  StepSectionNameProvider call(RecipeId recipeId, StepSectionId sectionId) =>
      StepSectionNameProvider._(argument: (recipeId, sectionId), from: this);

  @override
  String toString() => r'stepSectionNameProvider';
}
