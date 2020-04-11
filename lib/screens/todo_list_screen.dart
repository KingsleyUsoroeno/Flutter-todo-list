import 'package:flutter/material.dart';
import 'package:fluttertodolist/helpers/database_helper.dart';
import 'package:fluttertodolist/models/task_model.dart';
import 'package:fluttertodolist/screens/add_task_screen.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>> _taskList;
  List<Task> task = [];
  final db = DatabaseHelper.instance;
  int _completedTask;
  int _completed;
  final _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
    getCompletedTask();
  }

  void _updateTaskList() async {
    setState(() {
      _taskList = DatabaseHelper.instance.tasks();
    });
  }

  void getCompletedTask() async {
    task = await db.tasks();
    debugPrint("$task");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddTaskScreen()));
        },
      ),
      body: FutureBuilder(
          future: db.getTaskList(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'You Have no task yet',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              final int completedTaskCount = snapshot.data
                  .where((Task task) => task.status == 1)
                  .toList()
                  .length;

              return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 60.0),
                  itemCount: 1 + snapshot.data.length,
                  itemBuilder: (context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'My Task',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              '$completedTaskCount of ${snapshot.data.length}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0),
                            )
                          ],
                        ),
                      );
                    }
                    return _buildTask(snapshot.data[index - 1]);
                  });
            }
          }),
    );
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                  fontSize: 18.0,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${_dateFormat.format(task.date)} + ${task.priority}',
              style: TextStyle(
                  fontSize: 15.0,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (bool val) {
                task.status = val ? 1 : 0;
                db.updateTask(task);
                _updateTaskList();
                debugPrint('Check box value is $val');
              },
              activeColor: Theme.of(context).primaryColor,
              value: task.status == 1 ? true : false,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)));
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
