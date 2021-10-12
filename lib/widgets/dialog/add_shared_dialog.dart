import 'dart:math';

import 'package:flutter/material.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:party_planner/widgets/shared/shared_member_sheet.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class AddShared extends StatefulWidget {
  final bool isEdit;
  final Shared shared;

  const AddShared({Key key, this.isEdit, this.shared}) : super(key: key);
  @override
  _AddSharedState createState() => _AddSharedState();
}

class _AddSharedState extends State<AddShared> {
  User authUser;
  bool isLoading = false;
  final _nameController = TextEditingController();
  String sharedName;
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
  List<User> _users = [];
  List<User> _removedUsers = [];
  List<String> _removedUsersId = [];

  void _addMembers(List<User> value) {
    setState(() {
      _users = value;
    });
  }

  void _deleteUser(User value) {
    setState(() {
      bool isValid = _users.any((usr) => usr.id == value.id);
      bool isExist = _removedUsers.any((usr) => usr.id == value.id);
      _users.removeWhere((usr) => usr.id == value.id);

      if (!isExist && isValid) {
        _removedUsers.add(value);
        _removedUsersId.add(value.id);
      }
    });
  }

  Future<void> _addShared() async {
    _formKey.currentState.save();
    var isValid = sharedName.trim().isNotEmpty;

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      var userId = _users.map((e) => e.id).toList();
      var userNotif = _users.where((usr) => usr.id != authUser.id).toList();
      var userNotifId = userNotif.map((e) => e.id).toList();
      var code = Random().nextInt(10000) + 1000;

      var data = {
        'shared_name': sharedName,
        'color': _selectedColor,
        if (!widget.isEdit) 'created_at': DateTime.now(),
        'members': userId,
        'admin': authUser.id,
        if (!widget.isEdit) 'code': code.toString(),
      };

      if (widget.isEdit) {
        await context
            .read<ModelProvider>()
            .updateShared(data, widget.shared.id);
        if (_removedUsers.isNotEmpty) {
          var dataNotif = {
            'type': 2,
            'shared': widget.shared.id,
            'sender': authUser.id,
            'senderUsername': authUser.userName,
            'notifTo': _removedUsersId,
            'created_at': DateTime.now(),
          };
          await context
              .read<ModelProvider>()
              .addSharedNotif(dataNotif, widget.shared.id + authUser.id + '2');
        } else {
          var dataNotif = {
            'type': 1,
            'shared': widget.shared.id,
            'sender': authUser.id,
            'senderUsername': authUser.userName,
            'notifTo': userNotifId,
            'created_at': DateTime.now(),
          };
          await context
              .read<ModelProvider>()
              .addSharedNotif(dataNotif, widget.shared.id + authUser.id + '1');
        }
      }

      if (!widget.isEdit) {
        var idShared = await context.read<ModelProvider>().addShared(data);
        var dataNotif = {
          'type': 1,
          'shared': idShared,
          'sender': authUser.id,
          'senderUsername': authUser.userName,
          'notifTo': userNotifId,
          'created_at': DateTime.now(),
        };
        await context
            .read<ModelProvider>()
            .addSharedNotif(dataNotif, idShared + authUser.id + '1');
      }

      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  void _showMemberSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBackgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => SharedMember(
        addMember: _addMembers,
        members: _users,
        authUser: authUser,
      ),
    );
  }

  void _selectColor(int color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  void initState() {
    if (widget.isEdit) {
      _nameController.text = widget.shared.title;
      _selectedColor = widget.shared.color;
      _users = widget.shared.members;
    }
    super.initState();
    authUser = context.read<ModelProvider>().getCurrentUser;
    if (!widget.isEdit) _users.add(authUser);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.9,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
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
                          'Folder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _addShared();
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
                    Expanded(
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(_selectedColor),
                              ),
                              child: Icon(Icons.folder_shared_rounded),
                            ),
                          ),
                          SizedBox(
                            height: 24,
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
                                          ? Border.all(
                                              color: kGreyColor, width: 3)
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
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kCardColor,
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              autocorrect: false,
                              style: TextStyle(
                                fontSize: 12,
                                color: kWhiteColor,
                              ),
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                hintText: 'Folder name',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: kGreyColor,
                                ),
                                border: InputBorder.none,
                              ),
                              onSaved: (newValue) {
                                sharedName = newValue;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kCardColor,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: _showMemberSheet,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: kGreyColor,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  title: Text(
                                    'Members',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: kGreyColor,
                                  ),
                                ),
                                if (_users.isNotEmpty)
                                  SizedBox(
                                    height: 16,
                                  ),
                                if (_users.isNotEmpty)
                                  Divider(
                                    color: kWhiteColor,
                                    height: 0,
                                    thickness: 0.2,
                                  ),
                                ...List.generate(
                                  _users.length,
                                  (index) => ListTile(
                                    dense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    leading: CircleAvatar(
                                      radius: 16,
                                    ),
                                    title: Text(
                                      _users[index].userName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: kWhiteColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      _users[index].email,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: kOrangeColor,
                                      ),
                                    ),
                                    trailing: (_users[index].id == authUser.id)
                                        ? null
                                        : GestureDetector(
                                            onTap: () {
                                              _deleteUser(_users[index]);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: kWhiteColor,
                                              size: 16,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          if (widget.isEdit)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: kCardColor,
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.vpn_key,
                                    color: kWhiteColor,
                                  ),
                                ),
                                title: Text(
                                  widget.shared.code,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kWhiteColor,
                                  ),
                                ),
                                subtitle: Text(
                                  'Invitation Code',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
