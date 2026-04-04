part of '../home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _HomeSlot — идентификаторы зон экрана (порядок = порядок итерации в enum)
// ─────────────────────────────────────────────────────────────────────────────

enum _HomeSlot { topBar, profile, placeholder, actions, events }

// ─────────────────────────────────────────────────────────────────────────────
// _HomeLayoutDelegate — единственная ответственность: раскладка зон экрана.
//
// Пропорции берутся напрямую из Figma (высота экрана = 784px в макете).
// На любом реальном устройстве каждая зона занимает ту же долю экрана.
// ─────────────────────────────────────────────────────────────────────────────

class _HomeLayoutDelegate extends MultiChildLayoutDelegate {
  /// Суммарная высота макета в Figma (px).
  static const double _figmaH = 784;

  /// Высота каждой зоны в единицах Figma.
  static const Map<_HomeSlot, double> _figmaSlotH = {
    _HomeSlot.topBar: 50,
    _HomeSlot.profile: 61,
    _HomeSlot.placeholder: 357,
    _HomeSlot.actions: 150,
    _HomeSlot.events: 166,
  };

  @override
  void performLayout(Size size) {
    var dy = 0.0;

    for (final slot in _HomeSlot.values) {
      final h = size.height * (_figmaSlotH[slot]! / _figmaH);

      layoutChild(slot, BoxConstraints.tightFor(width: size.width, height: h));
      positionChild(slot, Offset(0, dy));

      dy += h;
    }
  }

  @override
  bool shouldRelayout(covariant _HomeLayoutDelegate old) => false;
}
