import 'package:data/src/app_database.dart';
import 'package:data/src/change_log/change_row_mapping.dart';
import 'package:data/src/change_log/change_set.dart';
import 'package:sync/sync.dart';

/// Writes change log rows in the same transaction as every local write
/// (ENGINEERING.md §8.1). Every repository writes through [write].
///
/// ```dart
/// await recorder.write((changes) async {
///   await database.into(database.recipes).insertOnConflictUpdate(row);
///   changes.set('recipe', id, {'title': title});
/// });
/// ```
final class ChangeRecorder(
  /// The database the writes and the change log live in.
  final AppDatabase database, {

  /// This device's clock. Its node id is the device id on every change.
  required final HybridLogicalClock clock,

  /// The space changes belong to unless a write says otherwise: the
  /// user's own library.
  required final String spaceId,

  /// Makes a unique id for each change.
  required final String Function() newId,
}) {
  /// Moves [clock] past every change already in [database], so timestamps
  /// keep increasing after the app restarts, even if the wall clock went
  /// backwards. Call once before the first write.
  Future<void> resumeClock() async {
    final latest = await database.syncDao.latestHlc();
    if (latest != null) clock.receive(Hlc.parse(latest));
  }

  /// Runs [action] in a transaction and stores the changes it records in
  /// the same transaction. If [action] throws, neither the write nor its
  /// changes are kept. Returns what [action] returns.
  Future<T> write<T>(Future<T> Function(ChangeSet changes) action) =>
      database.transaction(() async {
        final changes = ChangeSet();
        final result = await action(changes);
        final stamped = [
          for (final pending in changes.pending) _stamp(pending),
        ];
        await database.syncDao.insertChanges([
          for (final change in stamped) change.toCompanion(),
        ]);
        return result;
      });

  Change _stamp(PendingChange pending) => Change(
    id: newId(),
    entity: pending.entity,
    entityId: pending.entityId,
    field: pending.field,
    value: pending.value,
    hlc: clock.tick(),
    deviceId: clock.nodeId,
    spaceId: pending.spaceId ?? spaceId,
  );
}
