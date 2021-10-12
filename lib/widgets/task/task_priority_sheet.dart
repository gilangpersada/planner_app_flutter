import 'package:flutter/material.dart';

import '../../theme.dart';

class TaskPrioritySheet extends StatefulWidget {
  final String priority;
  final void Function(String priority) changePriority;

  const TaskPrioritySheet({Key key, this.priority, this.changePriority})
      : super(key: key);
  @override
  _TaskPrioritySheetState createState() => _TaskPrioritySheetState();
}

class _TaskPrioritySheetState extends State<TaskPrioritySheet> {
  String _selectedPriority;
  List<String> _priorities = [
    'None',
    'Low',
    'Medium',
    'High',
  ];

  void _selectPriority(String value) {
    setState(() {
      _selectedPriority = value;
    });
  }

  @override
  void initState() {
    _selectedPriority = widget.priority;
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
                  widget.changePriority(_selectedPriority);
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
                itemCount: _priorities.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      onTap: () {
                        _selectPriority(_priorities[index]);
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _priorities[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kWhiteColor,
                        ),
                      ),
                      trailing: _selectedPriority == _priorities[index]
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
