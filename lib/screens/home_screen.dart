import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/enum_page.dart';
import 'package:party_planner/theme.dart';
import 'package:party_planner/widgets/category/category_card_home.dart';
import 'package:party_planner/widgets/category/category_task.dart';
import 'package:party_planner/widgets/shared/shared_card_home.dart';
import 'package:party_planner/widgets/shared/shared_task.dart';
import 'package:party_planner/widgets/task/task_list_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final void Function(NavPage page) navPage;

  const HomeScreen({Key key, this.navPage}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<Category> _categories = [];
  List<Shared> _shared = [];
  int taskNotDone;
  int taskDone;
  User authUser;

  Future<void> _deleteTask(Task task) async {
    await context.read<ModelProvider>().deleteTask(task.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Swipe down to refresh!',
        style: TextStyle(
          color: kWhiteColor,
        ),
      ),
      backgroundColor: kOrangeColor,
    ));
  }

  Future<void> _fetchCategoriesAndShared() async {
    setState(() {
      isLoading = true;
    });
    await context.read<ModelProvider>().fetchShared(authUser.id);
    await context.read<ModelProvider>().fetchCategory(authUser.id);

    taskDone = await context.read<ModelProvider>().countTaskDone();
    taskNotDone = await context.read<ModelProvider>().countTaskNotDone();
    _shared = context.read<ModelProvider>().getShared;
    _categories = context.read<ModelProvider>().getCategories;
    setState(() {
      isLoading = false;
    });
  }

  void _pushCategory(Category category) {
    Navigator.pushNamed(
      context,
      CategoryTask.routeName,
      arguments: category,
    ).then((value) => _fetchCategoriesAndShared());
  }

  void _pushShared(Shared shared) {
    Navigator.pushNamed(
      context,
      SharedTask.routeName,
      arguments: shared,
    ).then((value) => _fetchCategoriesAndShared());
  }

  @override
  void initState() {
    super.initState();
    authUser = context.read<ModelProvider>().getCurrentUser;
    _fetchCategoriesAndShared();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _fetchCategoriesAndShared,
            child: ListView(
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Hi, ${authUser.userName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: kWhiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Let\'s start\nyour task!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: kWhiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.44,
                      margin: EdgeInsets.only(left: 16),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kOrangeColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 3,
                            color: kOrangeColor.withOpacity(0.2),
                            offset: Offset(7, 7),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kWhiteColor,
                            ),
                            child: Icon(Icons.notes_rounded, size: 16),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Progress Task',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: kWhiteColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '$taskNotDone Task',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kCardColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.44,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kGreyColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 3,
                            color: kGreyColor.withOpacity(0.2),
                            offset: Offset(7, 7),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kWhiteColor,
                            ),
                            child: Icon(Icons.notes_rounded, size: 16),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Complete Task',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: kWhiteColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '$taskDone Task',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kCardColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Personal Category',
                        style: TextStyle(
                          fontSize: 14,
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.navPage(NavPage.Category);
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: kWhiteColor,
                    height: 0,
                    thickness: 0.2,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _categories.length == 0
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'You have no personal category yet!',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) => CategoryCardHome(
                            category: _categories[index],
                            pushCategory: _pushCategory,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shared Category',
                        style: TextStyle(
                          fontSize: 14,
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.navPage(NavPage.SharedTask);
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: kWhiteColor,
                    height: 0,
                    thickness: 0.2,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _shared.length == 0
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'You have no shared category yet!',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                            itemCount: _shared.length,
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            itemBuilder: (context, index) {
                              return SharedCardHome(
                                shared: _shared[index],
                                pushShared: _pushShared,
                              );
                            }),
                      ),
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today Task',
                        style: TextStyle(
                          fontSize: 14,
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.navPage(NavPage.Task);
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: kWhiteColor,
                    height: 0,
                    thickness: 0.2,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: StreamBuilder(
                    stream: context
                        .read<ModelProvider>()
                        .streamAuthTask(authUser.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        );
                      }
                      var taskSnapshot = snapshot.data.docs.where((task) {
                        var deadline = task.data()['deadlineDateTime'];

                        DateTime now = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);
                        DateTime hasDeadline;
                        if (deadline != null) {
                          var date = task.data()['deadlineDateTime'].toDate();
                          hasDeadline =
                              DateTime(date.year, date.month, date.day);
                        }
                        return deadline == null || hasDeadline == now;
                      }).toList();
                      var tasks = taskSnapshot.map((task) {
                        Category category;
                        Shared shared;
                        if (task.data()['shared'] != null) {
                          shared = context
                              .read<ModelProvider>()
                              .getSharedById(task.data()['shared']);
                          category = null;
                        } else {
                          category = context
                              .read<ModelProvider>()
                              .getCategoryById(task.data()['category']);
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
                      if (tasks.length > 0) {
                        return Column(
                          children: [
                            ...List.generate(
                              tasks.length,
                              (index) => TaskListTile(
                                task: tasks[index],
                                deleteTask: _deleteTask,
                                isShared:
                                    tasks[index].shared != null ? true : false,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text(
                          'You have no today due task!',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
              ],
            ),
          );
  }
}
