import '../constants/city_constants.dart';

abstract final class CityUtils {
  CityUtils._();

  static List<String> buildOptions(String? current, [Iterable<String>? extra]) {
    final result = <String>{...CityConstants.cityOptions};
    if (extra != null) {
      result.addAll(extra.where((city) => city.trim().isNotEmpty));
    }

    final normalizedCurrent = current?.trim();
    if (normalizedCurrent != null && normalizedCurrent.isNotEmpty) {
      result.add(normalizedCurrent);
    }

    return result.toList(growable: false);
  }

  static List<T> sortEventsByCityPriority<T>({
    required List<T> items,
    required String? city,
    required String Function(T item) locationOf,
    required DateTime Function(T item) startTimeOf,
  }) {
    final normalizedCity = city?.trim().toLowerCase();
    final sorted = [...items];
    sorted.sort((a, b) {
      final aPriority = _cityPriority(locationOf(a), normalizedCity);
      final bPriority = _cityPriority(locationOf(b), normalizedCity);
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }
      return startTimeOf(a).compareTo(startTimeOf(b));
    });
    return sorted;
  }

  static int _cityPriority(String location, String? normalizedCity) {
    if (normalizedCity == null || normalizedCity.isEmpty) {
      return 1;
    }
    return location.trim().toLowerCase() == normalizedCity ? 0 : 1;
  }
}
