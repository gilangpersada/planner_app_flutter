import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class SharedMember extends StatefulWidget {
  final void Function(List<User> value) addMember;
  final List<User> members;
  final User authUser;

  const SharedMember({Key key, this.addMember, this.members, this.authUser})
      : super(key: key);
  @override
  _SharedMemberState createState() => _SharedMemberState();
}

class _SharedMemberState extends State<SharedMember> {
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<User> _users = [];
  List<User> _selectedUsers = [];

  bool isLoading = false;

  void _selectUser(User value) {
    setState(() {
      if (_selectedUsers.any((user) => user.id == value.id)) {
        _selectedUsers.removeWhere((user) => user.id == value.id);
      } else {
        _selectedUsers.add(value);
      }
    });
  }

  void _removeSelectUser(User value) {
    setState(() {
      _selectedUsers.removeWhere((user) => user.id == value.id);
    });
  }

  Future<void> _searchUser() async {
    var isValid = _searchController.text.trim().isNotEmpty;
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      _users = await context
          .read<ModelProvider>()
          .getUserByEmail(_searchController.text);
      _users.removeWhere((user) => user.id == widget.authUser.id);
      setState(() {
        isLoading = false;
      });
      _searchController.text = '';
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void didChangeDependencies() {
    _selectedUsers = widget.members;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                'Members',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kWhiteColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.addMember(_selectedUsers);
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
            height: 16,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kCardColor,
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _searchController,
                style: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search User Email',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: kGreyColor,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: _searchUser,
                    child: Icon(
                      Icons.search,
                      color: kGreyColor,
                    ),
                  ),
                  border: InputBorder.none,
                ),
                onSaved: (newValue) {
                  // categoryName = newValue;
                },
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          if (_selectedUsers.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...List.generate(
                    _selectedUsers.length,
                    (index) => Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                              ),
                              if (widget.authUser.id !=
                                  _selectedUsers[index].id)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeSelectUser(_selectedUsers[index]);
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kGreyColor,
                                      ),
                                      child: Icon(Icons.close, size: 14),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            _selectedUsers[index].userName,
                            style: TextStyle(
                              fontSize: 12,
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 16,
          ),
          Divider(
            color: kWhiteColor,
            height: 0,
            thickness: 0.2,
          ),
          SizedBox(
            height: 8,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Column(
                    children: [
                      ...List.generate(
                        _users.length,
                        (index) => ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          dense: true,
                          leading: CircleAvatar(
                            radius: 16,
                          ),
                          title: Text(
                            _users[index].userName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
                          trailing: GestureDetector(
                            onTap: () {
                              _selectUser(_users[index]);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: kWhiteColor,
                                  width: 2,
                                ),
                                color: (_selectedUsers.any(
                                        (user) => user.id == _users[index].id))
                                    ? kWhiteColor
                                    : null,
                              ),
                              child: (_selectedUsers.any(
                                      (user) => user.id == _users[index].id))
                                  ? Icon(Icons.check,
                                      size: 14, color: kCardColor)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
