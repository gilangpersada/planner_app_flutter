import 'package:flutter/material.dart';

import '../../theme.dart';

class ChatForm extends StatefulWidget {
  final TextEditingController chatController;
  final Function sendMessage;

  const ChatForm({Key key, this.chatController, this.sendMessage})
      : super(key: key);

  @override
  _ChatFormState createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  bool isFilled = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kCardColor,
              border: Border.all(color: kBackgroundColor),
            ),
            child: TextFormField(
              controller: widget.chatController,
              style: TextStyle(
                fontSize: 12,
                color: kWhiteColor,
              ),
              textAlignVertical: TextAlignVertical.top,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Write a message',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                ),
                border: InputBorder.none,
              ),
              onSaved: (newValue) {
                // sharedName = newValue;
              },
              onChanged: (value) {
                setState(() {
                  if (widget.chatController.text.isNotEmpty) {
                    isFilled = true;
                  } else {
                    isFilled = false;
                  }
                });
              },
            ),
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: isFilled ? kOrangeColor : kGreyColor,
            ),
            onPressed: isFilled ? widget.sendMessage : null),
      ],
    );
  }
}
