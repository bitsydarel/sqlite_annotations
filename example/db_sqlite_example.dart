
import 'package:sqlite_statements/sqlite_statements.dart';

part 'db_sqlite_example.g.dart';

main() {
  var table = Item(1234, "Orange", 15.5);

  print('item: ${table.name}');
}

@SQLiteTable(createToTableStatement: true)
class Item {
  @SQLiteColumn(ColumnType.INTEGER, primaryKey: true)
  final int id;

  final String name;

  @SQLiteColumn(ColumnType.REAL)
  final double price;

  Item(this.id, this.name, this.price);
}
