import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sousvite/shared/async/combine_async.dart';

void main() {
  group('combineAsync2', () {
    int add(int a, int b) => a + b;
    final error = StateError('failed');

    test('combines two values', () {
      expect(
        combineAsync2(const AsyncData(1), const AsyncData(2), add),
        const AsyncData(3),
      );
    });

    test('is loading while either input loads', () {
      expect(
        combineAsync2(const AsyncLoading<int>(), const AsyncData(2), add),
        isA<AsyncLoading<int>>(),
      );
      expect(
        combineAsync2(const AsyncData(1), const AsyncLoading<int>(), add),
        isA<AsyncLoading<int>>(),
      );
    });

    test('fails when either input fails', () {
      expect(
        combineAsync2(
          AsyncError<int>(error, StackTrace.empty),
          const AsyncLoading<int>(),
          add,
        ).error,
        error,
      );
      expect(
        combineAsync2(
          const AsyncData(1),
          AsyncError<int>(error, StackTrace.empty),
          add,
        ).error,
        error,
      );
    });
  });
}
