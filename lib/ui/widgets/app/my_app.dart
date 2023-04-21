import 'package:flutter/material.dart';
import 'package:flutter_todo/ui/widgets/group_form/group_form_widget.dart';
import 'package:flutter_todo/ui/widgets/groups/groups_widget.dart';
import 'package:flutter_todo/ui/widgets/task_form/task_form_widget.dart';
import 'package:flutter_todo/ui/widgets/tasks/tasks_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDO',
      routes: {
        '/groups': (context) => const GroupsWidget(),
        '/groups/form': (context) => const GroupFormWidget(),
        '/groups/tasks': (context) => const TasksWidget(),
        '/groups/tasks/form': (context) => const TaskFormWidget(),
      },
      initialRoute: '/groups',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
