import 'package:flutter/material.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/widgets/shared/shared_task.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';

class NotifTile extends StatefulWidget {
  final String shared;
  final String senderUsername;
  final int type;
  const NotifTile({Key key, this.shared, this.senderUsername, this.type})
      : super(key: key);

  @override
  _NotifTileState createState() => _NotifTileState();
}

class _NotifTileState extends State<NotifTile> {
  Shared _shared;
  User authUser;
  bool isLoading = false;
  String _message = '';

  Future<void> _fetchShared() async {
    setState(() {
      isLoading = true;
    });

    _shared =
        await context.read<ModelProvider>().fetchSharedById(widget.shared);

    setState(() {
      isLoading = false;
    });
  }

  void _setMessage() {
    switch (widget.type) {
      case 1:
        _message = ' has invited you to ';
        break;
      case 2:
        _message = ' has removed you from ';
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchShared();
    _setMessage();
    authUser = context.read<ModelProvider>().getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : ListTile(
            contentPadding: EdgeInsets.only(left: 16),
            leading: CircleAvatar(
              backgroundColor: Color(_shared.color),
              radius: 16,
              child: Icon(Icons.snippet_folder_rounded),
            ),
            title: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                ),
                children: [
                  TextSpan(
                    text: widget.senderUsername,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: _message,
                  ),
                  TextSpan(
                    text: _shared.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' shared category.',
                  ),
                ],
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Row(
            //       children: [
            //         Text(
            //           widget.senderUsername,
            //           style: TextStyle(
            //             fontSize: 12,
            //             fontWeight: FontWeight.bold,
            //             color: kWhiteColor,
            //           ),
            //         ),
            //         Text(
            //           _message,
            //           style: TextStyle(
            //             fontSize: 12,
            //             color: kWhiteColor,
            //           ),
            //         ),
            //         Text(
            //           _shared.title,
            //           style: TextStyle(
            //             fontSize: 12,
            //             color: kWhiteColor,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Text(
            //       'shared category.',
            //       style: TextStyle(
            //         fontSize: 12,
            //         color: kWhiteColor,
            //       ),
            //     ),
            //   ],
            // ),
            trailing: widget.type == 1
                ? TextButton(
                    onPressed: () {
                      bool isValid =
                          _shared.members.any((e) => e.id == authUser.id);
                      if (isValid) {
                        Navigator.pushNamed(
                          context,
                          SharedTask.routeName,
                          arguments: _shared,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'You have already removed from that shared category!'),
                            backgroundColor: kOrangeColor,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'View',
                      style: TextStyle(
                        fontSize: 12,
                        color: kOrangeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          );
  }
}
