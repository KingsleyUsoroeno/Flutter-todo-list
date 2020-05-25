import 'package:flutter/foundation.dart';
import 'package:fluttertodolist/db/task_database.dart';

class DatabaseProvider with ChangeNotifier {
  final taskDao = TaskDatabase().taskDao;

  addTask(Task task) {
    taskDao.insertTask(task);
    notifyListeners();
  }

  Future<List<Task>> getAllTask() async {
    return taskDao.getAllTask();
  }

  Future<int> getTotalCompletedTask() {
    return taskDao.getCompletedTaskLength();
  }

  Stream<List<Task>> observeTaskByDueDate() {
    return taskDao.observeTaskByDueDate();
  }

  Stream<List<Task>> observeAllTask() {
    return taskDao.observeAllTask();
  }

  updateTask(Task task) {
    taskDao.updateTask(task);
    notifyListeners();
  }

  deleteTask(Task task) {
    taskDao.deleteTask(task);
    notifyListeners();
  }
}
