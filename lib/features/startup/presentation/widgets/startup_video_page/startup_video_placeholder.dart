part of '../../pages/startup_video_page.dart';

class _StartupVideoPlaceholder extends StatelessWidget {
  final VoidCallback onComplete;

  const _StartupVideoPlaceholder({required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: UiConstants.boxUnit * 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.video_library_outlined,
            color: StartupUiConstants.iconColor,
            size: UiConstants.boxUnit * 10,
          ),
          const SizedBox(height: UiConstants.boxUnit * 2),
          const Text(
            StartupTexts.placeholderTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StartupUiConstants.textColor,
              fontSize: UiConstants.textSize * 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit * 1.5),
          const Text(
            StartupTexts.placeholderDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StartupUiConstants.textColor,
              fontSize: UiConstants.textSize * 0.85,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit),
          const Text(
            StartupTexts.placeholderAssetLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StartupUiConstants.hintColor,
              fontSize: UiConstants.textSize * 0.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit),
          const Text(
            StartupTexts.backgroundMusicAssetLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StartupUiConstants.hintColor,
              fontSize: UiConstants.textSize * 0.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit),
          const Text(
            StartupTexts.placeholderHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StartupUiConstants.hintColor,
              fontSize: UiConstants.textSize * 0.72,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UiConstants.boxUnit * 2.5),
          GQButton(
            onPressed: onComplete,
            text: StartupTexts.continueButton,
            widthFactor: 1,
            aspectRatio: 4.6,
          ),
        ],
      ),
    );
  }
}
