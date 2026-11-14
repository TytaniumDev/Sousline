// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_outline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngredientOutline {

 List<IngredientGroup> get groups;
/// Create a copy of IngredientOutline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientOutlineCopyWith<IngredientOutline> get copyWith => _$IngredientOutlineCopyWithImpl<IngredientOutline>(this as IngredientOutline, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as IngredientOutline;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngredientOutline&&const DeepCollectionEquality().equals(other.groups, _this.groups));
}


@override
int get hashCode {
  final _this = this as IngredientOutline;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groups));
}

@override
String toString() {
  final _this = this as IngredientOutline;
  return 'IngredientOutline(groups: ${_this.groups})';
}


}

/// @nodoc
abstract mixin class $IngredientOutlineCopyWith<$Res>  {
  factory $IngredientOutlineCopyWith(IngredientOutline value, $Res Function(IngredientOutline) _then) = _$IngredientOutlineCopyWithImpl;
@useResult
$Res call({
 List<IngredientGroup> groups
});




}
/// @nodoc
class _$IngredientOutlineCopyWithImpl<$Res>
    implements $IngredientOutlineCopyWith<$Res> {
  _$IngredientOutlineCopyWithImpl(this._self, this._then);

  final IngredientOutline _self;
  final $Res Function(IngredientOutline) _then;

/// Create a copy of IngredientOutline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,}) {
  return _then(IngredientOutline(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<IngredientGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [IngredientOutline].
extension IngredientOutlinePatterns on IngredientOutline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngredientOutline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngredientOutline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngredientOutline value)  $default,){
final _that = this;
switch (_that) {
case _IngredientOutline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngredientOutline value)?  $default,){
final _that = this;
switch (_that) {
case _IngredientOutline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<IngredientGroup> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngredientOutline() when $default != null:
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<IngredientGroup> groups)  $default,) {final _that = this;
switch (_that) {
case _IngredientOutline():
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<IngredientGroup> groups)?  $default,) {final _that = this;
switch (_that) {
case _IngredientOutline() when $default != null:
return $default(_that.groups);case _:
  return null;

}
}

}

/// @nodoc


class _IngredientOutline implements IngredientOutline {
  const _IngredientOutline({required  List<IngredientGroup> groups}): _groups = groups;
  

 final  List<IngredientGroup> _groups;
@override List<IngredientGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of IngredientOutline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientOutlineCopyWith<_IngredientOutline> get copyWith => __$IngredientOutlineCopyWithImpl<_IngredientOutline>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngredientOutline&&const DeepCollectionEquality().equals(other.groups, _groups));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups));
}

@override
String toString() {
    return 'IngredientOutline(groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$IngredientOutlineCopyWith<$Res> implements $IngredientOutlineCopyWith<$Res> {
  factory _$IngredientOutlineCopyWith(_IngredientOutline value, $Res Function(_IngredientOutline) _then) = __$IngredientOutlineCopyWithImpl;
@override @useResult
$Res call({
 List<IngredientGroup> groups
});




}
/// @nodoc
class __$IngredientOutlineCopyWithImpl<$Res>
    implements _$IngredientOutlineCopyWith<$Res> {
  __$IngredientOutlineCopyWithImpl(this._self, this._then);

  final _IngredientOutline _self;
  final $Res Function(_IngredientOutline) _then;

/// Create a copy of IngredientOutline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,}) {
  return _then(_IngredientOutline(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<IngredientGroup>,
  ));
}


}

/// @nodoc
mixin _$IngredientGroup {

 IngredientSectionId? get sectionId; List<IngredientLineId> get lineIds;
/// Create a copy of IngredientGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientGroupCopyWith<IngredientGroup> get copyWith => _$IngredientGroupCopyWithImpl<IngredientGroup>(this as IngredientGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as IngredientGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngredientGroup&&(identical(other.sectionId, _this.sectionId) || other.sectionId == _this.sectionId)&&const DeepCollectionEquality().equals(other.lineIds, _this.lineIds));
}


