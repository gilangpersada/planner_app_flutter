import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class TaskCategorySheet extends StatefulWidget {
  final Category category;
  final void Function(Category category) changeCategory;

  const TaskCategorySheet({Key key, this.category, this.changeCategory})
      : super(key: key);
  @override
  _TaskCategorySheetState createState() => _TaskCategorySheetState();
}

class _TaskCategorySheetState extends State<TaskCategorySheet> {
  List<Category> _categories = [];
  Category _selectedCategory;

  void _selectCategory(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  void initState() {
    _categories = context.read<ModelProvider>().getCategories;
    _selectedCategory = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    color: kOrangeColor,
                  ),
                ),
              ),
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kWhiteColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.changeCategory(_selectedCategory);
                  Navigator.pop(context);
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 14,
                    color: kOrangeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 32),
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      onTap: () {
                        _selectCategory(_categories[index]);
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _categories[index].title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(_categories[index].color),
                        ),
                      ),
                      trailing: _selectedCategory.id == _categories[index].id
                          ? Icon(
                              Icons.check_rounded,
                              color: kWhiteColor,
                            )
                          : null,
                    ),
                    Divider(
                      color: kWhiteColor,
                      thickness: 0.2,
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
