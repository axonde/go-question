import 'package:flutter/material.dart';
import 'package:go_question/config/theme/ui_constants.dart';
import 'package:go_question/core/widgets/buttons/gq_close_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileContent();
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: UiConstants.topPadding,
          right: UiConstants.rightPadding,
          bottom: UiConstants.bottomPadding,
          left: UiConstants.leftPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                GqCloseButton(onPressed: () => print('press close button')),
              ],
            ),

            const Text('Картинка заза'),
            const Text('Maxim Maximov'),
            const Text('Попап', style: TextStyle(fontSize: 24)),
            const Text('Это содержимое попапа, изолированное в своей фиче.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Редактирование'),
            ),
          ],
        ),
      ),
    );
  }
}
