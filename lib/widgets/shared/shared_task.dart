import 'package:flutter/material.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/screens/chat_screen.dart';

import 'package:party_planner/widgets/dialog/add_shared_dialog.dart';
import 'package:party_planner/widgets/task/task_add_list.dart';
import 'package:party_planner/widgets/task/task_list_tile.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class SharedTask extends StatefulWidget {
  static const routeName = '/shared-task';

  @override
  _SharedTaskState createState() => _SharedTaskState();
}

class _SharedTaskState extends State<SharedTask> {
  bool isLoading = false;
  Shared _shared;
  User authUser;

  void _showEditCategorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBackgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => AddShared(isEdit: true, shared: _shared),
    ).then((_) => didChangeDependencies());
  }

  Future<void> _deleteTask(Task task) async {
    await context.read<ModelProvider>().deleteTask(task.id);
  }

  @override
  void didChangeDependencies() async {
    Shared sharedArg = ModalRoute.of(context).settings.arguments;
    authUser = context.read<ModelProvider>().getCurrentUser;
    setState(() {
      isLoading = true;
    });

    _shared = await context.read<ModelProvider>().fetchSharedById(sharedArg.id);
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 40,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kWhiteColor),
        actions: isLoading
            ? null
            : [
                IconButton(
                  icon: Icon(
                    Icons.chat_rounded,
                    color: kWhiteColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: _shared,
                    );
                  },
                ),
                if (_shared.admin == authUser.id)
                  IconButton(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: kWhiteColor,
                    ),
                    onPressed: _showEditCategorySheet,
                  ),
              ],
      ),
      backgroundColor: kBackgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    _shared.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(_shared.color),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  StreamBuilder(
                    stream: context
                        .read<ModelProvider>()
                        .streamWhereTaskShared(_shared.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      var tasks = snapshot.data.docs.map((task) {
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
                        return Task.fromMap(map, task.id, null, _shared);
                      }).toList();

                      return Column(
                        children: [
                          ...List.generate(
                            tasks.length,
                            (index) => TaskListTile(
                              task: tasks[index],
                              isShared: true,
                              deleteTask: _deleteTask,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  TaskAddList(
                    isShared: true,
                    shared: _shared,
                  ),
                  Divider(
                    color: kWhiteColor,
                    height: 0,
                    thickness: 0.2,
                  ),
                ],
              ),
            ),
    );
  }
}
