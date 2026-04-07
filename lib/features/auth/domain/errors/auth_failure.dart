import '../../../../core/errors/failures.dart';

enum AuthFailureType {
  server,
  network,
  unauthorized,
  validation,
  unknown,
  userNotFound,
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  tooManyRequests,
}

final class AuthFailure implements Failure<AuthFailureType> {
  @override
  final AuthFailureType type;

  @override
  final String message;

  const AuthFailure(this.type, {this.message = ''});
}
