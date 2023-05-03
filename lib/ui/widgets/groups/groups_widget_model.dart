import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/library/hive/box_manager.dart';
import 'package:flutter_todo/ui/navigation/main_navigation.dart';
import 'package:flutter_todo/ui/widgets/tasks/tasks_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_todo/domain/entity/group.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  void showTasks(BuildContext context, int groupIndex) async {
    final groupKey = (await _box).keyAt(groupIndex) as int;

    unawaited(
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: groupKey,
      ),
    );
  }

  void deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = box.keyAt(groupIndex) as int;
    await Hive.deleteBoxFromDisk(BoxManager.instance.makeTaskBoxName(groupKey));
    await box.delete(groupKey);
  }

  void _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  @override
  void dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
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
