part of '../../pages/friends_page.dart';

class _FriendsEmptyState extends StatelessWidget {
  final bool hintsEnabled;

  const _FriendsEmptyState({required this.hintsEnabled});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
        border: Border.all(color: Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.friendsNoFriends,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: UiConstants.textSize * 0.9,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (hintsEnabled) ...[
              const SizedBox(height: UiConstants.boxUnit),
              Text(
                context.l10n.friendsNoFriendsHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: UiConstants.textSize * 0.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
