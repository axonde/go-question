abstract interface class Failure<TType> {
  TType get type;
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

  const GlobalFailure(this.type);

  factory GlobalFailure.fromType(AppFailureType type) {
    return GlobalFailure(type);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GlobalFailure && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'Failure(type: $type)';
}
