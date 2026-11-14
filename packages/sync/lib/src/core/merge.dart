import 'package:collection/collection.dart';
import 'package:sync/src/core/change.dart';

/// Identifies one field of one kind of entity, such as a recipe's notes.
typedef FieldRef = ({String entity, String field});

/// Settings for the merge that depend on the app's data model.
final class const MergePolicy({
  /// Long text fields, such as notes and step text. When a concurrent edit
  /// to one of these loses, its value is kept in the recipe's history
  /// instead of being dropped (ENGINEERING.md §8.1, "never silently
  /// discard").
  final Set<FieldRef> longTextFields = const {},
}) {
  /// Whether a losing edit to [change]'s field should be kept.
  bool keepsLosingValue(Change change) =>
      longTextFields.contains((entity: change.entity, field: change.field));
}

/// What happens when an incoming change meets the current winner of the
/// same field.
sealed class const MergeDecision();

/// The incoming change wins. Write it.
final class const IncomingWins() extends MergeDecision;

/// The current winner stays, and the incoming change is not written.
final class const CurrentWins({
  /// The incoming change, when it is a concurrent long-text edit whose
  /// value must be kept in history. Null when nothing needs keeping.
  final Change? preserved,
}) extends MergeDecision;

/// Decides between [incoming] and the [current] winner of its field.
///
/// The change with the higher HLC wins, and the change id breaks an exact
/// tie, so every device reaches the same answer in any order. Seeing the
/// same change twice keeps the current winner, so applying is idempotent.
///
/// An incoming change that loses was made without seeing the winner,
/// because a device's clock moves past every change it receives. So when
/// it comes from another device, sets a different value, and its field is
/// in [MergePolicy.longTextFields], it is returned as
/// [CurrentWins.preserved]. The rule errs on the side of keeping text:
/// it can also keep an edit that a third device had already seen.
MergeDecision resolve({
  required Change? current,
  required Change incoming,
  MergePolicy policy = const MergePolicy(),
}) {
  if (current == null || _beats(incoming, current)) return const IncomingWins();
  final isLostEdit =
      incoming.id != current.id &&
      incoming.deviceId != current.deviceId &&
      policy.keepsLosingValue(incoming) &&
      !_valueEquality.equals(incoming.value, current.value);
  return CurrentWins(preserved: isLostEdit ? incoming : null);
}

/// The result of [mergeAll].
typedef MergeBatch = ({
  /// The winning change for every field after the merge.
  Map<FieldKey, Change> winners,

  /// The incoming changes that won, in the order they were merged.
  List<Change> applied,

  /// Losing long-text edits to keep in history (see [resolve]).
  List<Change> preserved,
});

/// Merges [incoming] into [winners], one change at a time with [resolve].
///
/// Pure: [winners] is not modified. The resulting winners are the same in
/// whatever order the changes arrive, which is what makes replicas
/// converge.
MergeBatch mergeAll(
  Map<FieldKey, Change> winners,
  Iterable<Change> incoming, {
  MergePolicy policy = const MergePolicy(),
}) {
  final merged = Map.of(winners);
  final applied = <Change>[];
  final preserved = <Change>[];
  for (final change in incoming) {
    switch (resolve(
      current: merged[change.key],
      incoming: change,
      policy: policy,
    )) {
      case IncomingWins():
        merged[change.key] = change;
        applied.add(change);
      case CurrentWins(preserved: final kept?):
        preserved.add(kept);
      case CurrentWins():
        break;
    }
  }
  return (winners: merged, applied: applied, preserved: preserved);
}

/// Reading entity state out of a map of winning changes.
extension FieldWinners on Map<FieldKey, Change> {
  /// Whether the entity's latest [Change.deletedField] change deletes it.
  bool isDeleted({required String entity, required String entityId}) =>
      this[(entity: entity, entityId: entityId, field: Change.deletedField)]
          ?.isTombstone ??
      false;
}

const _valueEquality = DeepCollectionEquality();

bool _beats(Change challenger, Change holder) {
  final byClock = challenger.hlc.compareTo(holder.hlc);
  return byClock > 0 ||
      (byClock == 0 && challenger.id.compareTo(holder.id) > 0);
}
