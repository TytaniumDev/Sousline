// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecipeSnapshot {

 Recipe get recipe; List<IngredientSection> get ingredientSections; List<IngredientLine> get ingredientLines; List<StepSection> get stepSections; List<RecipeStep> get steps;
/// Create a copy of RecipeSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeSnapshotCopyWith<RecipeSnapshot> get copyWith => _$RecipeSnapshotCopyWithImpl<RecipeSnapshot>(this as RecipeSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecipeSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeSnapshot&&(identical(other.recipe, _this.recipe) || other.recipe == _this.recipe)&&const DeepCollectionEquality().equals(other.ingredientSections, _this.ingredientSections)&&const DeepCollectionEquality().equals(other.ingredientLines, _this.ingredientLines)&&const DeepCollectionEquality().equals(other.stepSections, _this.stepSections)&&const DeepCollectionEquality().equals(other.steps, _this.steps));
}


@override
int get hashCode {
  final _this = this as RecipeSnapshot;
  return Object.hash(runtimeType,_this.recipe,const DeepCollectionEquality().hash(_this.ingredientSections),const DeepCollectionEquality().hash(_this.ingredientLines),const DeepCollectionEquality().hash(_this.stepSections),const DeepCollectionEquality().hash(_this.steps));
}

@override
String toString() {
  final _this = this as RecipeSnapshot;
  return 'RecipeSnapshot(recipe: ${_this.recipe}, ingredientSections: ${_this.ingredientSections}, ingredientLines: ${_this.ingredientLines}, stepSections: ${_this.stepSections}, steps: ${_this.steps})';
}


}

/// @nodoc
abstract mixin class $RecipeSnapshotCopyWith<$Res>  {
  factory $RecipeSnapshotCopyWith(RecipeSnapshot value, $Res Function(RecipeSnapshot) _then) = _$RecipeSnapshotCopyWithImpl;
@useResult
$Res call({
 Recipe recipe, List<IngredientSection> ingredientSections, List<IngredientLine> ingredientLines, List<StepSection> stepSections, List<RecipeStep> steps
});


$RecipeCopyWith<$Res> get recipe;

}
/// @nodoc
class _$RecipeSnapshotCopyWithImpl<$Res>
    implements $RecipeSnapshotCopyWith<$Res> {
  _$RecipeSnapshotCopyWithImpl(this._self, this._then);

  final RecipeSnapshot _self;
  final $Res Function(RecipeSnapshot) _then;

/// Create a copy of RecipeSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipe = null,Object? ingredientSections = null,Object? ingredientLines = null,Object? stepSections = null,Object? steps = null,}) {
  return _then(RecipeSnapshot(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as Recipe,ingredientSections: null == ingredientSections ? _self.ingredientSections : ingredientSections // ignore: cast_nullable_to_non_nullable
as List<IngredientSection>,ingredientLines: null == ingredientLines ? _self.ingredientLines : ingredientLines // ignore: cast_nullable_to_non_nullable
as List<IngredientLine>,stepSections: null == stepSections ? _self.stepSections : stepSections // ignore: cast_nullable_to_non_nullable
as List<StepSection>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<RecipeStep>,
  ));
}
/// Create a copy of RecipeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeCopyWith<$Res> get recipe {
  
  return $RecipeCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecipeSnapshot].
extension RecipeSnapshotPatterns on RecipeSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _RecipeSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Recipe recipe,  List<IngredientSection> ingredientSections,  List<IngredientLine> ingredientLines,  List<StepSection> stepSections,  List<RecipeStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeSnapshot() when $default != null:
return $default(_that.recipe,_that.ingredientSections,_that.ingredientLines,_that.stepSections,_that.steps);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Recipe recipe,  List<IngredientSection> ingredientSections,  List<IngredientLine> ingredientLines,  List<StepSection> stepSections,  List<RecipeStep> steps)  $default,) {final _that = this;
switch (_that) {
case _RecipeSnapshot():
return $default(_that.recipe,_that.ingredientSections,_that.ingredientLines,_that.stepSections,_that.steps);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Recipe recipe,  List<IngredientSection> ingredientSections,  List<IngredientLine> ingredientLines,  List<StepSection> stepSections,  List<RecipeStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _RecipeSnapshot() when $default != null:
return $default(_that.recipe,_that.ingredientSections,_that.ingredientLines,_that.stepSections,_that.steps);case _:
  return null;

}
}

}

