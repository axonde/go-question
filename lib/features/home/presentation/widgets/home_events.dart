import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/theme/app_colors.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/constants/home_ui_constants.dart';
import 'package:go_question/core/types/result.dart';
import 'package:go_question/core/utils/city_utils.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/features/events/domain/entities/event_entity.dart';
import 'package:go_question/features/events/presentation/bloc/events_bloc.dart';
import 'package:go_question/features/events/presentation/pages/event_participants_dialog.dart';
import 'package:go_question/features/events/presentation/utils/event_editor_utils.dart';
import 'package:go_question/features/events/presentation/utils/event_presentation_utils.dart';
import 'package:go_question/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:go_question/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:go_question/injection_container/injection_container.dart';

part 'home_events/event_card/action_button.dart';
part 'home_events/event_card/card_decoration.dart';
part 'home_events/event_card/detail_line.dart';
part 'home_events/event_card/empty_card.dart';
part 'home_events/event_card/event_card.dart';
part 'home_events/event_card/event_details_dialog.dart';
part 'home_events/events_list.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _EventData — plain-модель события для отображения.
// ─────────────────────────────────────────────────────────────────────────────

class _EventCardData {
  final EventEntity event;
  final EventViewerRole viewerRole;

  const _EventCardData({required this.event, required this.viewerRole});
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeEvents — зона событий на главном экране.
//
// ≤ 3 события → три фиксированных рамки без скролла (пустые — заглушки).
//  4+ событий → те же рамки той же высоты, но в скролящемся списке.
// ─────────────────────────────────────────────────────────────────────────────

class HomeEvents extends StatelessWidget {
  const HomeEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;
    final eventsState = context.watch<EventsBloc>().state;
    final joinedIds = profile?.joinedEventIds ?? const <String>[];
    final createdIds = profile?.createdEventIds ?? const <String>[];
    final currentCity = profile?.city;
    final events = _buildMyEvents(
      eventsState.events,
      joinedIds: joinedIds,
      createdIds: createdIds,
      currentCity: currentCity,
    );

    return _EventsList(events: events);
  }

  List<_EventCardData> _buildMyEvents(
    List<EventEntity> events, {
    required List<String> joinedIds,
    required List<String> createdIds,
    required String? currentCity,
  }) {
    final allMyIds = <String>{...joinedIds, ...createdIds};
    if (allMyIds.isEmpty) {
      return const <_EventCardData>[];
    }

    final createdSet = createdIds.toSet();
    final filtered = CityUtils.sortEventsByCityPriority(
      items: events.where((event) => allMyIds.contains(event.id)).toList(),
      city: currentCity,
      locationOf: (event) => event.location,
      startTimeOf: (event) => event.startTime,
    );
    return filtered
        .map(
          (event) => _EventCardData(
            event: event,
            viewerRole: createdSet.contains(event.id)
                ? EventViewerRole.organizer
                : EventViewerRole.participant,
          ),
        )
        .toList(growable: false);
  }
}
