import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/pressable.dart';

part 'bottom_nav_bar/_nav_background.dart';
part 'bottom_nav_bar/_nav_item.dart';

const _kFriendsAsset = 'assets/icons/png/friends.png';
const _kBattleAsset = 'assets/icons/png/battle.png';
const _kSettingsAsset = 'assets/icons/png/settings.png';

const double _kBarHeight = UiConstants.boxUnit * 13;
const double _kDividerWidth = 3.0;
const Color _kDividerColor = Color(0xFF7C9DA4);

class ClashNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ClashNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: _kBarHeight + bottomPad,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: _NavBackground()),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _NavItem(
                  index: 0,
                  label: 'Друзья',
                  assetPath: _kFriendsAsset,
                  fallbackIcon: Icons.people_outline,
                  currentIndex: currentIndex,
                  bottomPad: bottomPad,
                  onTap: onTap,
                ),
              ),
              const _Divider(),
              Expanded(
                child: _NavItem(
                  index: 1,
                  label: 'Го',
                  assetPath: _kBattleAsset,
                  fallbackIcon: Icons.sports_martial_arts,
                  currentIndex: currentIndex,
                  bottomPad: bottomPad,
                  onTap: onTap,
                  large: true,
                ),
              ),
              const _Divider(),
              Expanded(
                child: _NavItem(
                  index: 2,
                  label: 'Настройки',
                  assetPath: _kSettingsAsset,
                  fallbackIcon: Icons.settings_outlined,
                  currentIndex: currentIndex,
                  bottomPad: bottomPad,
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: _kDividerWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(color: _kDividerColor),
        child: SizedBox.expand(),
      ),
    );
  }
}
