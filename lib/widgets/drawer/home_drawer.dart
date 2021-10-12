import 'package:flutter/material.dart';
import 'package:party_planner/enum_page.dart';
import 'package:party_planner/theme.dart';

class HomeDrawer extends StatelessWidget {
  final void Function(NavPage page) navPage;
  final NavPage selectedNav;

  const HomeDrawer({Key key, this.navPage, this.selectedNav}) : super(key: key);

  void _navPage(NavPage page, BuildContext context) {
    navPage(page);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.75,
      child: Drawer(
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: kBackgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Planner',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
            iconTheme: IconThemeData(color: kWhiteColor),
          ),
          backgroundColor: kBackgroundColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    _navPage(NavPage.Home, context);
                  },
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.home,
                    color: selectedNav == NavPage.Home
                        ? kOrangeColor
                        : kWhiteColor,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedNav == NavPage.Home
                          ? kOrangeColor
                          : kWhiteColor,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _navPage(NavPage.Task, context);
                  },
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.notes,
                    color: selectedNav == NavPage.Task
                        ? kOrangeColor
                        : kWhiteColor,
                  ),
                  title: Text(
                    'My Task',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedNav == NavPage.Task
                          ? kOrangeColor
                          : kWhiteColor,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _navPage(NavPage.Category, context);
                  },
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.category_rounded,
                    color: selectedNav == NavPage.Category
                        ? kOrangeColor
                        : kWhiteColor,
                  ),
                  title: Text(
                    'Personal Category',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedNav == NavPage.Category
                          ? kOrangeColor
                          : kWhiteColor,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _navPage(NavPage.SharedTask, context);
                  },
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.snippet_folder,
                    color: selectedNav == NavPage.SharedTask
                        ? kOrangeColor
                        : kWhiteColor,
                  ),
                  title: Text(
                    'Shared Category',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedNav == NavPage.SharedTask
                          ? kOrangeColor
                          : kWhiteColor,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _navPage(NavPage.Logout, context);
                  },
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.logout,
                    color: kWhiteColor,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 14,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