@override
int get hashCode {
  final _this = this as IngredientGroup;
  return Object.hash(runtimeType,_this.sectionId,const DeepCollectionEquality().hash(_this.lineIds));
}

@override
String toString() {
  final _this = this as IngredientGroup;
  return 'IngredientGroup(sectionId: ${_this.sectionId}, lineIds: ${_this.lineIds})';
}


}

/// @nodoc
abstract mixin class $IngredientGroupCopyWith<$Res>  {
  factory $IngredientGroupCopyWith(IngredientGroup value, $Res Function(IngredientGroup) _then) = _$IngredientGroupCopyWithImpl;
@useResult
$Res call({
 IngredientSectionId? sectionId, List<IngredientLineId> lineIds
});




}
/// @nodoc
class _$IngredientGroupCopyWithImpl<$Res>
    implements $IngredientGroupCopyWith<$Res> {
  _$IngredientGroupCopyWithImpl(this._self, this._then);

  final IngredientGroup _self;
  final $Res Function(IngredientGroup) _then;

/// Create a copy of IngredientGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = freezed,Object? lineIds = null,}) {
  return _then(IngredientGroup(
sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as IngredientSectionId?,lineIds: null == lineIds ? _self.lineIds : lineIds // ignore: cast_nullable_to_non_nullable
as List<IngredientLineId>,
  ));
}

}


/// Adds pattern-matching-related methods to [IngredientGroup].
extension IngredientGroupPatterns on IngredientGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngredientGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngredientGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngredientGroup value)  $default,){
final _that = this;
switch (_that) {
case _IngredientGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngredientGroup value)?  $default,){
final _that = this;
switch (_that) {
case _IngredientGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IngredientSectionId? sectionId,  List<IngredientLineId> lineIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngredientGroup() when $default != null:
return $default(_that.sectionId,_that.lineIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IngredientSectionId? sectionId,  List<IngredientLineId> lineIds)  $default,) {final _that = this;
switch (_that) {
case _IngredientGroup():
return $default(_that.sectionId,_that.lineIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IngredientSectionId? sectionId,  List<IngredientLineId> lineIds)?  $default,) {final _that = this;
switch (_that) {
case _IngredientGroup() when $default != null:
return $default(_that.sectionId,_that.lineIds);case _:
  return null;

}
}

}

/// @nodoc


class _IngredientGroup implements IngredientGroup {
  const _IngredientGroup({required this.sectionId, required  List<IngredientLineId> lineIds}): _lineIds = lineIds;
  

@override final  IngredientSectionId? sectionId;
 final  List<IngredientLineId> _lineIds;
@override List<IngredientLineId> get lineIds {
  if (_lineIds is EqualUnmodifiableListView) return _lineIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineIds);
}


/// Create a copy of IngredientGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientGroupCopyWith<_IngredientGroup> get copyWith => __$IngredientGroupCopyWithImpl<_IngredientGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngredientGroup&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&const DeepCollectionEquality().equals(other.lineIds, _lineIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sectionId,const DeepCollectionEquality().hash(_lineIds));
}

@override
String toString() {
    return 'IngredientGroup(sectionId: $sectionId, lineIds: $lineIds)';
}


}

/// @nodoc
abstract mixin class _$IngredientGroupCopyWith<$Res> implements $IngredientGroupCopyWith<$Res> {
  factory _$IngredientGroupCopyWith(_IngredientGroup value, $Res Function(_IngredientGroup) _then) = __$IngredientGroupCopyWithImpl;
@override @useResult
$Res call({
 IngredientSectionId? sectionId, List<IngredientLineId> lineIds
});




}
/// @nodoc
class __$IngredientGroupCopyWithImpl<$Res>
    implements _$IngredientGroupCopyWith<$Res> {
  __$IngredientGroupCopyWithImpl(this._self, this._then);

  final _IngredientGroup _self;
  final $Res Function(_IngredientGroup) _then;

/// Create a copy of IngredientGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = freezed,Object? lineIds = null,}) {
  return _then(_IngredientGroup(
sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as IngredientSectionId?,lineIds: null == lineIds ? _self._lineIds : lineIds // ignore: cast_nullable_to_non_nullable
as List<IngredientLineId>,
  ));
}


}

