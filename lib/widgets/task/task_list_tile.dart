import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/theme.dart';
import 'package:party_planner/widgets/task/task_detail_sheet.dart';
import 'package:provider/provider.dart';

class TaskListTile extends StatefulWidget {
  final Task task;
  final void Function(Task task) deleteTask;
  final bool isShared;

  const TaskListTile({
    Key key,
    this.task,
    this.deleteTask,
    this.isShared,
  }) : super(key: key);

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool isLoading = false;
  bool taskDone;

  void _showTaskDetailSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      backgroundColor: kBackgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (context) => TaskDetailSheet(
        task: widget.task,
        isShared: widget.isShared,
      ),
    );
  }

  Future<void> _updateDone() async {
    setState(() {
      isLoading = true;
      taskDone = !taskDone;
    });
    var data = {'isDone': taskDone};

    await context.read<ModelProvider>().updateDone(data, widget.task.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    taskDone = widget.task.isDone;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(widget.task.id),
          onDismissed: (_) {
            widget.deleteTask(widget.task);
          },
          direction: DismissDirection.endToStart,
          background: Container(
            padding: EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: kWhiteColor),
          ),
          child: ListTile(
            onTap: () {
              _showTaskDetailSheet(context);
            },
            horizontalTitleGap: 0,
            leading: GestureDetector(
              onTap: _updateDone,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: taskDone
                      ? null
                      : Border.all(
                          color: kWhiteColor,
                          width: 2,
                        ),
                  color: taskDone ? kGreyColor : null,
                ),
                child: taskDone ? Icon(Icons.check_rounded, size: 14) : null,
              ),
            ),
            title: Text(
              widget.task.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: taskDone ? kGreyColor : kWhiteColor,
              ),
            ),
            subtitle: (widget.task.description != '' ||
                    widget.task.deadlineDateTime != null)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.task.description != '')
                        SizedBox(
                          height: 4,
                        ),
                      if (widget.task.description != '')
                        Text(
                          widget.task.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: taskDone ? kGreyColor : kWhiteColor,
                          ),
                        ),
                      if (widget.task.description != '')
                        SizedBox(
                          height: 4,
                        ),
                      if (widget.task.deadlineDateTime != null)
                        Text(
                          DateTime(
                                    widget.task.deadlineDateTime.year,
                                    widget.task.deadlineDateTime.month,
                                    widget.task.deadlineDateTime.day,
                                  ) ==
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  )
                              ? widget.task.useDateTime
                                  ? 'Today ${Jiffy(widget.task.deadlineDateTime).yMMMEdjm}'
                                  : widget.task.onlyTime
                                      ? 'Today ${Jiffy(widget.task.deadlineDateTime).jm}'
                                      : 'Today'
                              : Jiffy(widget.task.deadlineDateTime).yMMMEdjm,
                          style: TextStyle(
                            fontSize: 10,
                            color: taskDone ? kGreyColor : kOrangeColor,
                          ),
                        ),
                      if (widget.task.deadlineDateTime != null)
                        SizedBox(
                          height: 4,
                        ),
                    ],
                  )
                : null,
          ),
        ),
        Divider(
          color: kWhiteColor,
          height: 0,
          thickness: 0.2,
        ),
      ],
    );
  }
}
