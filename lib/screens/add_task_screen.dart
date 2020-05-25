import 'package:flutter/material.dart';
import 'package:fluttertodolist/db/task_database.dart';
import 'package:fluttertodolist/helpers/db_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;

  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '', priority = 'Low';
  DateTime _date = DateTime.now();
  final _dateFormat = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Meduim', 'High'];
  TextEditingController _dateController = TextEditingController();

  void _handleDatePicker() async {
    final DateTime date = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormat.format(_date);
    }
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      debugPrint('Title is $_title priority is $priority and date is $_date');
      final task = Task(name: _title, priority: priority, dueDate: _date);
      if (widget.task == null) {
        Provider.of<DatabaseProvider>(context, listen: false).addTask(task);
      } else {
        // update task
        final taskToUpdate = Task(id: widget.task.id, name: _title, priority: priority, dueDate: _date, completed: widget.task.completed);
        Provider.of<DatabaseProvider>(context, listen: false).updateTask(taskToUpdate);
      }

      // Insert the task to our Users Database
      // Update their task
      Navigator.pop(context);
    }
  }

  void _deleteTask() {
    Provider.of<DatabaseProvider>(context, listen: false).deleteTask(widget.task);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // we want to update a task
      _title = widget.task.name;
      _date = widget.task.dueDate;
      priority = widget.task.priority;
    }
    _dateController.text = _dateFormat.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_ios, size: 30.0, color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 20.0),
                Text(
                  widget.task != null ? 'Update Task' : 'Add Task',
                  style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input.trim().isEmpty ? 'Please enter a task title' : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            onTap: _handleDatePicker,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          items: _priorities.map((String priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                              ),
                            );
                          }).toList(),
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconEnabledColor: Theme.of(context).primaryColor,
                          iconSize: 22.0,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: 'priority',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input.trim().isEmpty ? 'Please select a priority level' : null,
                          onChanged: (value) {
                            setState(() {
                              priority = value;
                            });
                          },
                          value: priority,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: FlatButton(
                    child: Text(
                      widget.task != null ? 'Update' : 'Add',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: _submit,
                  ),
                ),
                widget.task != null
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: FlatButton(
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: _deleteTask,
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