/// @nodoc
mixin _$StepOutline {

 List<StepGroup> get groups;
/// Create a copy of StepOutline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepOutlineCopyWith<StepOutline> get copyWith => _$StepOutlineCopyWithImpl<StepOutline>(this as StepOutline, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StepOutline;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepOutline&&const DeepCollectionEquality().equals(other.groups, _this.groups));
}


@override
int get hashCode {
  final _this = this as StepOutline;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groups));
}

@override
String toString() {
  final _this = this as StepOutline;
  return 'StepOutline(groups: ${_this.groups})';
}


}

/// @nodoc
abstract mixin class $StepOutlineCopyWith<$Res>  {
  factory $StepOutlineCopyWith(StepOutline value, $Res Function(StepOutline) _then) = _$StepOutlineCopyWithImpl;
@useResult
$Res call({
 List<StepGroup> groups
});




}
/// @nodoc
class _$StepOutlineCopyWithImpl<$Res>
    implements $StepOutlineCopyWith<$Res> {
  _$StepOutlineCopyWithImpl(this._self, this._then);

  final StepOutline _self;
  final $Res Function(StepOutline) _then;

/// Create a copy of StepOutline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,}) {
  return _then(StepOutline(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<StepGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [StepOutline].
extension StepOutlinePatterns on StepOutline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepOutline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepOutline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepOutline value)  $default,){
final _that = this;
switch (_that) {
case _StepOutline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepOutline value)?  $default,){
final _that = this;
switch (_that) {
case _StepOutline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StepGroup> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepOutline() when $default != null:
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StepGroup> groups)  $default,) {final _that = this;
switch (_that) {
case _StepOutline():
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StepGroup> groups)?  $default,) {final _that = this;
switch (_that) {
case _StepOutline() when $default != null:
return $default(_that.groups);case _:
  return null;

}
}

}

/// @nodoc


class _StepOutline implements StepOutline {
  const _StepOutline({required  List<StepGroup> groups}): _groups = groups;
  

 final  List<StepGroup> _groups;
@override List<StepGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of StepOutline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepOutlineCopyWith<_StepOutline> get copyWith => __$StepOutlineCopyWithImpl<_StepOutline>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepOutline&&const DeepCollectionEquality().equals(other.groups, _groups));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups));
}

@override
String toString() {
    return 'StepOutline(groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$StepOutlineCopyWith<$Res> implements $StepOutlineCopyWith<$Res> {
  factory _$StepOutlineCopyWith(_StepOutline value, $Res Function(_StepOutline) _then) = __$StepOutlineCopyWithImpl;
@override @useResult
$Res call({
 List<StepGroup> groups
});




}
/// @nodoc
class __$StepOutlineCopyWithImpl<$Res>
    implements _$StepOutlineCopyWith<$Res> {
  __$StepOutlineCopyWithImpl(this._self, this._then);

  final _StepOutline _self;
  final $Res Function(_StepOutline) _then;

/// Create a copy of StepOutline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,}) {
  return _then(_StepOutline(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<StepGroup>,
  ));
}


}

/// @nodoc
mixin _$StepGroup {

 StepSectionId? get sectionId; List<RecipeStepId> get stepIds;
/// Create a copy of StepGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepGroupCopyWith<StepGroup> get copyWith => _$StepGroupCopyWithImpl<StepGroup>(this as StepGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StepGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepGroup&&(identical(other.sectionId, _this.sectionId) || other.sectionId == _this.sectionId)&&const DeepCollectionEquality().equals(other.stepIds, _this.stepIds));
}


