part of '../../home_events.dart';

class _ActionButton extends StatelessWidget {
  static const _buttonFontSize = UiConstants.textSize * 0.9;

  final String text;
  final VoidCallback onTap;
  final Color baseColor;

  const _ActionButton({
    required this.text,
    required this.onTap,
    this.baseColor = AppColors.primaryVariant,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<EventsBloc, bool>(
      (bloc) => bloc.state.isLoading,
    );

    return SizedBox(
      width: double.infinity,
      child: GQButton(
        onPressed: onTap,
        isLoading: isLoading,
        text: text,
        fontSize: _buttonFontSize,
        baseColor: baseColor,
        height: UiConstants.boxUnit * 5.5,
      ),
    );
  }
}
