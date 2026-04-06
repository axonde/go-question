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

  const AuthFailure(this.type);
}