/// @nodoc


class _RecipeSnapshot implements RecipeSnapshot {
  const _RecipeSnapshot({required this.recipe,  List<IngredientSection> ingredientSections = const <IngredientSection>[],  List<IngredientLine> ingredientLines = const <IngredientLine>[],  List<StepSection> stepSections = const <StepSection>[],  List<RecipeStep> steps = const <RecipeStep>[]}): _ingredientSections = ingredientSections,_ingredientLines = ingredientLines,_stepSections = stepSections,_steps = steps;
  

@override final  Recipe recipe;
 final  List<IngredientSection> _ingredientSections;
@override@JsonKey() List<IngredientSection> get ingredientSections {
  if (_ingredientSections is EqualUnmodifiableListView) return _ingredientSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientSections);
}

 final  List<IngredientLine> _ingredientLines;
@override@JsonKey() List<IngredientLine> get ingredientLines {
  if (_ingredientLines is EqualUnmodifiableListView) return _ingredientLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientLines);
}

 final  List<StepSection> _stepSections;
@override@JsonKey() List<StepSection> get stepSections {
  if (_stepSections is EqualUnmodifiableListView) return _stepSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stepSections);
}

 final  List<RecipeStep> _steps;
@override@JsonKey() List<RecipeStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of RecipeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeSnapshotCopyWith<_RecipeSnapshot> get copyWith => __$RecipeSnapshotCopyWithImpl<_RecipeSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeSnapshot&&(identical(other.recipe, recipe) || other.recipe == recipe)&&const DeepCollectionEquality().equals(other.ingredientSections, _ingredientSections)&&const DeepCollectionEquality().equals(other.ingredientLines, _ingredientLines)&&const DeepCollectionEquality().equals(other.stepSections, _stepSections)&&const DeepCollectionEquality().equals(other.steps, _steps));
}


@override
int get hashCode {
    return Object.hash(runtimeType,recipe,const DeepCollectionEquality().hash(_ingredientSections),const DeepCollectionEquality().hash(_ingredientLines),const DeepCollectionEquality().hash(_stepSections),const DeepCollectionEquality().hash(_steps));
}

@override
String toString() {
    return 'RecipeSnapshot(recipe: $recipe, ingredientSections: $ingredientSections, ingredientLines: $ingredientLines, stepSections: $stepSections, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$RecipeSnapshotCopyWith<$Res> implements $RecipeSnapshotCopyWith<$Res> {
  factory _$RecipeSnapshotCopyWith(_RecipeSnapshot value, $Res Function(_RecipeSnapshot) _then) = __$RecipeSnapshotCopyWithImpl;
@override @useResult
$Res call({
 Recipe recipe, List<IngredientSection> ingredientSections, List<IngredientLine> ingredientLines, List<StepSection> stepSections, List<RecipeStep> steps
});


@override $RecipeCopyWith<$Res> get recipe;

}
/// @nodoc
class __$RecipeSnapshotCopyWithImpl<$Res>
    implements _$RecipeSnapshotCopyWith<$Res> {
  __$RecipeSnapshotCopyWithImpl(this._self, this._then);

  final _RecipeSnapshot _self;
  final $Res Function(_RecipeSnapshot) _then;

/// Create a copy of RecipeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipe = null,Object? ingredientSections = null,Object? ingredientLines = null,Object? stepSections = null,Object? steps = null,}) {
  return _then(_RecipeSnapshot(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as Recipe,ingredientSections: null == ingredientSections ? _self._ingredientSections : ingredientSections // ignore: cast_nullable_to_non_nullable
as List<IngredientSection>,ingredientLines: null == ingredientLines ? _self._ingredientLines : ingredientLines // ignore: cast_nullable_to_non_nullable
as List<IngredientLine>,stepSections: null == stepSections ? _self._stepSections : stepSections // ignore: cast_nullable_to_non_nullable
as List<StepSection>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<RecipeStep>,
  ));
}

/// Create a copy of RecipeSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeCopyWith<$Res> get recipe {
  
  return $RecipeCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}

// dart format on
