import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/data_provider/box_manager.dart';
import 'package:flutter_todo/domain/entity/task.dart';
import 'package:flutter_todo/ui/navigation/main_navigation.dart';
import 'package:flutter_todo/ui/widgets/tasks/tasks_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TasksWidgetModel extends ChangeNotifier {
  TasksWidgetConfig config;
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.config}) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.tasksForm,
      arguments: config.groupKey,
    );
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> toggleDone(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(config.groupKey);
    await _readTasksFromHive();
    (await _box).listenable().addListener(_readTasksFromHive);
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(
          child: child,
          notifier: model,
        );

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
