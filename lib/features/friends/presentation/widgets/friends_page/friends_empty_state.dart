part of '../../pages/friends_page.dart';

class _FriendsEmptyState extends StatelessWidget {
  final bool hintsEnabled;

  const _FriendsEmptyState({required this.hintsEnabled});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0E3457).withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(UiConstants.borderRadius * 5),
        border: Border.all(color: const Color(0xFF5EA3D3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              FriendsTexts.noFriends,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: UiConstants.textSize * 0.9,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (hintsEnabled) ...[
              const SizedBox(height: UiConstants.boxUnit),
              const Text(
                FriendsTexts.noFriendsHint,
                textAlign: TextAlign.center,
                style: TextStyle(
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
