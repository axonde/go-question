import 'package:firebase_core/firebase_core.dart';

import '../errors/exception.dart';

/// Maps Firestore exceptions to app-level exceptions.
///
/// Never masks errors; always throws or rethrows a typed exception.
/// Note: ProfileValidationException and ProfileNotFoundException are handled
/// at the repository level, not here.
AppException mapProfileFirestoreException(Object error) {
  if (error is AppException) {
    return error;
  }

  if (error is FirebaseException) {
    return _mapFirebaseException(error);
  }

  return const UnknownException();
}

AppException _mapFirebaseException(FirebaseException error) {
  final code = error.code;

  // Firestore-specific codes
  if (code == 'not-found') {
    return const ServerException();
  }

  if (code == 'permission-denied') {
    return const ServerException(); // Authorization failure
  }

  if (code == 'unavailable' || code == 'deadline-exceeded') {
    return const NetworkException();
  }

  if (code == 'already-exists') {
    // Conflict: document already exists (rare, but possible)
    return const ServerException();
  }

  if (code == 'invalid-argument') {
    return const ValidationException();
  }

  if (code == 'failed-precondition') {
    // Firestore transaction aborted
    return const ServerException();
  }

  if (code == 'unauthenticated') {
    return const AuthException();
  }

  return const ServerException();
}
