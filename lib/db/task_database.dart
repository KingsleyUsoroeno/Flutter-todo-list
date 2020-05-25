import 'package:fluttertodolist/db/task_dao.dart';
import 'package:moor_flutter/moor_flutter.dart';

import './tasks.dart';

part 'task_database.g.dart';

@UseMoor(tables: [Tasks], daos: [TaskDao])
class TaskDatabase extends _$TaskDatabase {
  TaskDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: "task.db", logStatements: true));

  @override
  int get schemaVersion => 1;
}
