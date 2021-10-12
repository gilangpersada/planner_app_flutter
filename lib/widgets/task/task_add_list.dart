import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class TaskAddList extends StatefulWidget {
  final Category category;
  final Shared shared;
  final bool isShared;

  const TaskAddList({Key key, this.category, this.shared, this.isShared})
      : super(key: key);
  @override
  _TaskAddListState createState() => _TaskAddListState();
}

class _TaskAddListState extends State<TaskAddList> {
  final _formKey = GlobalKey<FormState>();
  var _taskController = TextEditingController();
  String authUser = FirebaseAuth.instance.currentUser.uid;
  String taskName;
  bool isFilled = false;
  bool isLoading = false;

  Future<void> _addTask() async {
    _formKey.currentState.save();
    if (taskName.trim().isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var data = {
        'task_name': taskName,
        'created_at': DateTime.now(),
        if (!widget.isShared) 'category': widget.category.id,
        if (widget.isShared) 'shared': widget.shared.id,
        'created_by': authUser,
        'isDone': false,
      };
      await context.read<ModelProvider>().addTask(data);
      _taskController.text = '';
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = false;
        isFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        enableSuggestions: false,
        autocorrect: false,
        textAlignVertical: TextAlignVertical.center,
        controller: _taskController,
        style: TextStyle(
          fontSize: 12,
          color: kWhiteColor,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.add_circle_outline_sharp,
            color: kWhiteColor,
          ),
          suffixIcon: isLoading
              ? SizedBox(
                  width: 5,
                  height: 5,
                  child: CircularProgressIndicator(),
                )
              : isFilled
                  ? GestureDetector(
                      onTap: _addTask,
                      child: Icon(
                        Icons.send_rounded,
                        color: kWhiteColor,
                      ),
                    )
                  : null,
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.trim().isNotEmpty) {
            setState(() {
              isFilled = true;
            });
          } else {
            setState(() {
              isFilled = false;
            });
          }
        },
        onSaved: (newValue) {
          taskName = newValue;
        },
      ),
    );
  }
}
