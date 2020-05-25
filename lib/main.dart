import 'package:flutter/material.dart';
import 'package:fluttertodolist/helpers/db_bloc.dart';
import 'package:fluttertodolist/screens/todo_list_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DatabaseProvider(),
      child: MaterialApp(
        title: 'Flutter Todo List',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: TodoListScreen(),
      ),
    );
  }
}
