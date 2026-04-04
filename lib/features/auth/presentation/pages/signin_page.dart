import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';

part '../widgets/error_snackbar.dart';
part '../widgets/header.dart';
part '../widgets/name_field.dart';
part '../widgets/email_field.dart';
part '../widgets/password_field.dart';
part '../widgets/submit_button.dart';
part '../widgets/switch_button.dart';
part '../widgets/google_button.dart';

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
                      const _Header.login(),
                      const SizedBox(height: 32),
                      _NameField(),
                      const SizedBox(height: 16),
                      _EmailField(),
                      const SizedBox(height: 16),
                      _PasswordField(),
                      const SizedBox(height: 40),
                      _SubmitButton.login(
                        isLoading: false,
                        onPressed: () => submit(),
                      ),
                      const SizedBox(height: 12),
                      _GoogleButton(isLoading: false, onPressed: () {}),
                    ],
                  ),
                ),
                _SwitchButton.login(
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
