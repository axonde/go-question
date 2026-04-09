import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_question/config/router/router.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/constants/city_constants.dart';
import 'package:go_question/core/constants/event_texts.dart';
import 'package:go_question/core/types/result.dart';
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

part 'search_events_page/event_search_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SearchEventsSheet
// ─────────────────────────────────────────────────────────────────────────────

class SearchEventsSheet extends StatefulWidget {
  const SearchEventsSheet({super.key});

  @override
  State<SearchEventsSheet> createState() => _SearchEventsSheetState();
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.boxUnit * 1.25,
          vertical: UiConstants.boxUnit * 0.5,
        ),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1565C0) : const Color(0xFFDEE7F6),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
          border: Border.fromBorderSide(
            BorderSide(
              color: active ? const Color(0xFF0D47A1) : const Color(0xFF62697B),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: active ? const Color(0x55000000) : const Color(0x22000000),
              offset: const Offset(0, UiConstants.shadowOffsetY),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
            fontSize: UiConstants.textSize * 0.75,
            color: active ? Colors.white : const Color(0xFF3A4560),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FilterPanel — панель выбора фильтров (выезжает под заголовком).
// ─────────────────────────────────────────────────────────────────────────────

class _FilterPanel extends StatelessWidget {
  final List<String> allLocations;
  final List<String> allCategories;
  final Set<String> selectedLocations;
  final Set<String> selectedCategories;
  final bool? priceFilter;
  final bool spotsFilter;
  final int activeCount;
  final ValueChanged<String> onLocationTap;
  final ValueChanged<String> onCategoryTap;
  final ValueChanged<bool?> onPriceTap;
  final VoidCallback onSpotsTap;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _FilterPanel({
    required this.allLocations,
    required this.allCategories,
    required this.selectedLocations,
    required this.selectedCategories,
    required this.priceFilter,
    required this.spotsFilter,
    required this.activeCount,
    required this.onLocationTap,
    required this.onCategoryTap,
    required this.onPriceTap,
    required this.onSpotsTap,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFEBF0FA),
        border: Border(bottom: BorderSide(color: Color(0xFF62697B))),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          UiConstants.boxUnit * 2,
          UiConstants.boxUnit * 1.5,
          UiConstants.boxUnit * 2,
          UiConstants.boxUnit * 1.5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Строка 1: Бесплатно / Платно / Есть места ─────────────────
            const _FilterSectionLabel(text: EventTexts.sectionPriceAndSlots),
            const SizedBox(height: UiConstants.boxUnit * 0.75),
            Wrap(
              spacing: UiConstants.boxUnit,
              runSpacing: UiConstants.boxUnit * 0.75,
              children: [
                _FilterChip(
                  label: EventTexts.filterFree,
                  active: priceFilter == true,
                  onTap: () => onPriceTap(priceFilter == true ? null : true),
                ),
                _FilterChip(
                  label: EventTexts.filterPaid,
                  active: priceFilter == false,
                  onTap: () => onPriceTap(priceFilter == false ? null : false),
                ),
                _FilterChip(
                  label: EventTexts.filterHasSpots,
                  active: spotsFilter,
                  onTap: onSpotsTap,
                ),
              ],
            ),
            const SizedBox(height: UiConstants.boxUnit * 1.25),
            // ── Строка 2: Категории ────────────────────────────────────────
            const _FilterSectionLabel(text: EventTexts.sectionCategory),
            const SizedBox(height: UiConstants.boxUnit * 0.75),
            Wrap(
              spacing: UiConstants.boxUnit,
              runSpacing: UiConstants.boxUnit * 0.75,
              children: [
                for (final cat in allCategories)
                  _FilterChip(
                    label: cat,
                    active: selectedCategories.contains(cat),
                    onTap: () => onCategoryTap(cat),
                  ),
              ],
            ),
            const SizedBox(height: UiConstants.boxUnit * 1.25),
            // ── Строка 3: Города ───────────────────────────────────────────
            const _FilterSectionLabel(text: EventTexts.sectionCity),
            const SizedBox(height: UiConstants.boxUnit * 0.75),
            Wrap(
              spacing: UiConstants.boxUnit,
              runSpacing: UiConstants.boxUnit * 0.75,
              children: [
                for (final loc in allLocations)
                  _FilterChip(
                    label: loc,
                    active: selectedLocations.contains(loc),
                    onTap: () => onLocationTap(loc),
                  ),
              ],
            ),
            const SizedBox(height: UiConstants.boxUnit * 1.5),
            // ── Применить / Сбросить ───────────────────────────────────────
            Row(
              children: [
                if (activeCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: UiConstants.boxUnit),
                    child: GestureDetector(
                      onTap: onReset,
                      child: const Text(
                        EventTexts.buttonReset,
                        style: TextStyle(
                          fontFamily: EventTexts.fontClash,
                          fontFamilyFallback: EventTexts.fontFallback,
                          fontSize: UiConstants.textSize * 0.8,
                          color: Color(0xFF62697B),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, c) => GQButton(
                      onPressed: onApply,
                      text: EventTexts.buttonApply,
                      baseColor: const Color(0xFF1565C0),
                      mainGradient: const LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                      ),
                      outerGradient: const LinearGradient(
                        colors: [Color(0xFF0D47A1), Color(0xFF0D47A1)],
                      ),
                      width: c.maxWidth,
                      height: UiConstants.boxUnit * 4.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FiltersButton — кнопка открытия панели фильтров.
// ─────────────────────────────────────────────────────────────────────────────

class _FiltersButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _FiltersButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasActive = count > 0;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.boxUnit * 1.25,
          vertical: UiConstants.gap,
        ),
        decoration: BoxDecoration(
          color: hasActive
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
          border: Border.fromBorderSide(
            BorderSide(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: UiConstants.textSize,
            ),
            if (hasActive) ...[
              const SizedBox(width: UiConstants.boxUnit * 0.5),
              Text(
                '$count',
                style: const TextStyle(
                  fontFamily: EventTexts.fontClash,
                  fontFamilyFallback: EventTexts.fontFallback,
                  fontSize: UiConstants.textSize * 0.75,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterSectionLabel extends StatelessWidget {
  final String text;
  const _FilterSectionLabel({required this.text});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontFamily: EventTexts.fontClash,
      fontFamilyFallback: EventTexts.fontFallback,
      fontSize: UiConstants.textSize * 0.75,
      color: Color(0xFF62697B),
      fontWeight: FontWeight.bold,
    ),
  );
}

class _SearchEventsSheetState extends State<SearchEventsSheet> {
  String? _expandedId;
  bool _showFilters = false;
  final Set<String> _selectedLocations = {};
  final Set<String> _selectedCategories = {};
  bool? _priceFilter;
  bool _spotsFilter = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<EventsBloc>().add(const EventsSearchRefreshed());
    });
  }

  int get _activeFilterCount =>
      _selectedLocations.length +
      _selectedCategories.length +
      (_priceFilter != null ? 1 : 0) +
      (_spotsFilter ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;

    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, eventsState) {
        final events = eventsState.events;
        final allLocations = [...CityConstants.cityOptions];
        final allCategories = events.map((e) => e.category).toSet().toList()
          ..sort();
        final filtered = _filteredEvents(events);

        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(UiConstants.borderRadius * 8),
            ),
            border: Border(
              top: BorderSide(color: Color(0xFF62697B)),
              left: BorderSide(color: Color(0xFF62697B)),
              right: BorderSide(color: Color(0xFF62697B)),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xCC000000),
                offset: Offset(0, -UiConstants.shadowOffsetY),
              ),
            ],
          ),
          child: Column(
            children: [
              _SheetHeader(
                activeFilterCount: _activeFilterCount,
                onFiltersTap: () =>
                    setState(() => _showFilters = !_showFilters),
                onClose: () => Navigator.of(context).pop(),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                child: _showFilters
                    ? _FilterPanel(
                        allLocations: allLocations,
                        allCategories: allCategories,
                        selectedLocations: _selectedLocations,
                        selectedCategories: _selectedCategories,
                        priceFilter: _priceFilter,
                        spotsFilter: _spotsFilter,
                        activeCount: _activeFilterCount,
                        onLocationTap: (loc) => setState(() {
                          if (!_selectedLocations.remove(loc)) {
                            _selectedLocations.add(loc);
                          }
                          _expandedId = null;
                        }),
                        onCategoryTap: (cat) => setState(() {
                          if (!_selectedCategories.remove(cat)) {
                            _selectedCategories.add(cat);
                          }
                          _expandedId = null;
                        }),
                        onPriceTap: (val) => setState(() {
                          _priceFilter = val;
                          _expandedId = null;
                        }),
                        onSpotsTap: () => setState(() {
                          _spotsFilter = !_spotsFilter;
                          _expandedId = null;
                        }),
                        onReset: _resetFilters,
                        onApply: () => setState(() => _showFilters = false),
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: eventsState.isLoading && events.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(UiConstants.boxUnit * 3),
                          child: Text(
                            EventTexts.emptyEventsByFilters,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: EventTexts.fontClash,
                              fontFamilyFallback: EventTexts.fontFallback,
                              fontSize: UiConstants.textSize * 0.875,
                              color: Color(0xFF62697B),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: UiConstants.boxUnit * 1.5),
                        itemBuilder: (_, i) {
                          final event = filtered[i];
                          return EventSearchCard(
                            key: ValueKey(event.id),
                            event: event,
                            viewerRole: _viewerRoleFor(event, profile?.uid),
                            isExpanded: _expandedId == event.id,
                            onToggle: () => setState(() {
                              _expandedId = _expandedId == event.id
                                  ? null
                                  : event.id;
                            }),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<EventEntity> _filteredEvents(List<EventEntity> events) {
    return events.where((event) {
      if (_selectedLocations.isNotEmpty &&
          !_selectedLocations.contains(event.location)) {
        return false;
      }
      if (_selectedCategories.isNotEmpty &&
          !_selectedCategories.contains(event.category)) {
        return false;
      }
      if (_priceFilter == true && event.price != 0) return false;
      if (_priceFilter == false && event.price == 0) return false;
      if (_spotsFilter && event.participants >= event.maxUsers) return false;
      return true;
    }).toList();
  }

  void _resetFilters() => setState(() {
    _selectedLocations.clear();
    _selectedCategories.clear();
    _priceFilter = null;
    _spotsFilter = false;
    _expandedId = null;
  });

  EventViewerRole _viewerRoleFor(EventEntity event, String? currentUserId) =>
      currentUserId != null && currentUserId == event.organizer
      ? EventViewerRole.organizer
      : EventViewerRole.participant;
}

// ─────────────────────────────────────────────────────────────────────────────
// _SheetHeader — заголовок с центрированным названием, кнопкой фильтров
// и кнопкой закрытия.
// ─────────────────────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback onFiltersTap;
  final VoidCallback onClose;

  const _SheetHeader({
    required this.activeFilterCount,
    required this.onFiltersTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        boxShadow: [BoxShadow(color: Color(0xCC000000), offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 2,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        child: Row(
          children: [
            _FiltersButton(count: activeFilterCount, onTap: onFiltersTap),
            const Expanded(
              child: Center(
                child: _StrokeTitle(text: EventTexts.searchHeaderTitle),
              ),
            ),
            GqCloseButton(onTap: onClose),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StrokeTitle — заголовок с чёрной обводкой и тенью.
// ─────────────────────────────────────────────────────────────────────────────

class _StrokeTitle extends StatelessWidget {
  static const _family = EventTexts.fontClash;
  static const _fallback = EventTexts.fontFallback;
  final String text;

  final double fontSize;

  final int maxLines;
  const _StrokeTitle({
    required this.text,
    this.fontSize = UiConstants.textSize * 1.5,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: _family,
            fontFamilyFallback: _fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = UiConstants.strokeWidth
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: _family,
            fontFamilyFallback: _fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [
              Shadow(offset: Offset(0, UiConstants.textShadowOffsetY)),
            ],
          ),
        ),
      ],
    );
  }
}
