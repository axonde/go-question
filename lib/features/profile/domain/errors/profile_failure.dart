import '../../../../core/errors/failures.dart';

enum ProfileFailureType {
  profileNotFound,
  invalidName,
  invalidAge,
  invalidCounters,
  server,
  network,
  unknown,
}

final class ProfileFailure implements Failure<ProfileFailureType> {
  @override
  final ProfileFailureType type;

  @override
  final String message;

  const ProfileFailure(this.type, {this.message = ''});
}
