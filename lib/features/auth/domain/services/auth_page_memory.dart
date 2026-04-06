import '../entities/auth_page.dart';

abstract interface class AuthPageMemory {
  Future<AuthPage> readLastPage();
  Future<void> saveLastPage(AuthPage page);
}
