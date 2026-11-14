import 'dart:io';

import 'package:usda_builder/usda_builder.dart';

/// Builds the bundled USDA SQLite file. See the README for how to run it.
Future<void> main(List<String> arguments) async {
  exitCode = await runUsdaBuilder(arguments, out: stdout, err: stderr);
}
