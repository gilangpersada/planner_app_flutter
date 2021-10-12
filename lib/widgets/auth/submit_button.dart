import 'package:flutter/material.dart';
import 'package:party_planner/theme.dart';

class SubmitButton extends StatelessWidget {
  final Function submit;
  final bool isLogin;

  const SubmitButton(this.submit, this.isLogin);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: submit,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kOrangeColor,
        ),
        child: Text(
          isLogin ? 'Login' : 'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kWhiteColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
