import 'package:flutter/material.dart';
import 'package:party_planner/theme.dart';
import 'package:party_planner/widgets/auth/submit_button.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    bool isLoading,
    BuildContext ctx,
  ) submitAuth;

  const AuthForm({Key key, this.isLoading, this.submitAuth}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitAuth(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isLogin ? 'Login' : 'Register',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: kWhiteColor,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                _isLogin
                    ? 'If you dont have an account / '
                    : 'If you already have an account / ',
                style: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin ? 'Register' : 'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: kWhiteColor,
            ),
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Email address',
              labelStyle: TextStyle(
                fontSize: 12,
                color: kWhiteColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kWhiteColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kWhiteColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kWhiteColor),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) {
              _userEmail = newValue;
            },
            key: ValueKey('email'),
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
          ),
          SizedBox(
            height: 16,
          ),
          if (!_isLogin)
            TextFormField(
              style: TextStyle(
                fontSize: 12,
                color: kWhiteColor,
              ),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kWhiteColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kWhiteColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kWhiteColor),
                ),
              ),
              onSaved: (newValue) {
                _userName = newValue;
              },
              key: ValueKey('username'),
              validator: (value) {
                if (value.isEmpty || value.length < 4) {
                  return 'Please enter at least 4 characters';
                }
                return null;
              },
            ),
          if (!_isLogin)
            SizedBox(
              height: 16,
            ),
          TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: kWhiteColor,
            ),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                fontSize: 12,
                color: kWhiteColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kWhiteColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kWhiteColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kWhiteColor),
              ),
            ),
            obscureText: true,
            onSaved: (newValue) {
              _userPassword = newValue;
            },
            key: ValueKey('password'),
            validator: (value) {
              if (value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters long.';
              }
              return null;
            },
          ),
          SizedBox(
            height: 48,
          ),
          if (!widget.isLoading)
            SubmitButton(
              _submit,
              _isLogin,
            ),
          if (widget.isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
