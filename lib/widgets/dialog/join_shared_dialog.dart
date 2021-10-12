import 'package:flutter/material.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/viewmodels/model_provider.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class JoinShared extends StatefulWidget {
  @override
  _JoinSharedState createState() => _JoinSharedState();
}

class _JoinSharedState extends State<JoinShared> {
  final _codeController = TextEditingController();
  bool isLoading = false;
  User authUser;

  Future<void> _joinShared() async {
    var isValid = _codeController.text.trim().isNotEmpty;
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        var idShared = await context
            .read<ModelProvider>()
            .fetchSharedByCode(_codeController.text);
        if (idShared != '' || idShared.isNotEmpty) {
          var shared =
              await context.read<ModelProvider>().fetchSharedById(idShared);
          var members = shared.members.map((e) => e.id).toList();
          members.add(authUser.id);
          var data = {
            'members': members,
          };
          await context.read<ModelProvider>().joinSharedByCode(idShared, data);
        }
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.message,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Success to join!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: kPurpleColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    authUser = context.read<ModelProvider>().getCurrentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Column(
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
                    'Join',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kWhiteColor,
                    ),
                  ),
                  TextButton(
                    onPressed: _joinShared,
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
            ],
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kCardColor,
                          ),
                          child: TextFormField(
                            controller: _codeController,
                            autocorrect: false,
                            style: TextStyle(
                              fontSize: 12,
                              color: kWhiteColor,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: 'Invitation Code',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: kGreyColor,
                              ),
                              border: InputBorder.none,
                            ),
                            onSaved: (newValue) {
                              // sharedName = newValue;
                            },
                          ),
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
