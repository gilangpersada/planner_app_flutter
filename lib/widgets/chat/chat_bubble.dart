import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:party_planner/core/models/chat.dart';
import 'package:party_planner/theme.dart';

class ChatBubble extends StatelessWidget {
  final Chat chat;
  final String authUser;

  const ChatBubble({Key key, this.chat, this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Align(
            alignment: (chat.sender == authUser)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              chat.senderUsername,
              style: TextStyle(
                fontSize: 10,
                color: kWhiteColor,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: (chat.sender == authUser)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: (chat.sender == authUser)
                      ? Radius.circular(8)
                      : Radius.circular(0),
                  topRight: (chat.sender == authUser)
                      ? Radius.circular(0)
                      : Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: (chat.sender == authUser) ? kCardColor : kOrangeColor,
              ),
              child: Text(
                chat.message,
                style: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Align(
            alignment: (chat.sender == authUser)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              DateTime(
                        chat.sendAt.year,
                        chat.sendAt.month,
                        chat.sendAt.day,
                      ) ==
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      )
                  ? 'Today, ${Jiffy(chat.sendAt).jm}'
                  : Jiffy(chat.sendAt).yMMMEdjm,
              style: TextStyle(
                fontSize: 10,
                color: kGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
