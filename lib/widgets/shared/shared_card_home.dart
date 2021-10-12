import 'package:flutter/material.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class SharedCardHome extends StatefulWidget {
  final Shared shared;
  final String authUser;
  final void Function(Shared shared) pushShared;

  const SharedCardHome({Key key, this.shared, this.pushShared, this.authUser})
      : super(key: key);

  @override
  _SharedCardHomeState createState() => _SharedCardHomeState();
}

class _SharedCardHomeState extends State<SharedCardHome> {
  bool isLoading = false;
  int _taskCount;

  Future<void> _countTask() async {
    setState(() {
      isLoading = true;
    });
    _taskCount = await context
        .read<ModelProvider>()
        .countTaskCategory(widget.shared.id, widget.authUser);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    _countTask();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kCardColor,
      ),
      child: ListTile(
        onTap: () {
          widget.pushShared(widget.shared);
        },
        contentPadding: EdgeInsets.only(left: 8),
        horizontalTitleGap: 8,
        dense: true,
        leading: CircleAvatar(
          backgroundColor: Color(widget.shared.color),
          radius: 18,
          child: Icon(
            Icons.snippet_folder_rounded,
            size: 16,
          ),
        ),
        title: Expanded(
          child: Text(
            widget.shared.title,
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text(
          '$_taskCount Task',
          style: TextStyle(
            color: kOrangeColor,
            fontSize: 12,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: kGreyColor,
            size: 16,
          ),
        ),
      ),
    );
  }
}
