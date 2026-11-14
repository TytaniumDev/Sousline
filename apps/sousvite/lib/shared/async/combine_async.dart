import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Combines two [AsyncValue]s synchronously: data once both have data, the
/// first error if either fails, and loading otherwise.
///
/// Unlike awaiting `.future` in a `FutureProvider`, this never passes
/// through a loading state when an input changes. Combined with value
/// equality on the result, a provider built with it notifies only when the
/// combined value really changes (ENGINEERING.md §5).
AsyncValue<R> combineAsync2<A, B, R>(
  AsyncValue<A> a,
  AsyncValue<B> b,
  R Function(A a, B b) combine,
) => switch ((a, b)) {
  (AsyncError(:final error, :final stackTrace), _) ||
  (
    _,
    AsyncError(:final error, :final stackTrace),
  ) => AsyncError(error, stackTrace),
  (AsyncData(value: final a), AsyncData(value: final b)) => AsyncData(
    combine(a, b),
  ),
  _ => AsyncLoading<R>(),
};
