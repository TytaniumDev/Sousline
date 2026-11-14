import 'package:domain/src/value_objects/quantity.dart';
import 'package:domain/src/value_objects/unit.dart';
import 'package:meta/meta.dart';

/// A [Quantity] together with its [Unit], such as ⅓ cup.
///
/// Entities store the two as separate fields; this pairs them for the
/// math that needs both: scaling, conversion, and rounding.
@immutable
final class const Amount(
  /// How much.
  final Quantity quantity,

  /// What [quantity] counts. Null for a bare count, such as "2 onions".
  final Unit? unit,
) {
  /// This amount multiplied by [factor]. Exact, so ⅓ cup × 3 is 1 cup.
  Amount scaled(Quantity factor) => Amount(quantity * factor, unit);

  @override
  bool operator ==(Object other) =>
      other is Amount && other.quantity == quantity && other.unit == unit;

  @override
  int get hashCode => Object.hash(quantity, unit);

  /// A debug form such as `1/3 cup`. User-facing text is formatted by
  /// `packages/measuring`.
  @override
  String toString() => unit == null ? '$quantity' : '$quantity ${unit!.name}';
}
