import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:sync/src/core/hlc.dart';

/// Identifies one field of one entity: the unit the merge works on.
typedef FieldKey = ({String entity, String entityId, String field});

/// One field of one entity set to a new value, by one device
/// (ENGINEERING.md §8.1).
///
/// Every local write produces changes, and every device merges them with
/// the same rule: for each [FieldKey], the change with the highest [hlc]
/// wins.
@immutable
final class const Change({
  /// Unique id of this change, so applying it twice is harmless.
  required final String id,

  /// Entity kind, such as `recipe` or `ingredient_line`.
  required final String entity,

  /// The id of the entity this change belongs to.
  required final String entityId,

  /// The field this change sets, or [deletedField] for a tombstone.
  required final String field,

  /// The new value: a JSON-compatible value (null, bool, num, String, or
  /// lists and string-keyed maps of those).
  required final Object? value,

  /// When this change was made. Decides which change wins.
  required final Hlc hlc,

  /// The device that made this change.
  required final String deviceId,

  /// The library or share this change belongs to.
  required final String spaceId,
}) {
  /// Reads a change written by [toJson].
  factory fromJson(Map<String, Object?> json) => Change(
    id: json['id']! as String,
    entity: json['entity']! as String,
    entityId: json['entityId']! as String,
    field: json['field']! as String,
    value: json['value'],
    hlc: Hlc.parse(json['hlc']! as String),
    deviceId: json['deviceId']! as String,
    spaceId: json['spaceId']! as String,
  );

  /// The field a delete sets to `true`. Deletes are tombstones, so a
  /// delete and an offline edit to the same entity resolve predictably.
  static const deletedField = '_deleted';

  static const _equality = DeepCollectionEquality();

  /// The field this change sets.
  FieldKey get key => (entity: entity, entityId: entityId, field: field);

  /// Whether this change deletes its entity.
  bool get isTombstone => field == deletedField && value == true;

  /// A JSON-compatible map, for transports.
  Map<String, Object?> toJson() => {
    'id': id,
    'entity': entity,
    'entityId': entityId,
    'field': field,
    'value': value,
    'hlc': hlc.pack(),
    'deviceId': deviceId,
    'spaceId': spaceId,
  };

  @override
  bool operator ==(Object other) =>
      other is Change &&
      other.id == id &&
      other.entity == entity &&
      other.entityId == entityId &&
      other.field == field &&
      _equality.equals(other.value, value) &&
      other.hlc == hlc &&
      other.deviceId == deviceId &&
      other.spaceId == spaceId;

  @override
  int get hashCode => Object.hash(
    id,
    entity,
    entityId,
    field,
    _equality.hash(value),
    hlc,
    deviceId,
    spaceId,
  );

  @override
  String toString() => 'Change($id: $entity/$entityId.$field = $value @ $hlc)';
}
