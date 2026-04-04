part of '../profile_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileAvatar — единственная ответственность: квадрат с аватаркой.
// Размер передаётся снаружи → адаптируется к любому экрану.
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  final double size;

  const _ProfileAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Icon(
        Icons.person,
        size: size * 0.65,
        color: Colors.grey.shade600,
      ),
    );
  }
}
