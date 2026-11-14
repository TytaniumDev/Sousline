import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('servingsMultiplier', () {
    test('is the exact ratio of servings', () {
      expect(
        servingsMultiplier(from: Quantity(4), to: Quantity(6)),
        Quantity(3, 2),
      );
    });

    test('throws when the recipe has zero servings', () {
      expect(
        () => servingsMultiplier(from: Quantity.zero, to: Quantity(2)),
        throwsArgumentError,
      );
    });
  });
}
