import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

part 'parts/auth_header.dart';
part 'parts/auth_name_field.dart';
part 'parts/auth_email_field.dart';
part 'parts/auth_password_field.dart';
part 'parts/auth_submit_button.dart';
part 'parts/auth_google_button.dart';
part 'parts/auth_switch_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<AuthCubit>();
    if (_isLogin) {
      cubit.signIn(_emailController.text.trim(), _passwordController.text);
    } else {
      cubit.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          minimum: EdgeInsets.only(
            left: UiConstants.leftPadding,
            right: UiConstants.rightPadding,
            top: UiConstants.topPadding,
            bottom: UiConstants.bottomPadding,
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _AuthHeader(),
                        const SizedBox(height: 32),
                        if (!_isLogin) ...[
                          _AuthNameField(controller: _nameController),
                          const SizedBox(height: 16),
                        ],
                        _AuthEmailField(
                          controller: _emailController,
                          emailRegex: _emailRegex,
                        ),
                        const SizedBox(height: 16),
                        _AuthPasswordField(
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          onToggleObscure: () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                        ),
                        const SizedBox(height: 24),
                        _AuthSubmitButton(
                          isLogin: _isLogin,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 12),
                        const _AuthGoogleButton(),
                      ],
                    ),
                  ),
                  _AuthSwitchButton(
                    isLogin: _isLogin,
                    onToggle: () => setState(() {
                      _isLogin = !_isLogin;
                      _formKey.currentState?.reset();
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
