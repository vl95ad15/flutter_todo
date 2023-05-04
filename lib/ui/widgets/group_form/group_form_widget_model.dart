import 'package:flutter/material.dart';
import 'package:flutter_todo/library/hive/box_manager.dart';
import 'package:flutter_todo/domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var groupName = '';
  String? errorText;

  void saveGroup(BuildContext context) async {
    final groupName = this.groupName.trim();
    if (groupName.isEmpty) {
      errorText = 'Enter group name';
      notifyListeners();
      return;
    }

    final group = Group(name: groupName);
    final box = await BoxManager.instance.openGroupBox();
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;
  const GroupFormWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(notifier: model, child: child);

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return false;
  }
}
