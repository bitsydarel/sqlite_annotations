import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:meta/meta.dart';
import 'package:sqlite_annotations/sqlite_annotations.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sqlite_generator/src/sqlite_column_element.dart';
import 'package:sqlite_generator/src/sqlite_table_element.dart';

/// SQLite code generator for each class annotated with [SQLiteTable]
class SQLiteGenerator extends GeneratorForAnnotation<SQLiteTable> {
  @literal
  const SQLiteGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    log.info("Received: ${element.toString()}");

    if (element is ClassElement) {
      if (SQLiteColumnElement.containsInvalidSqliteColumns(element.fields)) {
        final containsInvalidColumn = AssertionError(
          "${element.toString()} contains invalid column",
        );

        log.severe(
          containsInvalidColumn.message,
          containsInvalidColumn,
          StackTrace.current,
        );
      } else {
        final SQLiteTableElement sqliteTable = SQLiteTableElement(
          element,
          annotation,
          <Error>[],
        );

        final String generatedClass = sqliteTable.toClass();

        return sqliteTable.hasError() ? null : generatedClass;
      }
    }
    return null;
  }
}
