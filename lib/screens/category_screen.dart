import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/widgets/category/category_card.dart';
import 'package:party_planner/widgets/category/category_task.dart';
import 'package:party_planner/widgets/dialog/add_category_dialog.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> _categories = [];
  bool isLoading = false;
  String authUser = FirebaseAuth.instance.currentUser.uid;

  void _showAddCategoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => AddCategory(
        isEdit: false,
      ),
    ).then((_) {
      setState(() {
        didChangeDependencies();
      });
    });
  }

  void _pushCategory(Category category) {
    Navigator.pushNamed(
      context,
      CategoryTask.routeName,
      arguments: category,
    ).then((value) => didChangeDependencies());
  }

  Future<void> _fetchCategories() async {
    setState(() {
      isLoading = true;
    });
    await context.read<ModelProvider>().fetchCategory(authUser);

    _categories = context.read<ModelProvider>().getCategories;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteCategory(Category category) async {
    setState(() {
      isLoading = true;
    });
    await context.read<ModelProvider>().deleteCategory(category.id);

    _fetchCategories();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _fetchCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: GestureDetector(
                  onTap: () {
                    _showAddCategoryDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: kOrangeColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 3,
                          color: kOrangeColor.withOpacity(0.2),
                          offset: Offset(7, 7),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: kWhiteColor,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Add Category',
                          style: TextStyle(
                            fontSize: 12,
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          category: _categories[index],
                          authUser: authUser,
                          pushCategory: _pushCategory,
                          deleteCategory: _deleteCategory,
                        );
                      }),
                ),
              ),
            ],
          );
  }
}
