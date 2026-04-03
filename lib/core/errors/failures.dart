import '../constants/messages.dart';

enum FailureType {
  serverError,
  connectionError,
  cacheUpdateError,
  characterAlreadyExistError,
  characterNotExistError,
  favoriteCharacterOperationError,
  unauthorizedError,
  validationError,
  unknownError,
}

class Failure {
  final FailureType type;
  final String message;

  const Failure(this.type, [String? message])
    : message = message ?? _fallbackMessage;

  factory Failure.fromType(FailureType type, {String? message}) {
    return Failure(type, message ?? _defaultMessages[type]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.type == type && other.message == message;
  }

  @override
  int get hashCode => Object.hash(type, message);

  @override
  String toString() => 'Failure(type: $type, message: $message)';

  static const String _fallbackMessage = 'Unknown error occurred';

  static const Map<FailureType, String> _defaultMessages = {
    FailureType.serverError: serverFailureMessage,
    FailureType.connectionError: connectionFailureMessage,
    FailureType.cacheUpdateError: cacheUpdateFailureMessage,
    FailureType.characterAlreadyExistError: characterAlreadyExistMessage,
    FailureType.characterNotExistError: characterDontExistMessage,
    FailureType.favoriteCharacterOperationError: favCharacterOperationMessage,
    FailureType.unauthorizedError: 'Authorization error occurred',
    FailureType.validationError: 'Validation error occurred',
    FailureType.unknownError: _fallbackMessage,
  };
}
