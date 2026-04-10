abstract final class CityConstants {
  CityConstants._();

  static const List<String> cityOptionKeys = [
    'city.moscow',
    'city.saintPetersburg',
    'city.kazan',
    'city.ekaterinburg',
    'city.novosibirsk',
    'city.nizhnyNovgorod',
    'city.krasnodar',
    'city.sochi',
    'city.other',
  ];

  static const List<String> cityOptions = [
    'Москва',
    'Санкт-Петербург',
    'Казань',
    'Екатеринбург',
    'Новосибирск',
    'Нижний Новгород',
    'Краснодар',
    'Сочи',
    'Другой город',
  ];

  // Legacy values can already be persisted in user profiles.
  static const Map<String, String> legacyRuLabelsByKey = {
    'city.moscow': 'Москва',
    'city.saintPetersburg': 'Санкт-Петербург',
    'city.kazan': 'Казань',
    'city.ekaterinburg': 'Екатеринбург',
    'city.novosibirsk': 'Новосибирск',
    'city.nizhnyNovgorod': 'Нижний Новгород',
    'city.krasnodar': 'Краснодар',
    'city.sochi': 'Сочи',
    'city.other': 'Другой город',
  };

  static const Map<String, String> enLabelsByKey = {
    'city.moscow': 'Moscow',
    'city.saintPetersburg': 'Saint Petersburg',
    'city.kazan': 'Kazan',
    'city.ekaterinburg': 'Yekaterinburg',
    'city.novosibirsk': 'Novosibirsk',
    'city.nizhnyNovgorod': 'Nizhny Novgorod',
    'city.krasnodar': 'Krasnodar',
    'city.sochi': 'Sochi',
    'city.other': 'Other city',
  };

  static const String defaultCityKey = 'city.moscow';

  static String legacyRuLabelByKey(String key) {
    return legacyRuLabelsByKey[key] ?? legacyRuLabelsByKey[defaultCityKey]!;
  }

  static String? cityKeyByStoredValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    if (cityOptionKeys.contains(normalized)) {
      return normalized;
    }

    for (final entry in legacyRuLabelsByKey.entries) {
      if (entry.value == normalized) {
        return entry.key;
      }
    }

    for (final entry in enLabelsByKey.entries) {
      if (entry.value == normalized) {
        return entry.key;
      }
    }

    return null;
  }

  static String toStoredLegacyValue(String value) {
    final normalized = value.trim();
    final key = cityKeyByStoredValue(normalized);
    if (key == null) {
      return normalized;
    }

    return legacyRuLabelByKey(key);
  }

  static String toLocalizedLabel({
    required String? storedValue,
    required String Function(String cityKey) localize,
    String? fallbackKey,
  }) {
    final key = cityKeyByStoredValue(storedValue);
    if (key != null) {
      return localize(key);
    }

    final normalized = storedValue?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }

    return localize(fallbackKey ?? defaultCityKey);
  }

  static bool matchesSelectedValue({
    required String cityKey,
    required String localizedLabel,
    required String? selectedValue,
  }) {
    final selectedKey = cityKeyByStoredValue(selectedValue);
    if (selectedKey != null) {
      return selectedKey == cityKey;
    }

    final normalized = selectedValue?.trim();
    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    return normalized == localizedLabel;
  }

  static String fallbackLegacyCity() {
    return legacyRuLabelByKey(defaultCityKey);
  }
}
