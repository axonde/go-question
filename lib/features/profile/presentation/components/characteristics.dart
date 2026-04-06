part of '../profile_screen.dart';

class _Characteristics extends StatelessWidget {
  final String yearsOld;
  final String city;
  final String mail;

  const _Characteristics({
    required this.yearsOld,
    required this.city,
    required this.mail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: UiConstants.gap * 2,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: UiConstants.gap,
          children: [
            Expanded(flex: 1, child: _Field(yearsOld)),
            Expanded(flex: 2, child: _Field(city)),
          ],
        ),
        _Field(mail),
      ],
    );
  }
}

class _Field extends StatefulWidget {
  final String defaultValue;

  const _Field(this.defaultValue);

  @override
  State<StatefulWidget> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  late String value;

  @override
  void initState() {
    value = widget.defaultValue;
    super.initState();
  }

  void _showEditDialog(BuildContext context) async {
    final controller = TextEditingController(text: value);
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Редактировать'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Введите значение',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    ).then((result) {
      if (result != null && result.trim().isNotEmpty) {
        setState(() {
          value = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => _showEditDialog(context),
      child: SizedBox(
        height: UiConstants.minInputHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            border: BoxBorder.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: UiConstants.topPadding * 2,
              right: UiConstants.rightPadding * 2,
              bottom: UiConstants.bottomPadding * 2,
              left: UiConstants.leftPadding * 2,
            ),
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(value)),
          ),
        ),
      ),
    );
  }
}
