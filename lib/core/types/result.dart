sealed class Result<TSuccess, TFailure> {
  const Result();
}

final class Success<TSuccess, TFailure> extends Result<TSuccess, TFailure> {
  final TSuccess value;

  const Success(this.value);
}

final class Failure<TSuccess, TFailure> extends Result<TSuccess, TFailure> {
  final TFailure failure;

  const Failure(this.failure);

  @override
  String toString() => 'Failure(failure: $failure)';
}

extension ResultX<TSuccess, TFailure> on Result<TSuccess, TFailure> {
  R fold<R>({
    required R Function(TSuccess value) onSuccess,
    required R Function(TFailure failure) onFailure,
  }) {
    return switch (this) {
      Success<TSuccess, TFailure>(:final value) => onSuccess(value),
      Failure<TSuccess, TFailure>(:final failure) => onFailure(failure),
    };
  }
}
