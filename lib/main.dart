import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:party_planner/core/viewmodels/model_provider.dart';

import 'package:party_planner/screens/auth_screen.dart';
import 'package:party_planner/screens/boarding_screen.dart';
import 'package:party_planner/screens/chat_screen.dart';

import 'package:party_planner/screens/navigation_screen.dart';
import 'package:party_planner/screens/notif_screen.dart';
import 'package:party_planner/widgets/category/category_task.dart';
import 'package:party_planner/widgets/shared/shared_task.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;

  runApp(MaterialApp(home: BoardingScreen()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => ModelProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Party Planner',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshotAuth) {
              if (snapshotAuth.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshotAuth.hasData) {
                return NavigationScreen();
              }
              return AuthScreen();
            }),
        routes: {
          CategoryTask.routeName: (ctx) => CategoryTask(),
          SharedTask.routeName: (ctx) => SharedTask(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
          NotifScreen.routeName: (ctx) => NotifScreen(),
        },
      ),
    );
  }
}
