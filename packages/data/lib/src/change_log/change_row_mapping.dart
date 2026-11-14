import 'dart:convert';

import 'package:data/src/app_database.dart';
import 'package:sync/sync.dart';

/// Turns a stored change log row back into a [Change].
extension ChangeRowMapping on ChangeRow {
  /// The [Change] this row stores, with its JSON value decoded.
  Change toChange() => Change(
    id: id,
    entity: entity,
    entityId: entityId,
    field: field,
    value: jsonDecode(value),
    hlc: Hlc.parse(hlc),
    deviceId: deviceId,
    spaceId: spaceId,
  );
}

/// Turns a [Change] into a change log row.
extension ChangeCompanionMapping on Change {
  /// A row for the change log, with the value JSON encoded and the HLC
  /// packed so text order is time order.
  ChangeLogCompanion toCompanion() => ChangeLogCompanion.insert(
    id: id,
    entity: entity,
    entityId: entityId,
    field: field,
    value: jsonEncode(value),
    hlc: hlc.pack(),
    deviceId: deviceId,
    spaceId: spaceId,
  );
}
