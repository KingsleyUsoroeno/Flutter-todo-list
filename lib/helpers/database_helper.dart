import 'dart:io';

import 'package:fluttertodolist/models/task_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database _db;

  DatabaseHelper._instance();

  String _taskTable = 'task_table';
  String _columnId = 'id';
  String _columnTitle = 'title';
  String _columnDate = 'date';
  String _columnPriority = 'priority';
  String _columnStatus = 'status';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    String sqlQuery =
        "CREATE TABLE $_taskTable($_columnId INTEGER PRIMARY KEY AUTOINCREMENT, $_columnTitle TEXT NOT NULL, $_columnDate TEXT, $_columnPriority TEXT, $_columnStatus INTEGER)";
    await db.execute(sqlQuery);
  }

  Future<void> insertTask(Task task) async {
    // Get a reference to the database.
    final Database db = await this.db;
    await db.insert(_taskTable, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> tasks() async {
    // Get a reference to the database.
    final Database db = await this.db;

    // Query the table for all The Task.
    final List<Map<String, dynamic>> maps = await db.query(_taskTable);

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(maps.length, (i) {
      return Task.withId(
          id: maps[i]['id'],
          title: maps[i]['title'],
          date: DateTime.parse(maps[i]['date']),
          priority: maps[i]['priority'],
          status: maps[i]['status']);
    });
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(_taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<int> updateTask(Task task) async {
    // Get a reference to the database.
    final db = await this.db;

    // Update the given Tak.
    return await db.update(
      _taskTable,
      task.toMap(),
      // Ensure that the Task has a matching id.
      where: "id = ?",
      // Pass the Task's id as a whereArg to prevent SQL injection.
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    // Get a reference to the database.
    final db = await this.db;

    // Remove the Task from the Database.
    await db.delete(
      _taskTable,
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<int> getCompletedTask() async {
    // Get a reference to the database.
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query(_taskTable,
        where: "status = ?", whereArgs: [1]); // 1 being completed
    return List.generate(maps.length, (i) {
      return Task.withId(
          id: maps[i]['id'],
          title: maps[i]['title'],
          date: maps[i]['date'],
          priority: maps[i]['priority'],
          status: maps[i]['status']);
    }).length;
  }
}
