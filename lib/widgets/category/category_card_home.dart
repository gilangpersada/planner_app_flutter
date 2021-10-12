import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class CategoryCardHome extends StatefulWidget {
  final Category category;
  final String authUser;
  final void Function(Category category) pushCategory;

  const CategoryCardHome(
      {Key key, this.category, this.pushCategory, this.authUser})
      : super(key: key);

  @override
  _CategoryCardHomeState createState() => _CategoryCardHomeState();
}

class _CategoryCardHomeState extends State<CategoryCardHome> {
  bool isLoading = false;
  int _taskCount;

  Future<void> _countTask() async {
    setState(() {
      isLoading = true;
    });
    _taskCount = await context
        .read<ModelProvider>()
        .countTaskCategory(widget.category.id, widget.authUser);
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
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kCardColor,
      ),
      child: ListTile(
        onTap: () {
          widget.pushCategory(widget.category);
        },
        contentPadding: EdgeInsets.only(left: 8),
        horizontalTitleGap: 8,
        dense: true,
        leading: CircleAvatar(
          backgroundColor: Color(widget.category.color),
          radius: 18,
          child: Icon(
            Icons.category_rounded,
            size: 16,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.category.title,
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
