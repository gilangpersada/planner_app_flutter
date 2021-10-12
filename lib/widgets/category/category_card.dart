import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/theme.dart';
import 'package:party_planner/widgets/category/category_task.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final String authUser;
  final int taskCount;
  final void Function(Category category) pushCategory;
  final void Function(Category category) deleteCategory;

  const CategoryCard(
      {Key key,
      this.category,
      this.pushCategory,
      this.deleteCategory,
      this.authUser,
      this.taskCount})
      : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
    return Dismissible(
      key: ValueKey(widget.category.id),
      onDismissed: (_) {
        widget.deleteCategory(widget.category);
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
            widget.pushCategory(widget.category);
          },
          contentPadding: EdgeInsets.only(left: 16),
          horizontalTitleGap: 8,
          dense: true,
          leading: CircleAvatar(
            backgroundColor: Color(widget.category.color),
            radius: 18,
            child: Icon(Icons.category_rounded),
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
              isLoading
                  ? Container()
                  : Text(
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
