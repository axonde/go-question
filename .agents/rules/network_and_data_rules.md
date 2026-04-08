---
trigger: always_on
---

# Network, Errors & Data Layer Rules

Слой Data в этом проекте подчиняется строгим правилам отказоустойчивости и обработки данных из Firebase.

## Проверка интернет-соединения
- **ВСЕГДА** инжектируй `NetworkInfo` в класс `...RepositoryImpl`.
- Перед выполнением любого внешнего сетевого запроса необходимо проверить коннект:
  ```dart
  if (!await networkInfo.isConnected) {
    return Result.failure(const Failure.network()); 
  }
