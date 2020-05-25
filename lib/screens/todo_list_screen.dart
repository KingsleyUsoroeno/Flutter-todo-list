import 'package:flutter/material.dart';
import 'package:fluttertodolist/db/task_database.dart';
import 'package:fluttertodolist/helpers/db_bloc.dart';
import 'package:fluttertodolist/screens/add_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatelessWidget {
  final _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
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
              future: provider.getAllTask(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'You Have no task yet',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  final int completedTaskCount = snapshot.data
                      .where((Task task) => task.completed == true)
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
                        return _buildTask(context, snapshot.data[index - 1]);
                      });
                }
              }),
        );
      },
    );
  }

  Widget _buildTask(BuildContext context, Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              task.name,
              style: TextStyle(
                  fontSize: 18.0,
                  decoration: task.completed == false
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${_dateFormat.format(task.dueDate)} + ${task.priority}',
              style: TextStyle(
                  fontSize: 15.0,
                  decoration: task.completed == false
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (bool val) {
                task.completed = val;
                Provider.of<DatabaseProvider>(context, listen: false).updateTask(task.copyWith(completed: val));
                debugPrint('Check box value is $val');
              },
              activeColor: Theme.of(context).primaryColor,
              value: task.completed,
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
