import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sousvite/app/services/error_reporter.dart';

class _MockHub() extends Mock implements Hub;

void main() {
  group(SentryErrorReporter, () {
    late _MockHub hub;

    setUp(() {
      hub = _MockHub();
      when(
        () => hub.captureException(
          any<Object?>(),
          stackTrace: any<Object?>(named: 'stackTrace'),
        ),
      ).thenAnswer((_) async => const SentryId.empty());
    });

    test('sends the error to Sentry as unhandled', () async {
      final error = StateError('boom');
      final stackTrace = StackTrace.current;

      await SentryErrorReporter(hub).report(error, stackTrace);

      final captured = verify(
        () => hub.captureException(
          captureAny<Object?>(),
          stackTrace: captureAny<Object?>(named: 'stackTrace'),
        ),
      ).captured;
      final throwable = captured.first as ThrowableMechanism;
      expect(throwable.throwable, same(error));
      expect(throwable.mechanism.handled, isFalse);
      expect(captured.last, same(stackTrace));
    });
  });

  group('errorReporterProvider', () {
    test('prints to the console when no DSN is set', () {
      final container = ProviderContainer.test(
        overrides: [sentryDsnProvider.overrideWithValue('')],
      );

      expect(container.read(errorReporterProvider), isA<DebugErrorReporter>());
    });

    test('uses Sentry when a DSN is set', () {
      final container = ProviderContainer.test(
        overrides: [
          sentryDsnProvider.overrideWithValue('https://key@sentry.invalid/1'),
        ],
      );

      expect(container.read(errorReporterProvider), isA<SentryErrorReporter>());
    });

    test('reads no DSN in tests', () {
      expect(ProviderContainer.test().read(sentryDsnProvider), isEmpty);
    });
  });

  group('initErrorReporting', () {
    test('leaves Sentry off without a DSN', () async {
      await initErrorReporting('');

      expect(Sentry.isEnabled, isFalse);
    });
  });
}
