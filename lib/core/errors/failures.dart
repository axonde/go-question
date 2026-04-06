abstract interface class Failure<TType> {
  TType get type;
  String get message;
}

enum AppFailureType {
  serverError,
  connectionError,
  cacheUpdateError,
  emailAlreadyInUseError,
  userNotFoundError,
  authOperationError,
  unauthorizedError,
  validationError,
  unknownError,
}

class GlobalFailure implements Failure<AppFailureType> {
  @override
  final AppFailureType type;

  @override
  final String message;

  const GlobalFailure(this.type, {this.message = ''});

  factory GlobalFailure.fromType(AppFailureType type, {String message = ''}) {
    return GlobalFailure(type, message: message);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GlobalFailure && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'Failure(type: $type, message: $message)';
}
