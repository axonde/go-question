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

  static const String defaultCityKey = 'city.moscow';

  static String legacyRuLabelByKey(String key) {
    return legacyRuLabelsByKey[key] ?? legacyRuLabelsByKey[defaultCityKey]!;
  }

  static bool matchesSelectedValue({
    required String cityKey,
    required String localizedLabel,
    required String? selectedValue,
  }) {
    if (selectedValue == null) {
      return false;
    }

    final normalized = selectedValue.trim();
    return normalized == localizedLabel ||
        normalized == legacyRuLabelByKey(cityKey);
  }

  static String fallbackLegacyCity() {
    return legacyRuLabelByKey(defaultCityKey);
  }
}
