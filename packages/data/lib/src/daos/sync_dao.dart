import 'package:data/src/app_database.dart';
import 'package:data/src/tables/sync_tables.dart';
import 'package:drift/drift.dart';

part 'sync_dao.g.dart';

/// Queries for the change log and sync state.
@DriftAccessor(tables: [ChangeLog, SyncState])
class SyncDao(super.attachedDatabase)
    extends DatabaseAccessor<AppDatabase>
    with _$SyncDaoMixin {
  /// Appends [rows] to the change log. A row whose id is already there is
  /// skipped, so recording the same change twice is harmless.
  Future<void> insertChanges(List<ChangeLogCompanion> rows) =>
      batch((batch) => batch.insertAll(changeLog, rows, mode: .insertOrIgnore));

  /// Changes with an HLC after [afterHlc] (all of them when null), oldest
  /// first. Packed HLCs sort as text in time order.
  Future<List<ChangeRow>> changesAfter(String? afterHlc) {
    final query = select(changeLog)
      ..orderBy([(row) => OrderingTerm.asc(row.hlc)]);
    if (afterHlc != null) {
      query.where((row) => row.hlc.isBiggerThanValue(afterHlc));
    }
    return query.get();
  }

  /// The change with the highest HLC for one field of one entity: the
  /// field's current winner. Null when the field has no changes.
  Future<ChangeRow?> latestForField({
    required String entity,
    required String entityId,
    required String field,
  }) =>
      (select(changeLog)
            ..where(
              (row) =>
                  row.entity.equals(entity) &
                  row.entityId.equals(entityId) &
                  row.field.equals(field),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.hlc)])
            ..limit(1))
          .getSingleOrNull();

  /// The highest HLC in the change log, or null when it is empty. Used to
  /// start the clock where it left off after the app restarts.
  Future<String?> latestHlc() {
    final latest = changeLog.hlc.max();
    return (selectOnly(
      changeLog,
    )..addColumns([latest])).map((row) => row.read(latest)).getSingle();
  }
}
