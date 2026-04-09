import '../../../../core/errors/exception.dart';

/// Thrown when profile invariant is violated.
final class ProfileValidationException extends BaseAppException {
  final String violation;

  const ProfileValidationException({required this.violation})
    : super(type: AppExceptionType.validation);

  @override
  String toString() => 'ProfileValidationException: $violation';
}

/// Thrown when profile does not exist in data source.
final class ProfileNotFoundException extends BaseAppException {
  final String uid;

  const ProfileNotFoundException({required this.uid})
    : super(type: AppExceptionType.unknown);

  @override
  String toString() => 'ProfileNotFoundException: uid=$uid';
}
