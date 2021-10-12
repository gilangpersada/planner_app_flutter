import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/widgets/task/task_category_sheet.dart';
import 'package:party_planner/widgets/task/task_priority_sheet.dart';

import '../../theme.dart';

class TaskDetailSheet extends StatefulWidget {
  final Task task;
  final bool isShared;

  const TaskDetailSheet({Key key, this.task, this.isShared}) : super(key: key);
  @override
  _TaskDetailSheetState createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<TaskDetailSheet> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _savedDateTime;
  DateTime _selectedTime = DateTime.now();
  Category _category;

  String _priority;
  bool _useDate = false;
  bool _useTime = false;
  bool isLoading = false;

  Future<void> _saveTask() async {
    var mapData;
    bool onlyDate = false;
    bool onlyTime = false;
    bool useDateTime = false;
    if (_useDate && _useTime) {
      _savedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      useDateTime = true;
    } else if (_useTime && !_useDate) {
      _savedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      onlyTime = true;
    } else if (_useDate && !_useTime) {
      _savedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      onlyDate = true;
    } else {
      _savedDateTime = null;
    }

    mapData = {
      'task_name': _taskController.text,
      'description': _descController.text,
      'deadlineDateTime': _savedDateTime,
      if (!widget.isShared) 'category': _category.id,
      'priority': _priority,
      'onlyDate': onlyDate,
      'onlyTime': onlyTime,
      'useDateTime': useDateTime,
    };

    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await context.read<ModelProvider>().updateTask(mapData, widget.task.id);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  void _switchDate(bool value) {
    setState(() {
      _useDate = value;
    });
  }

  void _switchTime(bool value) {
    setState(() {
      _useTime = value;
    });
  }

  void _convertDuration(DateTime value) {
    _selectedTime = value;
  }

  void _showCategorySheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      backgroundColor: kBackgroundColor,
      isScrollControlled: true,
      builder: (context) => TaskCategorySheet(
        category: _category,
        changeCategory: _changeCategory,
      ),
    );
  }

  void _showPrioritySheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      backgroundColor: kBackgroundColor,
      isScrollControlled: true,
      builder: (context) => TaskPrioritySheet(
        priority: _priority,
        changePriority: _changePriority,
      ),
    );
  }

  void _changeCategory(Category value) {
    setState(() {
      _category = value;
    });
  }

  void _changePriority(String value) {
    setState(() {
      _priority = value;
    });
  }

  @override
  void initState() {
    _taskController.text = widget.task.title;
    _descController.text = widget.task.description;
    if (widget.task.deadlineDateTime != null) {
      var date = DateTime(
        widget.task.deadlineDateTime.year,
        widget.task.deadlineDateTime.month,
        widget.task.deadlineDateTime.day,
      );
      var time = TimeOfDay(
        hour: widget.task.deadlineDateTime.hour,
        minute: widget.task.deadlineDateTime.minute,
      );
      _selectedDate = date;
      _selectedTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, time.hour, time.minute);
      if (widget.task.useDateTime) {
        _useTime = true;
        _useDate = true;
      } else {
        if (widget.task.onlyDate) {
          _useDate = true;
        } else {
          _useDate = false;
        }

        if (widget.task.onlyTime) {
          _useTime = true;
        } else {
          _useTime = false;
        }
      }
    }

    if (!widget.isShared) _category = widget.task.category;
    _priority = widget.task.priority;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery.of(context).size.height * 0.9,
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
                'Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kWhiteColor,
                ),
              ),
              TextButton(
                onPressed: _saveTask,
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
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kCardColor,
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _taskController,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kWhiteColor,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: 'Task name',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: kGreyColor,
                                  ),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please write the task name!';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {},
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Divider(
                                color: kWhiteColor,
                                height: 0,
                                thickness: 0.2,
                              ),
                              TextFormField(
                                controller: _descController,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kWhiteColor,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: kGreyColor,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onSaved: (newValue) {},
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kCardColor,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 24),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: kWhiteColor,
                                  ),
                                ),
                                title: Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kWhiteColor,
                                  ),
                                ),
                                subtitle: _useDate
                                    ? Text(
                                        Jiffy(_selectedDate).yMMMEd,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: kOrangeColor,
                                        ),
                                      )
                                    : null,
                                trailing: CupertinoSwitch(
                                  value: _useDate,
                                  onChanged: (value) {
                                    _switchDate(value);
                                  },
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Divider(
                                  color: kWhiteColor,
                                  height: 0,
                                  thickness: 0.2,
                                ),
                              ),
                              if (_useDate) SizedBox(height: 16),
                              if (_useDate)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: DatePicker(
                                    DateTime.now(),
                                    daysCount: 60,
                                    initialSelectedDate: DateTime.now(),
                                    dateTextStyle: TextStyle(
                                        color: kWhiteColor, fontSize: 12),
                                    dayTextStyle: TextStyle(
                                        color: kWhiteColor, fontSize: 10),
                                    monthTextStyle: TextStyle(
                                        color: kWhiteColor, fontSize: 10),
                                    onDateChange: (selectedDate) {
                                      setState(() {
                                        _selectedDate = selectedDate;
                                      });
                                    },
                                  ),
                                ),
                              if (_useDate) SizedBox(height: 16),
                              if (_useDate)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Divider(
                                    color: kWhiteColor,
                                    height: 0,
                                    thickness: 0.2,
                                  ),
                                ),
                              if (_useDate) SizedBox(height: 8),
                              SizedBox(height: 8),
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 24),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.alarm,
                                    color: kWhiteColor,
                                  ),
                                ),
                                title: Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kWhiteColor,
                                  ),
                                ),
                                subtitle: _useTime
                                    ? Text(
                                        Jiffy(_selectedTime).jm,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: kOrangeColor,
                                        ),
                                      )
                                    : null,
                                trailing: CupertinoSwitch(
                                  value: _useTime,
                                  onChanged: (value) {
                                    _switchTime(value);
                                  },
                                ),
                              ),
                              if (_useTime)
                                SizedBox(
                                  height: 8,
                                ),
                              if (_useTime)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Divider(
                                    color: kWhiteColor,
                                    height: 0,
                                    thickness: 0.2,
                                  ),
                                ),
                              if (_useTime)
                                SizedBox(
                                  height: 16,
                                ),
                              if (_useTime)
                                Container(
                                  height: 45,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                      brightness: Brightness.dark,
                                      textTheme: CupertinoTextThemeData(
                                        dateTimePickerTextStyle:
                                            TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    child: CupertinoDatePicker(
                                      initialDateTime: _selectedTime,
                                      mode: CupertinoDatePickerMode.time,
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          _convertDuration(value);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              if (_useTime) SizedBox(height: 8),
                            ],
                          ),
                        ),
                        if (!widget.isShared)
                          SizedBox(
                            height: 16,
                          ),
                        if (!widget.isShared)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kCardColor,
                            ),
                            child: ListTile(
                              onTap: _showCategorySheet,
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kGreyColor,
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  color: kWhiteColor,
                                ),
                              ),
                              title: Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kWhiteColor,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Color(_category.color),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    _category.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: kGreyColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kCardColor,
                          ),
                          child: ListTile(
                            onTap: _showPrioritySheet,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Priority',
                              style: TextStyle(
                                fontSize: 14,
                                color: kWhiteColor,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _priority,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kWhiteColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: kGreyColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
