import 'package:go_question/core/errors/failures.dart';

enum ProfileFailureType { server, network, notFound, unknown }

final class ProfileFailure implements Failure<ProfileFailureType> {
  @override
  final ProfileFailureType type;

  @override
  final String message;

  const ProfileFailure(this.type, {this.message = ''});
}
