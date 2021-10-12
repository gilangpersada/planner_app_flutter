import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/theme.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  final Category category;
  final bool isEdit;

  const AddCategory({Key key, this.category, this.isEdit}) : super(key: key);
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isLoading = false;
  final _nameController = TextEditingController();
  User authUser;
  String categoryName;
  final _formKey = GlobalKey<FormState>();
  int _selectedColor = 4294940672;

  List<int> _color = [
    4294967295,
    4294198070,
    4294940672,
    4294961979,
    4283215696,
    4280391411,
    4288423856,
    4286141768,
  ];

  Future<void> _addCategory() async {
    _formKey.currentState.save();
    var isValid = categoryName.trim().isNotEmpty;

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      var data = {
        'category_name': categoryName,
        'color': _selectedColor,
        if (!widget.isEdit) 'created_at': DateTime.now(),
        'created_by': authUser.id,
      };
      if (widget.isEdit)
        await context
            .read<ModelProvider>()
            .updateCategory(data, widget.category.id);
      if (!widget.isEdit) await context.read<ModelProvider>().addCategory(data);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  void _selectColor(int color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  void initState() {
    if (widget.isEdit) {
      _nameController.text = widget.category.title;
      _selectedColor = widget.category.color;
    }
    authUser = context.read<ModelProvider>().getCurrentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    _addCategory();
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
              height: 16,
            ),
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(_selectedColor),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 5,
                      color: kGreyColor.withOpacity(0.2),
                      offset: Offset(2, 5),
                    ),
                  ],
                ),
                child: Icon(Icons.category),
              ),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                style: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                ),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Category name',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: kWhiteColor,
                  ),
                ),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Please write the category name!';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  categoryName = newValue;
                },
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  _color.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _selectColor(_color[index]);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 4),
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: _selectedColor == _color[index]
                            ? Border.all(color: kGreyColor, width: 3)
                            : null,
                        color: Color(_color[index]),
                      ),
                      child: _selectedColor == _color[index]
                          ? Icon(Icons.check_rounded)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
