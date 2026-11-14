import 'dart:io';

import 'package:args/args.dart';
import 'package:usda_builder/src/build_usda_dataset.dart';
import 'package:usda_builder/src/fdc/fdc_release.dart';
import 'package:usda_builder/src/sqlite/usda_writer.dart';

/// Exit code for a wrong command line (sysexits `EX_USAGE`).
const usageExitCode = 64;

/// Exit code when the releases can't be read or built.
const failureExitCode = 1;

const _requiredOptions = ['foundation', 'sr-legacy', 'output'];

final _parser = ArgParser()
  ..addOption(
    'foundation',
    help: 'Unzipped Foundation Foods CSV release folder.',
    valueHelp: 'folder',
  )
  ..addOption(
    'sr-legacy',
    help: 'Unzipped SR Legacy CSV release folder.',
    valueHelp: 'folder',
  )
  ..addOption(
    'output',
    help: 'Where to write the SQLite file.',
    valueHelp: 'file',
  )
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.');

/// Runs the `usda_builder` command with [arguments], writing progress to
/// [out] and problems to [err]. Returns the process exit code.
Future<int> runUsdaBuilder(
  List<String> arguments, {
  required StringSink out,
  required StringSink err,
}) async {
  final ArgResults options;
  try {
    options = _parser.parse(arguments);
  } on ArgParserException catch (error) {
    return _usageError(error.message, err);
  }
  if (options.flag('help')) {
    out.writeln(_usage);
    return 0;
  }
  final missing = _requiredOptions.where((name) => !options.wasParsed(name));
  if (missing.isNotEmpty) {
    return _usageError('Missing --${missing.join(', --')}.', err);
  }

  try {
    final dataset = await buildUsdaDataset(
      foundation: FdcRelease.locate(Directory(options.option('foundation')!)),
      srLegacy: FdcRelease.locate(Directory(options.option('sr-legacy')!)),
    );
    final output = File(options.option('output')!);
    writeUsdaDatabase(dataset, output);
    final portions = dataset.foods.fold(0, (n, f) => n + f.portions.length);
    out.writeln(
      'Wrote ${dataset.foods.length} foods, $portions portions, and '
      '${dataset.nutrients.length} nutrients to ${output.path} '
      '(${(output.lengthSync() / 1e6).toStringAsFixed(1)} MB).',
    );
    return 0;
  } on Exception catch (error) {
    err.writeln(error);
    return failureExitCode;
  }
}

int _usageError(String message, StringSink err) {
  err
    ..writeln(message)
    ..writeln()
    ..writeln(_usage);
  return usageExitCode;
}

String get _usage =>
    'Builds the bundled USDA SQLite file from FoodData Central CSV '
    'releases.\n\n'
    'Usage: dart run usda_builder --foundation <folder> '
    '--sr-legacy <folder> --output <file>\n\n'
    '${_parser.usage}';
