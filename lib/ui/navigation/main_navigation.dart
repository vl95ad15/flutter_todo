import 'package:flutter/material.dart';
import 'package:flutter_todo/ui/widgets/group_form/group_form_widget.dart';
import 'package:flutter_todo/ui/widgets/groups/groups_widget.dart';
import 'package:flutter_todo/ui/widgets/task_form/task_form_widget.dart';
import 'package:flutter_todo/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/';
  static const groupsForm = '/groupsForm';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
    MainNavigationRouteNames.groupsForm: (context) => const GroupFormWidget(),
  };

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => TasksWidget(groupKey: groupKey),
        );
      case MainNavigationRouteNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => TaskFormWidget(groupKey: groupKey),
        );
      default:
        const widget = Text('Navigation Error');
        return MaterialPageRoute(
          builder: (context) => widget,
        );
    }
  }
}
