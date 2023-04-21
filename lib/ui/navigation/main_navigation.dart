import 'package:flutter/material.dart';
import 'package:flutter_todo/ui/widgets/group_form/group_form_widget.dart';
import 'package:flutter_todo/ui/widgets/groups/groups_widget.dart';
import 'package:flutter_todo/ui/widgets/task_form/task_form_widget.dart';
import 'package:flutter_todo/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/groups';
  static const groupsForm = '/groups/form';
  static const tasks = '/groups/tasks';
  static const tasksForm = '/groups/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
    MainNavigationRouteNames.groupsForm: (context) => const GroupFormWidget(),
    MainNavigationRouteNames.tasks: (context) => const TasksWidget(),
    MainNavigationRouteNames.tasksForm: (context) => const TaskFormWidget(),
  };
}
