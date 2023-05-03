import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_todo/domain/data_provider/box_manager.dart';
import 'package:flutter_todo/ui/navigation/main_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_todo/domain/entity/group.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;

  var _groups = <Group>[];
  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final groupKey = (await _box).keyAt(groupIndex) as int;
    unawaited(
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: groupKey,
      ),
    );
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    await box.getAt(groupIndex)?.tasks?.deleteAllFromHive();
    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await BoxManager.instance.openTaskBox();
    await _readGroupsFromHive();
    (await _box).listenable().addListener(_readGroupsFromHive);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(
          child: child,
          notifier: model,
        );

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
