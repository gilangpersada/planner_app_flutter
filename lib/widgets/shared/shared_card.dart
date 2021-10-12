import 'package:flutter/material.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class SharedCard extends StatefulWidget {
  final Shared shared;
  final String authUser;
  final void Function(Shared shared) pushShared;
  final void Function(Shared shared) deleteShared;

  const SharedCard(
      {Key key, this.shared, this.pushShared, this.deleteShared, this.authUser})
      : super(key: key);

  @override
  _SharedCardState createState() => _SharedCardState();
}

class _SharedCardState extends State<SharedCard> {
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
    return Dismissible(
      key: ValueKey(widget.shared.id),
      onDismissed: (_) {
        widget.deleteShared(widget.shared);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: kWhiteColor),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
            child: Icon(Icons.snippet_folder_rounded),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.shared.title,
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '$_taskCount',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: kGreyColor,
            ),
          ),
        ),
      ),
    );
  }
}
