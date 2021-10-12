import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/widgets/dialog/add_shared_dialog.dart';
import 'package:party_planner/widgets/dialog/join_shared_dialog.dart';
import 'package:party_planner/widgets/shared/shared_card.dart';
import 'package:party_planner/widgets/shared/shared_task.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class SharedScreen extends StatefulWidget {
  @override
  _SharedScreenState createState() => _SharedScreenState();
}

class _SharedScreenState extends State<SharedScreen> {
  List<Shared> _shared = [];
  bool isLoading = false;
  String authUser = FirebaseAuth.instance.currentUser.uid;

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
      didChangeDependencies();
    });
  }

  void _showJoinSharedDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => JoinShared(),
    ).then((_) {
      didChangeDependencies();
    });
  }

  void _pushShared(Shared shared) {
    Navigator.pushNamed(
      context,
      SharedTask.routeName,
      arguments: shared,
    ).then((value) => didChangeDependencies());
  }

  Future<void> _fetchShared() async {
    setState(() {
      isLoading = true;
    });
    await context.read<ModelProvider>().fetchShared(authUser);

    _shared = context.read<ModelProvider>().getShared;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteShared(Shared shared) async {
    setState(() {
      isLoading = true;
    });
    await context.read<ModelProvider>().deleteShared(shared.id);

    _fetchShared();
  }

  @override
  void didChangeDependencies() {
    _fetchShared();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showAddSharedDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: kOrangeColor,
                            borderRadius: BorderRadius.circular(12),
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                    GestureDetector(
                      onTap: () {
                        _showJoinSharedDialog(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          color: kPurpleColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 3,
                              color: kPurpleColor.withOpacity(0.2),
                              offset: Offset(7, 7),
                            )
                          ],
                        ),
                        child: Text(
                          'Join',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: _shared.length,
                    itemBuilder: (context, index) => SharedCard(
                      shared: _shared[index],
                      authUser: authUser,
                      pushShared: _pushShared,
                      deleteShared: _deleteShared,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
