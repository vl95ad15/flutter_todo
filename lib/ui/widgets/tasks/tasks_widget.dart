import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo/ui/widgets/tasks/tasks_widget_model.dart';

class TasksWidgetConfig {
  final int groupKey;
  final String title;

  TasksWidgetConfig(this.groupKey, this.title);
}

class TasksWidget extends StatefulWidget {
  final TasksWidgetConfig config;
  const TasksWidget({
    super.key,
    required this.config,
  });

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody(),
    );
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.config.title ?? 'Tasks';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget();

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1);
      },
      itemCount: groupsCount,
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({
    required this.indexInList,
  });

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone
        ? const Icon(Icons.check_box_outlined, color: Colors.green)
        : const Icon(Icons.check_box_outline_blank_outlined);
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ColoredBox(
        color: Colors.white,
        child: ListTile(
          title: Text(
            task.text,
            style: style,
          ),
          trailing: icon,
          onTap: () => model.toggleDone(indexInList),
        ),
      ),
    );
  }
}
