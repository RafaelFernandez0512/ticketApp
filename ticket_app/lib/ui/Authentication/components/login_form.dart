import 'package:flutter/material.dart';
import 'package:ticket_app/controller/login_controller.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';
import 'package:ticket_app/utils/gaps.dart';

class LoginForm extends StatelessWidget {
  LoginController controller;
  LoginForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          CustomTextField(
            labelText: 'Email',
            onChanged: (text) => {controller.onChangeUserName(text)},
          ),
          gapH24,
          CustomTextField(
            labelText: 'Password',
            obscureText: true,
            onChanged: (text) => {controller.onChangePassword(text)},
          ),
        ],
      ),
    );
  }
}
