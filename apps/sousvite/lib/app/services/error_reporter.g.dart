// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_reporter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Sentry DSN, from `--dart-define=SENTRY_DSN=...` (BUILD_PLAN.md §8.8).
/// Empty turns Sentry off.

@ProviderFor(sentryDsn)
final sentryDsnProvider = SentryDsnProvider._();

/// The Sentry DSN, from `--dart-define=SENTRY_DSN=...` (BUILD_PLAN.md §8.8).
/// Empty turns Sentry off.

final class SentryDsnProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The Sentry DSN, from `--dart-define=SENTRY_DSN=...` (BUILD_PLAN.md §8.8).
  /// Empty turns Sentry off.
  SentryDsnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sentryDsnProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sentryDsnHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return sentryDsn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$sentryDsnHash() => r'39d9f93ba0fb53a40bfc9d439fe9a6bf3775c5ba';

@ProviderFor(errorReporter)
final errorReporterProvider = ErrorReporterProvider._();

final class ErrorReporterProvider
    extends $FunctionalProvider<ErrorReporter, ErrorReporter, ErrorReporter>
    with $Provider<ErrorReporter> {
  ErrorReporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorReporterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorReporterHash();

  @$internal
  @override
  $ProviderElement<ErrorReporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ErrorReporter create(Ref ref) {
    return errorReporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ErrorReporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ErrorReporter>(value),
    );
  }
}

String _$errorReporterHash() => r'0ff3db3e50bbf8a2101439f24c9943ff600132bf';
