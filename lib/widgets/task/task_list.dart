import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/theme.dart';
import 'package:party_planner/widgets/task/task_add_list.dart';
import 'package:party_planner/widgets/task/task_list_tile.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  final Category category;
  final Shared shared;
  final bool isShared;
  final void Function(Task task) deleteTask;

  const TaskList({
    Key key,
    this.category,
    this.deleteTask,
    this.shared,
    this.isShared,
  }) : super(key: key);
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void _deleteTask(Task task) {
    widget.deleteTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 40, top: 32),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isShared ? widget.shared.title : widget.category.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(widget.isShared
                      ? widget.shared.color
                      : widget.category.color),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              StreamBuilder(
                stream: widget.isShared
                    ? context
                        .read<ModelProvider>()
                        .streamWhereTaskShared(widget.shared.id)
                    : context
                        .read<ModelProvider>()
                        .streamWhereTask(widget.category.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  var tasks = snapshot.data.docs.map((task) {
                    Category category;
                    Shared shared;
                    if (widget.isShared) {
                      shared = context
                          .read<ModelProvider>()
                          .getSharedById(widget.shared.id);
                      category = null;
                    } else {
                      category = context
                          .read<ModelProvider>()
                          .getCategoryById(widget.category.id);
                      shared = null;
                    }

                    var map = {
                      'task_name': task.data()['task_name'],
                      'description': task.data()['description'],
                      'deadlineDateTime':
                          task.data()['deadlineDateTime'] == null
                              ? null
                              : task.data()['deadlineDateTime'].toDate(),
                      'priority': task.data()['priority'],
                      'onlyDate': task.data()['onlyDate'],
                      'onlyTime': task.data()['onlyTime'],
                      'useDateTime': task.data()['useDateTime'],
                      'isDone': task.data()['isDone'],
                    };
                    return Task.fromMap(map, task.id, category, shared);
                  }).toList();

                  return Column(
                    children: [
                      ...List.generate(
                        tasks.length,
                        (index) => TaskListTile(
                          task: tasks[index],
                          deleteTask: _deleteTask,
                          isShared: widget.isShared ? true : false,
                        ),
                      ),
                    ],
                  );
                },
              ),
              TaskAddList(
                category: widget.isShared ? null : widget.category,
                shared: widget.shared,
                isShared: widget.isShared ? true : false,
              ),
              Divider(
                color: kWhiteColor,
                height: 0,
                thickness: 0.2,
              ),
            ],
          ),
        ),
        Divider(
          color: kWhiteColor,
          height: 0,
        ),
      ],
    );
  }
}
