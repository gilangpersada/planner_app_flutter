import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/chat.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/widgets/chat/chat_bubble.dart';
import 'package:party_planner/widgets/chat/chat_form.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = TextEditingController();
  Shared _shared;
  bool isFilled = false;
  bool isLoading = false;
  String authUser = FirebaseAuth.instance.currentUser.uid;

  Future<void> _sendMessage() async {
    var _authUser = await context.read<ModelProvider>().getAuthUser(authUser);
    var data = {
      'message': _chatController.text,
      'sendAt': DateTime.now(),
      'sender': authUser,
      'shared': _shared.id,
      'senderUsername': _authUser.userName,
    };
    await context.read<ModelProvider>().addMessage(data);

    _chatController.text = '';
  }

  @override
  void didChangeDependencies() async {
    _shared = ModalRoute.of(context).settings.arguments;

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _shared.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(_shared.color),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder(
                stream: context.read<ModelProvider>().streamChat(_shared.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var chats = snapshot.data.docs.map((chat) {
                    var data = {
                      'message': chat.data()['message'],
                      'sender': chat.data()['sender'],
                      'shared': chat.data()['shared'],
                      'sendAt': chat.data()['sendAt'].toDate(),
                      'senderUsername': chat.data()['senderUsername'],
                    };
                    return Chat.fromMap(data, chat.id);
                  }).toList();

                  return ListView.builder(
                    itemCount: chats.length,
                    padding: EdgeInsets.zero,
                    reverse: true,
                    itemBuilder: (context, index) => ChatBubble(
                      chat: chats[index],
                      authUser: authUser,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 8, bottom: 16, top: 4),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: kWhiteColor,
                  width: 0.2,
                ),
              ),
            ),
            child: ChatForm(
              chatController: _chatController,
              sendMessage: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
