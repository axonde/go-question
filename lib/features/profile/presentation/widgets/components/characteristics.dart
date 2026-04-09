part of '../profile_screen.dart';

class _Characteristics extends StatelessWidget {
  final String birthDate;
  final bool isBirthDatePlaceholder;
  final String city;
  final bool isCityPlaceholder;
  final String name;
  final bool isNamePlaceholder;
  final ValueChanged<String> onCityChanged;

  const _Characteristics({
    required this.birthDate,
    required this.isBirthDatePlaceholder,
    required this.city,
    required this.isCityPlaceholder,
    required this.name,
    required this.isNamePlaceholder,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: UiConstants.gap * 2,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(defaultValue: name, isPlaceholder: isNamePlaceholder),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: UiConstants.gap,
          children: [
            Expanded(
              child: _DateField(
                defaultValue: birthDate,
                isPlaceholder: isBirthDatePlaceholder,
              ),
            ),
            Expanded(
              flex: 2,
              child: _CityField(
                defaultValue: city,
                isPlaceholder: isCityPlaceholder,
                onChanged: onCityChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateField extends StatefulWidget {
  final String defaultValue;
  final bool isPlaceholder;

  const _DateField({required this.defaultValue, required this.isPlaceholder});

  @override
  State<StatefulWidget> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  static final RegExp _datePattern = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');
  late String value;

  @override
  void initState() {
    value = widget.defaultValue;
    super.initState();
  }

  Future<void> _showEditDialog() async {
    final initialText = widget.isPlaceholder ? '' : value;
    final controller = TextEditingController(text: initialText);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Дата рождения'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.done,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _DateInputFormatter(),
          ],
          maxLength: 10,
          decoration: const InputDecoration(
            hintText: 'DD.MM.YYYY',
            counterText: '',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(ProfilePresentationConstants.dialogCancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text(ProfilePresentationConstants.dialogSaveButton),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }

    if (result == null) {
      return;
    }

    final normalized = result.trim();
    if (_isValidDate(normalized)) {
      setState(() {
        value = normalized;
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Введите дату в формате DD.MM.YYYY')),
    );
  }

  bool _isValidDate(String input) {
    if (!_datePattern.hasMatch(input)) {
      return false;
    }

    final parts = input.split('.');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final parsed = DateTime.tryParse('$year-${parts[1]}-${parts[0]}');
    if (parsed == null) {
      return false;
    }

    return parsed.year == year && parsed.month == month && parsed.day == day;
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: _showEditDialog,
      child: SizedBox(
        height: UiConstants.minInputHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            border: BoxBorder.all(color: AppColors.inputBorder),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
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

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 8 ? digits.substring(0, 8) : digits;

    final buffer = StringBuffer();

    for (var i = 0; i < limitedDigits.length; i++) {
      buffer.write(limitedDigits[i]);

      if (i == 1 || i == 3) {
        if (limitedDigits.length > i + 1) {
          buffer.write('.');
        }
      }
    }

    if (limitedDigits.length == 2 || limitedDigits.length == 4) {
      buffer.write('.');
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _Field extends StatefulWidget {
  final String defaultValue;
  final bool isPlaceholder;

  const _Field({required this.defaultValue, required this.isPlaceholder});

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
    final initialText = widget.isPlaceholder ? '' : value;
    final controller = TextEditingController(text: initialText);
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(ProfilePresentationConstants.dialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: const InputDecoration(
            hintText: ProfilePresentationConstants.dialogInputHint,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(ProfilePresentationConstants.dialogCancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text(ProfilePresentationConstants.dialogSaveButton),
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
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
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

class _CityField extends StatefulWidget {
  final String defaultValue;
  final bool isPlaceholder;
  final ValueChanged<String> onChanged;

  const _CityField({
    required this.defaultValue,
    required this.isPlaceholder,
    required this.onChanged,
  });

  @override
  State<_CityField> createState() => _CityFieldState();
}

class _CityFieldState extends State<_CityField> {
  late String value;

  @override
  void initState() {
    value = widget.defaultValue;
    super.initState();
  }

  Future<void> _showCitySelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          CitySelectorSheet(selectedCity: widget.isPlaceholder ? null : value),
    );

    if (!mounted || result == null || result.trim().isEmpty) {
      return;
    }

    final normalized = result.trim();
    setState(() => value = normalized);
    widget.onChanged(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: _showCitySelector,
      child: SizedBox(
        height: UiConstants.minInputHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            border: BoxBorder.all(color: AppColors.inputBorder),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
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
