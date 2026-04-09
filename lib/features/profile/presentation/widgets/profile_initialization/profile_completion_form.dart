part of '../../pages/profile_initialization_page.dart';

class _ProfileCompletionForm extends StatefulWidget {
  final Profile profile;

  const _ProfileCompletionForm({required this.profile});

  @override
  State<_ProfileCompletionForm> createState() => _ProfileCompletionFormState();
}

class _ProfileCompletionFormState extends State<_ProfileCompletionForm> {
  late final TextEditingController _bioController;
  late final List<String> _cityOptions;
  late final List<String> _genderOptions;
  String? _selectedCity;
  String? _selectedGender;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _selectedCity = widget.profile.city;
    _selectedGender = widget.profile.gender;
    _birthDate = widget.profile.birthDate;
    _cityOptions = _buildOptions(
      ProfilePresentationConstants.completionCityOptions,
      _selectedCity,
    );
    _genderOptions = _buildOptions(
      ProfilePresentationConstants.completionGenderOptions,
      _selectedGender,
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;
    setState(() => _birthDate = picked);
  }

  void _save() {
    final bio = _bioController.text.trim();
    final profile = widget.profile.copyWith(
      city: _selectedCity?.trim(),
      bio: bio.isEmpty ? null : bio,
      gender: _selectedGender?.trim(),
      age: _birthDate == null ? null : _calculateAge(_birthDate!),
      birthDate: _birthDate,
    );
    context.read<ProfileBloc>().add(ProfileUpdateRequested(profile));
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    final hadBirthdayThisYear =
        now.month > birthDate.month ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hadBirthdayThisYear) {
      age -= 1;
    }
    return age < 0 ? 0 : age;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  UiConstants.borderRadius * 4,
                ),
                border: Border.all(color: AppColors.inputBorder),
                boxShadow: const [
                  BoxShadow(color: Color(0x55000000), offset: Offset(0, 6)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(UiConstants.boxUnit * 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      ProfilePresentationConstants.completionTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: UiConstants.textSize * 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: UiConstants.boxUnit),
                    const Text(
                      ProfilePresentationConstants.completionDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: UiConstants.textSize * 0.78,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: UiConstants.boxUnit * 2),
                    _ProfileDropdownField<String>(
                      label: ProfilePresentationConstants.completionCityLabel,
                      hint: ProfilePresentationConstants.completionCityHint,
                      value: _selectedCity,
                      items: _cityOptions,
                      onChanged: (value) =>
                          setState(() => _selectedCity = value),
                    ),
                    const SizedBox(height: UiConstants.boxUnit),
                    _ProfileDropdownField<String>(
                      label: ProfilePresentationConstants.completionGenderLabel,
                      hint: ProfilePresentationConstants.completionGenderHint,
                      value: _selectedGender,
                      items: _genderOptions,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                    ),
                    const SizedBox(height: UiConstants.boxUnit),
                    _ProfileDateField(
                      label:
                          ProfilePresentationConstants.completionBirthDateHint,
                      value: _birthDate,
                      onTap: _pickBirthDate,
                    ),
                    const SizedBox(height: UiConstants.boxUnit),
                    _ProfileTextField(
                      controller: _bioController,
                      hint: ProfilePresentationConstants.completionBioHint,
                      maxLines: 3,
                      optionalLabel: true,
                    ),
                    const SizedBox(height: UiConstants.boxUnit * 1.25),
                    _ProfileAvatarPlaceholder(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              ProfilePresentationConstants.completionAvatarHint,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: UiConstants.boxUnit * 2),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) => GQButton(
                          onPressed: _save,
                          isLoading: state.isLoading,
                          text:
                              ProfilePresentationConstants.completionSaveButton,
                          baseColor: AppColors.primary,
                          widthFactor: 1,
                          height: UiConstants.boxUnit * 5.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<String> _buildOptions(List<String> base, String? current) {
  final result = [...base];
  final value = current?.trim();
  if (value != null &&
      value.isNotEmpty &&
      !result.contains(value) &&
      value != ProfilePresentationConstants.completionCityOptions.last &&
      value != ProfilePresentationConstants.completionGenderOptions.last) {
    result.add(value);
  }
  return result;
}

class _ProfileDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _ProfileDropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiConstants.boxUnit),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        dropdownColor: AppColors.surface,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontFamily: EventTexts.fontClash,
          fontFamilyFallback: EventTexts.fontFallback,
          fontSize: UiConstants.textSize * 0.8,
        ),
        iconEnabledColor: AppColors.textPrimary,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            color: Color(0xFFE8F1FF),
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF9FB4CC),
            fontFamily: EventTexts.fontClash,
            fontFamilyFallback: EventTexts.fontFallback,
          ),
          filled: true,
          fillColor: const Color(0x330A2540),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
            borderSide: const BorderSide(color: Color(0xFF6EA3D4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
            borderSide: const BorderSide(color: Color(0xFFB3D8FF)),
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString()),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _ProfileDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _ProfileDateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(UiConstants.boxUnit * 1.5),
        decoration: BoxDecoration(
          color: const Color(0x330A2540),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
          border: Border.all(color: const Color(0xFF6EA3D4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFE8F1FF),
                fontFamily: EventTexts.fontClash,
                fontFamilyFallback: EventTexts.fontFallback,
                fontSize: UiConstants.textSize * 0.7,
              ),
            ),
            const SizedBox(height: UiConstants.boxUnit * 0.5),
            Text(
              value == null
                  ? ProfilePresentationConstants.completionBirthDateHint
                  : '${value!.day.toString().padLeft(2, '0')}.${value!.month.toString().padLeft(2, '0')}.${value!.year}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: EventTexts.fontClash,
                fontFamilyFallback: EventTexts.fontFallback,
                fontSize: UiConstants.textSize * 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool optionalLabel;

  const _ProfileTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.optionalLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: UiConstants.textSize * 0.8,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: AppColors.primary,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: hint,
        helperText: optionalLabel
            ? ProfilePresentationConstants.completionOptionalSuffix
            : null,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: UiConstants.textSize * 0.78,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UiConstants.horizontalPadding * 2,
          vertical: UiConstants.verticalPadding * 1.5,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _ProfileAvatarPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const _ProfileAvatarPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(UiConstants.boxUnit * 1.5),
        decoration: BoxDecoration(
          color: const Color(0x330A2540),
          borderRadius: BorderRadius.circular(UiConstants.borderRadius * 3),
          border: Border.all(color: const Color(0xFF6EA3D4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.image_outlined, color: AppColors.textPrimary),
            SizedBox(width: UiConstants.boxUnit),
            Expanded(
              child: Text(
                ProfilePresentationConstants.completionAvatarHint,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: EventTexts.fontClash,
                  fontFamilyFallback: EventTexts.fontFallback,
                  fontSize: UiConstants.textSize * 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