@override
int get hashCode {
  final _this = this as StepGroup;
  return Object.hash(runtimeType,_this.sectionId,const DeepCollectionEquality().hash(_this.stepIds));
}

@override
String toString() {
  final _this = this as StepGroup;
  return 'StepGroup(sectionId: ${_this.sectionId}, stepIds: ${_this.stepIds})';
}


}

/// @nodoc
abstract mixin class $StepGroupCopyWith<$Res>  {
  factory $StepGroupCopyWith(StepGroup value, $Res Function(StepGroup) _then) = _$StepGroupCopyWithImpl;
@useResult
$Res call({
 StepSectionId? sectionId, List<RecipeStepId> stepIds
});




}
/// @nodoc
class _$StepGroupCopyWithImpl<$Res>
    implements $StepGroupCopyWith<$Res> {
  _$StepGroupCopyWithImpl(this._self, this._then);

  final StepGroup _self;
  final $Res Function(StepGroup) _then;

/// Create a copy of StepGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = freezed,Object? stepIds = null,}) {
  return _then(StepGroup(
sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as StepSectionId?,stepIds: null == stepIds ? _self.stepIds : stepIds // ignore: cast_nullable_to_non_nullable
as List<RecipeStepId>,
  ));
}

}


/// Adds pattern-matching-related methods to [StepGroup].
extension StepGroupPatterns on StepGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepGroup value)  $default,){
final _that = this;
switch (_that) {
case _StepGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepGroup value)?  $default,){
final _that = this;
switch (_that) {
case _StepGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StepSectionId? sectionId,  List<RecipeStepId> stepIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepGroup() when $default != null:
return $default(_that.sectionId,_that.stepIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StepSectionId? sectionId,  List<RecipeStepId> stepIds)  $default,) {final _that = this;
switch (_that) {
case _StepGroup():
return $default(_that.sectionId,_that.stepIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StepSectionId? sectionId,  List<RecipeStepId> stepIds)?  $default,) {final _that = this;
switch (_that) {
case _StepGroup() when $default != null:
return $default(_that.sectionId,_that.stepIds);case _:
  return null;

}
}

}

/// @nodoc


class _StepGroup implements StepGroup {
  const _StepGroup({required this.sectionId, required  List<RecipeStepId> stepIds}): _stepIds = stepIds;
  

@override final  StepSectionId? sectionId;
 final  List<RecipeStepId> _stepIds;
@override List<RecipeStepId> get stepIds {
  if (_stepIds is EqualUnmodifiableListView) return _stepIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stepIds);
}


/// Create a copy of StepGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepGroupCopyWith<_StepGroup> get copyWith => __$StepGroupCopyWithImpl<_StepGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepGroup&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&const DeepCollectionEquality().equals(other.stepIds, _stepIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sectionId,const DeepCollectionEquality().hash(_stepIds));
}

@override
String toString() {
    return 'StepGroup(sectionId: $sectionId, stepIds: $stepIds)';
}


}

/// @nodoc
abstract mixin class _$StepGroupCopyWith<$Res> implements $StepGroupCopyWith<$Res> {
  factory _$StepGroupCopyWith(_StepGroup value, $Res Function(_StepGroup) _then) = __$StepGroupCopyWithImpl;
@override @useResult
$Res call({
 StepSectionId? sectionId, List<RecipeStepId> stepIds
});




}
/// @nodoc
class __$StepGroupCopyWithImpl<$Res>
    implements _$StepGroupCopyWith<$Res> {
  __$StepGroupCopyWithImpl(this._self, this._then);

  final _StepGroup _self;
  final $Res Function(_StepGroup) _then;

/// Create a copy of StepGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = freezed,Object? stepIds = null,}) {
  return _then(_StepGroup(
sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as StepSectionId?,stepIds: null == stepIds ? _self._stepIds : stepIds // ignore: cast_nullable_to_non_nullable
as List<RecipeStepId>,
  ));
}


}

// dart format on
