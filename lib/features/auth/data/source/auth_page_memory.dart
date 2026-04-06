import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/auth_page.dart';
import '../../domain/services/auth_page_memory.dart';

final class SharedPrefsAuthPageMemory implements AuthPageMemory {
  static const _lastAuthPageKey = 'auth.last.page';

  final SharedPreferences _prefs;

  const SharedPrefsAuthPageMemory(this._prefs);

  @override
  Future<AuthPage> readLastPage() async {
    final value = _prefs.getString(_lastAuthPageKey);
    switch (value) {
      case 'login':
      case 'signIn': // legacy key
        return AuthPage.login;
      case 'verifyEmail':
        return AuthPage.verifyEmail;
      case 'signUp':
      default:
        return AuthPage.signUp;
    }
  }

  @override
  Future<void> saveLastPage(AuthPage page) async {
    await _prefs.setString(_lastAuthPageKey, _encode(page));
  }

  String _encode(AuthPage page) {
    switch (page) {
      case AuthPage.login:
        return 'login';
      case AuthPage.signUp:
        return 'signUp';
      case AuthPage.verifyEmail:
        return 'verifyEmail';
    }
  }
}
