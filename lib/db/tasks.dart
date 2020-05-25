import 'package:moor_flutter/moor_flutter.dart';

//@DataClassName("") how to give your table a different name
class Tasks extends Table {
  // autoincrement sets these to be the primary key
  IntColumn get id => integer().autoIncrement()();

  // text|| String Columns
  TextColumn get name => text().withLength(min: 1, max: 50)();

  TextColumn get priority => text().withLength(min: 1, max: 50)();

  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get completed => boolean().withDefault(Constant(false))();
  
//  @override
//  Set<Column> get primaryKey => {name, priority}; How to tell Moor to use these fields as
// our primary key rather than the autoIncremented Id field
}
