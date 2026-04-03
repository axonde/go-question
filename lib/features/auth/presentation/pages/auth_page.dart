import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_toggle_button.dart';

/// Страница входа / регистрации.
/// Управляет переключением режима и вызовом cubit.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;

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
      cubit.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      cubit.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isLogin ? 'Вход' : 'Регистрация',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AuthForm(
                    isLogin: _isLogin,
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    nameController: _nameController,
                  ),
                  const SizedBox(height: 24),
                  AuthSubmitButton(isLogin: _isLogin, onSubmit: _submit),
                  const SizedBox(height: 12),
                  const AuthGoogleButton(),
                  const SizedBox(height: 16),
                  AuthToggleButton(isLogin: _isLogin, onToggle: _toggleMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
