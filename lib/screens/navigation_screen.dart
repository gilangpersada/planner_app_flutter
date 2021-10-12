import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/enum_page.dart';
import 'package:party_planner/screens/category_screen.dart';
import 'package:party_planner/screens/home_screen.dart';
import 'package:party_planner/screens/notif_screen.dart';
import 'package:party_planner/screens/shared_screen.dart';
import 'package:party_planner/screens/task_screen.dart';
import 'package:party_planner/theme.dart';
import 'package:party_planner/widgets/drawer/home_drawer.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isLoading = false;
  User _user;
  Widget _page;
  String _scaffoldTitle;
  NavPage _selectedNav;

  void _navPage(NavPage nav) {
    setState(() {
      switch (nav) {
        case NavPage.Home:
          _page = HomeScreen(navPage: _navPage);
          _scaffoldTitle = 'Home';
          _selectedNav = NavPage.Home;
          break;
        case NavPage.Task:
          _page = TaskScreen();
          _scaffoldTitle = 'My Task';
          _selectedNav = NavPage.Task;
          break;
        case NavPage.Category:
          _page = CategoryScreen();
          _scaffoldTitle = 'Personal Category';
          _selectedNav = NavPage.Category;
          break;
        case NavPage.Logout:
          context.read<ModelProvider>().logoutUser();
          FirebaseAuth.instance.signOut();
          break;
        case NavPage.SharedTask:
          _page = SharedScreen();
          _scaffoldTitle = 'Shared Category';
          _selectedNav = NavPage.SharedTask;
          break;
      }
    });
  }

  Future<void> _setAuthUser() async {
    setState(() {
      isLoading = true;
    });
    await context.read<ModelProvider>().loginUser(_user.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    _navPage(NavPage.Home);
    super.initState();
    _setAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        navPage: _navPage,
        selectedNav: _selectedNav,
      ),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _scaffoldTitle,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: kWhiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: kWhiteColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, NotifScreen.routeName);
            },
          ),
        ],
        toolbarHeight: 40,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kWhiteColor),
      ),
      backgroundColor: kBackgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _page == null
              ? Icon(Icons.home)
              : _page,
    );
  }
}
