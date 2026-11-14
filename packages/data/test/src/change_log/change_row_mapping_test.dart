import 'package:data/data.dart';
import 'package:sync/sync.dart';
import 'package:test/test.dart';

void main() {
  test('a change round-trips through a change log row', () {
    const change = Change(
      id: 'c1',
      entity: 'ingredient_line',
      entityId: 'l1',
      field: 'quantity',
      value: {'n': 3, 'd': 2},
      hlc: Hlc(1731600000000, 4, 'phone'),
      deviceId: 'phone',
      spaceId: 'private',
    );
    final companion = change.toCompanion();
    final row = ChangeRow(
      id: companion.id.value,
      entity: companion.entity.value,
      entityId: companion.entityId.value,
      field: companion.field.value,
      value: companion.value.value,
      hlc: companion.hlc.value,
      deviceId: companion.deviceId.value,
      spaceId: companion.spaceId.value,
    );

    expect(row.value, '{"n":3,"d":2}');
    expect(row.hlc, change.hlc.pack());
    expect(row.toChange(), change);
  });
}
