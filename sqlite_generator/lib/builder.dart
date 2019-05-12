library builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sqlite_generator/src/sqlite_generator.dart';

Builder sqliteGenerator(final BuilderOptions options) {
  return SharedPartBuilder(
    const [
      const SQLiteGenerator()
    ],
    "sqlite_generator"
  );
}