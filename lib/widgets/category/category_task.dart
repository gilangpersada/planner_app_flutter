import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/widgets/dialog/add_category_dialog.dart';
import 'package:party_planner/widgets/task/task_add_list.dart';
import 'package:party_planner/widgets/task/task_list_tile.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';

class CategoryTask extends StatefulWidget {
  static const routeName = '/category-task';

  @override
  _CategoryTaskState createState() => _CategoryTaskState();
}

class _CategoryTaskState extends State<CategoryTask> {
  Category _category;
  bool isLoading = false;

  void _showEditCategorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => AddCategory(
        isEdit: true,
        category: _category,
      ),
    ).then((_) => didChangeDependencies());
  }

  Future<void> _deleteTask(Task task) async {
    await context.read<ModelProvider>().deleteTask(task.id);
  }

  @override
  void didChangeDependencies() async {
    Category categoryArg = ModalRoute.of(context).settings.arguments;
    setState(() {
      isLoading = true;
    });
    _category =
        await context.read<ModelProvider>().fetchCategoryById(categoryArg.id);
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
        actions: [
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
                    _category.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(_category.color),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  StreamBuilder(
                    stream: context
                        .read<ModelProvider>()
                        .streamWhereTask(_category.id),
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
                        return Task.fromMap(map, task.id, _category, null);
                      }).toList();

                      return Column(
                        children: [
                          ...List.generate(
                            tasks.length,
                            (index) => TaskListTile(
                              task: tasks[index],
                              isShared: false,
                              deleteTask: _deleteTask,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  TaskAddList(
                    category: _category,
                    isShared: false,
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
