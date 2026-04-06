import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart' show FirebaseException;

import '../../features/auth/domain/errors/auth_exception.dart';
import '../errors/exception.dart';

AppException mapAuthRemoteException(Object error) {
  if (error is AppException) {
    return error;
  }

  if (error is firebase.FirebaseAuthException) {
    return mapFirebaseAuthException(error);
  }

  if (error is FirebaseException) {
    return const ServerException();
  }

  return const UnknownException();
}

AppException mapFirebaseAuthException(firebase.FirebaseAuthException error) {
  switch (error.code) {
    case 'user-not-found':
      return const AuthUserNotFoundException();
    case 'wrong-password':
    case 'invalid-credential':
      return const AuthInvalidCredentialsException();
    case 'email-already-in-use':
      return const AuthEmailAlreadyInUseException();
    case 'invalid-email':
      return const ValidationException();
    case 'weak-password':
      return const AuthWeakPasswordException();
    case 'network-request-failed':
      return const NetworkException();
    case 'too-many-requests':
      return const AuthTooManyRequestsException();
    default:
      return const AuthException();
  }
}
