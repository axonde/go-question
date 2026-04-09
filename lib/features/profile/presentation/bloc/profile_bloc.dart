import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/constants/profile_messages.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/profile/constants/profile_firestore.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';
import 'package:go_question/features/profile/domain/errors/profile_failure.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// ProfileBloc manages profile initialization after successful authentication.
///
/// Responsibilities:
/// * Ensure profile exists via repository orchestration (get -> create if needed)
/// * Handle loading, success, and recoverable failure states
/// * Support explicit retry via ProfileRetryRequested event
/// * Preserve user intent: no logout on partial failure
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static const String _defaultInitialName = profileDefaultInitialName;
  static const String _defaultInitialEmail = 'unknown@goquestion.local';
  final IProfileRepository _repository;
  StreamSubscription<Profile?>? _profileSubscription;

  ProfileBloc(this._repository) : super(const ProfileState.initial()) {
    on<_ProfileStreamUpdated>(_onProfileStreamUpdated);
    on<EnsureProfileExistsRequested>(_onEnsureProfileExistsRequested);
    on<ProfileRetryRequested>(_onRetryRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileRefreshRequested>(_onRefreshRequested);
  }

  /// Ensures profile exists. Called once after auth success.
  ///
  /// State progression:
  /// initial → loading → (success | recoverable failure)
  Future<void> _onEnsureProfileExistsRequested(
    EnsureProfileExistsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _ensureProfileExists(
      uid: event.uid,
      initialEmail: event.initialEmail,
      initialName: event.initialName,
      initialNickname: event.initialNickname,
    );

    result.fold(
      onSuccess: (profile) {
        _watchProfile(profile.uid);
        emit(ProfileState.success(profile));
      },
      onFailure: (failure) {
        emit(
          ProfileState.recoverableFailure(
            message: profileInitializationFailedMessage,
            failureType: failure.type,
            failureMessage: failure.message,
          ),
        );
      },
    );
  }

  /// Retries profile creation on recoverable failure.
  ///
  /// Idempotent by design: repeated retries safely re-attempt creation.
  Future<void> _onRetryRequested(
    ProfileRetryRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _ensureProfileExists(
      uid: event.uid,
      initialEmail: event.initialEmail,
      initialName: event.initialName,
      initialNickname: event.initialNickname,
    );

    result.fold(
      onSuccess: (profile) {
        _watchProfile(profile.uid);
        emit(ProfileState.success(profile));
      },
      onFailure: (failure) {
        emit(
          ProfileState.recoverableFailure(
            message: profileInitializationFailedMessage,
            failureType: failure.type,
            failureMessage: failure.message,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _repository.updateProfile(event.profile);
    result.fold(
      onSuccess: (profile) => emit(ProfileState.success(profile)),
      onFailure: (failure) {
        emit(
          ProfileState.recoverableFailure(
            message: profileInitializationFailedMessage,
            failureType: failure.type,
            failureMessage: failure.message,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.uid.trim().isEmpty) {
      return;
    }

    _watchProfile(event.uid);

    final result = await _repository.getProfile(event.uid);
    result.fold(
      onSuccess: (profile) => emit(ProfileState.success(profile)),
      onFailure: (_) {},
    );
  }

  void _onProfileStreamUpdated(
    _ProfileStreamUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileState.success(event.profile));
  }

  Future<Result<Profile, ProfileFailure>> _ensureProfileExists({
    required String uid,
    required String initialEmail,
    required String initialName,
    required String initialNickname,
  }) async {
    final getResult = await _repository.getProfile(uid);

    return getResult.foldAsync<Result<Profile, ProfileFailure>>(
      onSuccess: (profile) async => Success(profile),
      onFailure: (failure) async {
        if (failure.type == ProfileFailureType.profileNotFound) {
          final normalizedInitialName = initialName.trim().isEmpty
              ? (initialNickname.trim().isNotEmpty
                    ? initialNickname.trim()
                    : _defaultInitialName)
              : initialName;
          final normalizedInitialEmail = initialEmail.trim().isEmpty
              ? _defaultInitialEmail
              : initialEmail;
          final normalizedInitialNickname = initialNickname.trim();

          if (normalizedInitialNickname.isEmpty) {
            return const Failure(
              ProfileFailure(
                ProfileFailureType.invalidName,
                message: ProfileValidationMessages.nicknameCannotBeEmpty,
              ),
            );
          }

          return _repository.createInitialProfile(
            uid: uid,
            initialEmail: normalizedInitialEmail,
            initialName: normalizedInitialName,
            initialNickname: normalizedInitialNickname,
          );
        }

        return Failure(failure);
      },
    );
  }

  void _watchProfile(String uid) {
    _profileSubscription?.cancel();
    _profileSubscription = _repository.watchProfile(uid).listen((profile) {
      if (profile != null) {
        add(_ProfileStreamUpdated(profile));
      }
    });
  }

  @override
  Future<void> close() async {
    await _profileSubscription?.cancel();
    return super.close();
  }
}
