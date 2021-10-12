import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/theme.dart';
import 'package:party_planner/widgets/dialog/add_category_dialog.dart';
import 'package:party_planner/widgets/dialog/add_shared_dialog.dart';
import 'package:party_planner/widgets/task/task_detail_sheet.dart';
import 'package:party_planner/widgets/task/task_list.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Category> _categories = [];
  List<Shared> _shared = [];
  bool isLoading = false;
  String authUser = FirebaseAuth.instance.currentUser.uid;

  Future<void> _fetchCategories() async {
    setState(() {
      isLoading = true;
    });
    await context.read<ModelProvider>().fetchCategory(authUser);
    await context.read<ModelProvider>().fetchShared(authUser);
    _categories = context.read<ModelProvider>().getCategories;
    _shared = context.read<ModelProvider>().getShared;
    setState(() {
      isLoading = false;
    });
  }

  void _showAddCategoryDialog() {
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
        isEdit: false,
      ),
    ).then((value) {
      _fetchCategories();
    });
  }

  void _showAddSharedDialog(BuildContext context) {
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
      builder: (context) => AddShared(
        isEdit: false,
      ),
    ).then((_) {
      _fetchCategories();
    });
  }

  Future<void> _deleteTask(Task task) async {
    await context.read<ModelProvider>().deleteTask(task.id);
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: kCardColor,
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kWhiteColor,
                    ),
                    unselectedLabelColor: kWhiteColor,
                    tabs: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Personal',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Shared',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                              _categories.length + 1,
                              (index) {
                                if (index == _categories.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showAddCategoryDialog();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 16, top: 16),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: kCardColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: kWhiteColor,
                                              size: 14,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              'Add Category',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return TaskList(
                                  category: _categories[index],
                                  deleteTask: _deleteTask,
                                  isShared: false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                              _shared.length + 1,
                              (index) {
                                if (index == _shared.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showAddSharedDialog(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 16, top: 16),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: kCardColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: kWhiteColor,
                                              size: 14,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              'Add Shared Category',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return TaskList(
                                  shared: _shared[index],
                                  deleteTask: _deleteTask,
                                  isShared: true,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
