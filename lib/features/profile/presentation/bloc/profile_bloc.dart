import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/features/profile/domain/repositories/i_user_repository.dart';

import 'profile_state.dart';

part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository _repo;

  ProfileBloc(this._repo) : super(const ProfileState.initial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    final result = await _repo.getUserProfile(event.uid);

    result.fold(
      onSuccess: (profile) {
        emit(state.copyWith(status: ProfileStatus.loaded, profile: profile));
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            errorMessage: failure.message,
            clearProfile: true,
          ),
        );
      },
    );
  }
}
