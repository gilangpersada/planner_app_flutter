import 'package:flutter/material.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/widgets/notif/notif_tile.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class NotifScreen extends StatefulWidget {
  static const routeName = '/notif-screen';

  @override
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  User authUser;

  @override
  Widget build(BuildContext context) {
    authUser = context.read<ModelProvider>().getCurrentUser;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 40,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: kWhiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: kWhiteColor),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: StreamBuilder(
              stream: context.read<ModelProvider>().streamNotif(authUser.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data.docs.map((data) {
                  return {
                    'sender': data.data()['sender'],
                    'senderUsername': data.data()['senderUsername'],
                    'type': data.data()['type'],
                    'shared': data.data()['shared'],
                  };
                }).toList();

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => NotifTile(
                    senderUsername: data[index]['senderUsername'],
                    shared: data[index]['shared'],
                    type: data[index]['type'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
