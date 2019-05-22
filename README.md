A SQLite code generator.

## Usage

A simple usage example:

```dart
import 'package:db_sqlite/db_sqlite.dart';

@SQLiteTable
class SomeTable {
  @SQLiteColumn(ColumnType.TEXT)
  String someColumn;
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
