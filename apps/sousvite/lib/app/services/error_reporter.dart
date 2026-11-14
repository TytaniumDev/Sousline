import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'error_reporter.g.dart';

/// Reports errors that nothing else handled.
///
/// [SentryErrorReporter] when the build passes a Sentry DSN, otherwise
/// [DebugErrorReporter] (ENGINEERING.md §17).
abstract interface class ErrorReporter() {
  Future<void> report(Object error, StackTrace stackTrace);
}

/// Prints errors to the debug console. Used when no Sentry DSN is set, as in
/// local runs, tests, and CI.
class const DebugErrorReporter() implements ErrorReporter {
  @override
  Future<void> report(Object error, StackTrace stackTrace) async {
    debugPrint('Unhandled error: $error\n$stackTrace');
  }
}

/// Sends errors to Sentry, marked as unhandled so they count against the
/// crash-free rate.
class const SentryErrorReporter(
  /// Where events go. [HubAdapter] in the app; a fake in tests.
  final Hub _hub,
) implements ErrorReporter {
  @override
  Future<void> report(Object error, StackTrace stackTrace) =>
      _hub.captureException(
        ThrowableMechanism(
          Mechanism(type: 'sousvite.unhandled', handled: false),
          error,
        ),
        stackTrace: stackTrace,
      );
}

/// The Sentry DSN, from `--dart-define=SENTRY_DSN=...` (BUILD_PLAN.md §8.8).
/// Empty turns Sentry off.
@Riverpod(keepAlive: true)
String sentryDsn(Ref ref) => const String.fromEnvironment('SENTRY_DSN');

@Riverpod(keepAlive: true)
ErrorReporter errorReporter(Ref ref) => ref.watch(sentryDsnProvider).isEmpty
    ? const DebugErrorReporter()
    : SentryErrorReporter(HubAdapter());

/// Starts Sentry when [dsn] is set, and does nothing otherwise.
///
/// Reports carry no personal data (`sendDefaultPii` stays off), matching the
/// privacy policy (`web/privacy/index.html`). Debug symbols and source maps
/// are uploaded by the release pipeline.
Future<void> initErrorReporting(String dsn) async {
  if (dsn.isEmpty) return;
  await SentryFlutter.init(
    (options) => options
      ..dsn = dsn
      ..environment = kReleaseMode ? 'production' : 'development'
      ..sendDefaultPii = false,
  );
}
