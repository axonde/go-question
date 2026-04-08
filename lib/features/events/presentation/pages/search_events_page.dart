import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/go_button.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';
import 'package:go_question/features/events/domain/event_entity.dart';

part 'search_events_page/event_search_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Мок-данные. TODO: заменить на загрузку из Firestore через Cubit/Bloc.
// ─────────────────────────────────────────────────────────────────────────────

final _kMockEvents = [
  EventEntity(
    id: '1',
    title: 'Весенний кубок по Го',
    description:
        'Открытый городской турнир для всех уровней подготовки. Приглашаем игроков от 15 кю до 3 дана включительно. Призовой фонд — сертификаты и памятные призы.',
    imageUrl: '',
    startTime: DateTime(2026, 4, 12, 10, 0),
    location: 'Санкт-Петербург',
    category: 'Турнир',
    price: 0,
    maxUsers: 64,
    participants: 32,
    organizer: 'Клуб СПбГУ',
    status: 'open',
    createdAt: DateTime(2026, 3, 1),
    updatedAt: DateTime(2026, 3, 1),
  ),
  EventEntity(
    id: '2',
    title: 'Клубный чемпионат',
    description:
        'Внутренний чемпионат клуба «Камень» по системе Mac-Mahon. Участие только для членов клуба.',
    imageUrl: '',
    startTime: DateTime(2026, 4, 15, 12, 0),
    location: 'Москва',
    category: 'Чемпионат',
    price: 500,
    maxUsers: 16,
    participants: 14,
    organizer: 'Клуб «Камень»',
    status: 'open',
    createdAt: DateTime(2026, 3, 5),
    updatedAt: DateTime(2026, 3, 5),
  ),
  EventEntity(
    id: '3',
    title: 'Открытый турнир СПб',
    description:
        'Ежегодный открытый турнир Санкт-Петербурга. Участники со всей России и ближнего зарубежья. Формат — 7 туров Swiss.',
    imageUrl: '',
    startTime: DateTime(2026, 4, 20, 9, 30),
    location: 'Санкт-Петербург',
    category: 'Турнир',
    price: 300,
    maxUsers: 128,
    participants: 64,
    organizer: 'Федерация Го России',
    status: 'open',
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 10),
  ),
  EventEntity(
    id: '4',
    title: 'Городской кубок',
    description:
        'Кубок города среди любителей. Принимают участие игроки без разряда.',
    imageUrl: '',
    startTime: DateTime(2026, 5, 5, 11, 0),
    location: 'Новосибирск',
    category: 'Кубок',
    price: 200,
    maxUsers: 32,
    participants: 18,
    organizer: 'Городской клуб',
    status: 'open',
    createdAt: DateTime(2026, 3, 15),
    updatedAt: DateTime(2026, 3, 15),
  ),
  EventEntity(
    id: '5',
    title: 'Летний фестиваль Го',
    description:
        'Неформальный фестиваль с мастер-классами, лекциями и товарищескими партиями. Подходит для начинающих.',
    imageUrl: '',
    startTime: DateTime(2026, 6, 1, 10, 0),
    location: 'Екатеринбург',
    category: 'Фестиваль',
    price: 0,
    maxUsers: 200,
    participants: 87,
    organizer: 'Уральский клуб Го',
    status: 'upcoming',
    createdAt: DateTime(2026, 3, 20),
    updatedAt: DateTime(2026, 3, 20),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// SearchEventsSheet
// ─────────────────────────────────────────────────────────────────────────────

class SearchEventsSheet extends StatefulWidget {
  const SearchEventsSheet({super.key});

  @override
  State<SearchEventsSheet> createState() => _SearchEventsSheetState();
}

class _SearchEventsSheetState extends State<SearchEventsSheet> {
  String? _expandedId;
  bool _showFilters = false;

  // ── Состояние фильтров ─────────────────────────────────────────────────────
  final Set<String> _selectedLocations = {};
  final Set<String> _selectedCategories = {};
  bool? _priceFilter; // null = все, true = бесплатно, false = платно
  bool _spotsFilter = false; // только с свободными местами

  static final _allLocations =
      _kMockEvents.map((e) => e.location).toSet().toList()..sort();
  static final _allCategories =
      _kMockEvents.map((e) => e.category).toSet().toList()..sort();

  int get _activeFilterCount =>
      _selectedLocations.length +
      _selectedCategories.length +
      (_priceFilter != null ? 1 : 0) +
      (_spotsFilter ? 1 : 0);

  List<EventEntity> get _filtered => _kMockEvents.where((e) {
    if (_selectedLocations.isNotEmpty &&
        !_selectedLocations.contains(e.location))
      return false;
    if (_selectedCategories.isNotEmpty &&
        !_selectedCategories.contains(e.category))
      return false;
    if (_priceFilter == true && e.price != 0) return false;
    if (_priceFilter == false && e.price == 0) return false;
    if (_spotsFilter && e.participants >= e.maxUsers) return false;
    return true;
  }).toList();

  void _resetFilters() => setState(() {
    _selectedLocations.clear();
    _selectedCategories.clear();
    _priceFilter = null;
    _spotsFilter = false;
    _expandedId = null;
  });

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiConstants.borderRadius * 8),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFF62697B),
            width: UiConstants.borderWidth / 2,
          ),
          left: BorderSide(
            color: Color(0xFF62697B),
            width: UiConstants.borderWidth / 2,
          ),
          right: BorderSide(
            color: Color(0xFF62697B),
            width: UiConstants.borderWidth / 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            blurRadius: 0,
            offset: Offset(0, -UiConstants.shadowOffsetY),
          ),
        ],
      ),
      // Stack нужен чтобы заголовок рисовался поверх карточек при скролле.
      child: Stack(
        children: [
          Column(
            children: [
              // Невидимый спейсер — резервирует место под заголовок.
              Opacity(
                opacity: 0,
                child: IgnorePointer(
                  child: _SheetHeader(
                    activeFilterCount: _activeFilterCount,
                    onFiltersTap: () {},
                    onClose: () {},
                  ),
                ),
              ),
              // Панель фильтров — выезжает/скрывается плавно.
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: _showFilters
                    ? _FilterPanel(
                        allLocations: _allLocations,
                        allCategories: _allCategories,
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
                child: filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(UiConstants.boxUnit * 3),
                          child: Text(
                            'Нет ивентов по выбранным фильтрам',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Clash',
                              fontFamilyFallback: const [
                                'Roboto',
                                'sans-serif',
                              ],
                              fontSize: UiConstants.textSize * 0.875,
                              color: const Color(0xFF62697B),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        clipBehavior: Clip.none,
                        padding: EdgeInsets.all(UiConstants.boxUnit * 2),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: UiConstants.boxUnit * 1.5),
                        itemBuilder: (_, i) {
                          final event = filtered[i];
                          return EventSearchCard(
                            key: ValueKey(event.id),
                            event: event,
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
          // Заголовок поверх всего — рисуется последним, перекрывает карточки.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _SheetHeader(
              activeFilterCount: _activeFilterCount,
              onFiltersTap: () => setState(() => _showFilters = !_showFilters),
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
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
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            blurRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 2,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _FiltersButton(count: activeFilterCount, onTap: onFiltersTap),
            Expanded(
              child: Center(child: _StrokeTitle(text: 'Поиск ивента')),
            ),
            GqCloseButton(onTap: onClose),
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
        padding: EdgeInsets.symmetric(
          horizontal: UiConstants.boxUnit * 1.25,
          vertical: UiConstants.gap,
        ),
        decoration: BoxDecoration(
          color: hasActive
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 4),
          border: Border.fromBorderSide(
            BorderSide(
              color: Colors.white.withValues(alpha: 0.5),
              width: UiConstants.borderWidth / 2,
            ),
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
              SizedBox(width: UiConstants.boxUnit * 0.5),
              Text(
                '$count',
                style: const TextStyle(
                  fontFamily: 'Clash',
                  fontFamilyFallback: ['Roboto', 'sans-serif'],
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
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF62697B),
            width: UiConstants.borderWidth / 2,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
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
            _FilterSectionLabel(text: 'Стоимость и места'),
            SizedBox(height: UiConstants.boxUnit * 0.75),
            Wrap(
              spacing: UiConstants.boxUnit,
              runSpacing: UiConstants.boxUnit * 0.75,
              children: [
                _FilterChip(
                  label: 'Бесплатно',
                  active: priceFilter == true,
                  onTap: () => onPriceTap(priceFilter == true ? null : true),
                ),
                _FilterChip(
                  label: 'Платно',
                  active: priceFilter == false,
                  onTap: () => onPriceTap(priceFilter == false ? null : false),
                ),
                _FilterChip(
                  label: 'Есть места',
                  active: spotsFilter,
                  onTap: onSpotsTap,
                ),
              ],
            ),
            SizedBox(height: UiConstants.boxUnit * 1.25),
            // ── Строка 2: Категории ────────────────────────────────────────
            _FilterSectionLabel(text: 'Категория'),
            SizedBox(height: UiConstants.boxUnit * 0.75),
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
            SizedBox(height: UiConstants.boxUnit * 1.25),
            // ── Строка 3: Города ───────────────────────────────────────────
            _FilterSectionLabel(text: 'Город'),
            SizedBox(height: UiConstants.boxUnit * 0.75),
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
                        'Сбросить',
                        style: TextStyle(
                          fontFamily: 'Clash',
                          fontFamilyFallback: ['Roboto', 'sans-serif'],
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
                      text: 'Применить',
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

class _FilterSectionLabel extends StatelessWidget {
  final String text;
  const _FilterSectionLabel({required this.text});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Clash',
      fontFamilyFallback: ['Roboto', 'sans-serif'],
      fontSize: UiConstants.textSize * 0.75,
      color: Color(0xFF62697B),
      fontWeight: FontWeight.bold,
    ),
  );
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
        padding: EdgeInsets.symmetric(
          horizontal: UiConstants.boxUnit * 1.25,
          vertical: UiConstants.boxUnit * 0.5,
        ),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1565C0) : const Color(0xFFDEE7F6),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
          border: Border.fromBorderSide(
            BorderSide(
              color: active ? const Color(0xFF0D47A1) : const Color(0xFF62697B),
              width: UiConstants.borderWidth / 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: active ? const Color(0x55000000) : const Color(0x22000000),
              blurRadius: 0,
              offset: const Offset(0, UiConstants.shadowOffsetY),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Clash',
            fontFamilyFallback: const ['Roboto', 'sans-serif'],
            fontSize: UiConstants.textSize * 0.75,
            color: active ? Colors.white : const Color(0xFF3A4560),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StrokeTitle — заголовок с чёрной обводкой и тенью.
// ─────────────────────────────────────────────────────────────────────────────

class _StrokeTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final int maxLines;

  const _StrokeTitle({
    required this.text,
    this.fontSize = UiConstants.textSize * 1.5,
    this.maxLines = 1,
  });

  static const _family = 'Clash';
  static const _fallback = ['Roboto', 'sans-serif'];

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
              Shadow(
                color: Colors.black,
                offset: Offset(0, UiConstants.textShadowOffsetY),
                blurRadius: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
