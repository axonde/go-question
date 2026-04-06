import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';

import '../widgets/email_field.dart';
import '../widgets/header.dart';
import '../widgets/switch_button.dart';
import '../widgets/google_button.dart';
import '../widgets/name_field.dart';
import '../widgets/password_field.dart';
import '../widgets/submit_button.dart';

class LoginPage extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final VoidCallback onMoveToSignIn;

  LoginPage({super.key, required this.onMoveToSignIn})
    : _formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submit() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(
          left: UiConstants.leftPadding,
          right: UiConstants.rightPadding,
          top: UiConstants.topPadding,
          bottom: UiConstants.bottomPadding,
        ),
        child: Center(
          child: Form(
            key: widget._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Header.login(),
                      const SizedBox(height: 32),
                      NameField(controller: _nameController),
                      const SizedBox(height: 16),
                      EmailField(controller: _emailController),
                      const SizedBox(height: 16),
                      PasswordField(controller: _passwordController),
                      const SizedBox(height: 40),
                      SubmitButton.login(
                        isLoading: _isLoading,
                        onPressed: () => submit(),
                      ),
                      const SizedBox(height: 12),
                      GoogleButton(isLoading: _isLoading, onPressed: () {}),
                    ],
                  ),
                ),
                SwitchButton.login(
                  onToggle: () {
                    widget._formKey.currentState?.reset();
                    widget.onMoveToSignIn();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
