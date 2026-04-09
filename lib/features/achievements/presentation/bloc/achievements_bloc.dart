import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/features/achievements/domain/entities/achievement_view.dart';
import 'package:go_question/features/achievements/domain/errors/achievement_failures.dart';
import 'package:go_question/features/achievements/domain/repositories/i_achievements_repository.dart';

part 'achievements_event.dart';
part 'achievements_state.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final IAchievementsRepository _repository;

  AchievementsBloc(this._repository)
    : super(const AchievementsState.initial()) {
    on<AchievementsOpenedRequested>(_onOpenedRequested);
    on<AchievementsViewedRequested>(_onViewedRequested);
    on<AchievementsRefreshRequested>(_onRefreshRequested);
    on<AchievementsSessionClearedRequested>(_onSessionClearedRequested);
  }

  Future<void> _onOpenedRequested(
    AchievementsOpenedRequested event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(state.copyWith(status: AchievementsStatus.loading, clearError: true));

    final result = await _repository.openAchievements(event.uid);
    result.fold(
      onSuccess: (achievements) {
        emit(
          state.copyWith(
            status: AchievementsStatus.success,
            achievements: achievements,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AchievementsStatus.failure,
            errorMessage: _mapErrorMessage(failure),
          ),
        );
      },
    );
  }

  Future<void> _onViewedRequested(
    AchievementsViewedRequested event,
    Emitter<AchievementsState> emit,
  ) async {
    final result = await _repository.markAllAsViewed(event.uid);

    await result.foldAsync(
      onSuccess: (_) async {
        final refreshed = await _repository.getAchievements(event.uid);
        refreshed.fold(
          onSuccess: (achievements) {
            emit(
              state.copyWith(
                status: AchievementsStatus.success,
                achievements: achievements,
                clearError: true,
              ),
            );
          },
          onFailure: (failure) {
            emit(
              state.copyWith(
                status: AchievementsStatus.failure,
                errorMessage: _mapErrorMessage(failure),
              ),
            );
          },
        );
      },
      onFailure: (failure) async {
        emit(
          state.copyWith(
            status: AchievementsStatus.failure,
            errorMessage: _mapErrorMessage(failure),
          ),
        );
      },
    );
  }

  Future<void> _onRefreshRequested(
    AchievementsRefreshRequested event,
    Emitter<AchievementsState> emit,
  ) async {
    final result = await _repository.getAchievements(event.uid);
    result.fold(
      onSuccess: (achievements) {
        emit(
          state.copyWith(
            status: AchievementsStatus.success,
            achievements: achievements,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: AchievementsStatus.failure,
            errorMessage: _mapErrorMessage(failure),
          ),
        );
      },
    );
  }

  void _onSessionClearedRequested(
    AchievementsSessionClearedRequested event,
    Emitter<AchievementsState> emit,
  ) {
    emit(const AchievementsState.initial());
  }

  String _mapErrorMessage(AchievementFailure failure) {
    switch (failure.type) {
      case AchievementFailureType.profileNotFound:
        return 'Профиль не найден';
      case AchievementFailureType.fetchFailed:
        return 'Не удалось загрузить достижения';
      case AchievementFailureType.updateFailed:
        return 'Не удалось обновить достижения';
    }
  }
}
