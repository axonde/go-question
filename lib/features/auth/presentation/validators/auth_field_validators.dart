class AuthFieldValidators {
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _nicknameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите email';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Некорректный email';
    }
    return null;
  }

  static String? nickname(String? value) {
    final nickname = value?.trim() ?? '';
    if (nickname.isEmpty) {
      return 'Введите никнейм';
    }
    if (!_nicknameRegex.hasMatch(nickname)) {
      return 'Никнейм: 3-20 символов, латиница/цифры/подчеркивание';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Минимум 6 символов';
    }
    return null;
  }
}
