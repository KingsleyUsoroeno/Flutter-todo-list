import 'package:fluttertodolist/db/task_database.dart';
import 'package:fluttertodolist/db/tasks.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'task_dao.g.dart';

@UseDao(tables: [Tasks])
class TaskDao extends DatabaseAccessor<TaskDatabase> with _$TaskDaoMixin {
  final TaskDatabase taskDatabase;

  TaskDao(this.taskDatabase) : super(taskDatabase);

  Future<List<Task>> getAllTask() => select(tasks).get();

  Stream<List<Task>> observeAllTask() => select(tasks).watch();

  Stream<List<Task>> observeTaskByDueDate() {
    // Wrap the whole select statement in parenthesis
    return (select(tasks)
          // Statements like orderBy and where return void => the need to use a cascading ".." operator
          ..orderBy(
            ([
              // Primary sorting by due date
              (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
            ]),
          ))
        // watch the whole select statement
        .watch();
  }

  Stream<List<Task>> watchCompletedTasks() {
    return (select(tasks)..where((t) => t.completed.equals(true))).watch();
  }

  Future<int> getCompletedTaskLength() {
    return (select(tasks)..where((t) => t.completed.equals(true))).watch().length;
  }

  Future insertTask(Task task) => into(tasks).insert(task);

  Future updateTask(Task task) => update(tasks).replace(task);

  Future deleteTask(Task task) => delete(tasks).delete(task);
}
