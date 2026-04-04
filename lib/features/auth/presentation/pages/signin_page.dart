import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/features/auth/presentation/widgets/email_field.dart';
import 'package:go_question/features/auth/presentation/widgets/google_button.dart';
import 'package:go_question/features/auth/presentation/widgets/header.dart';
import 'package:go_question/features/auth/presentation/widgets/name_field.dart';
import 'package:go_question/features/auth/presentation/widgets/password_field.dart';
import 'package:go_question/features/auth/presentation/widgets/submit_button.dart';
import 'package:go_question/features/auth/presentation/widgets/switch_button.dart';

class SigninPage extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final VoidCallback onMoveToSignIn;

  SigninPage({super.key, required this.onMoveToSignIn})
    : _formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _isLoading = false;

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
                      NameField(),
                      const SizedBox(height: 16),
                      EmailField(),
                      const SizedBox(height: 16),
                      PasswordField(),
                      const SizedBox(height: 40),
                      SubmitButton.login(
                        isLoading: false,
                        onPressed: () => submit(),
                      ),
                      const SizedBox(height: 12),
                      GoogleButton(isLoading: false, onPressed: () {}),
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
