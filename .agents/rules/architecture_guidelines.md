---
trigger: always_on
description: Специфичные стандарты Clean Architecture, структура файлов и слоёв, принятые в этом проекте
---

# Clean Architecture & Naming Guidelines

При разработке или модификации фичей в `lib/features/...` строго соблюдай следующие стандарты:

## Структура директорий внутри фичи
- **`domain/`**:
  - `entities/` — бизнес-модели. СТРОГО использовать `@freezed`.
  - `repositories/` — интерфейсы репозиториев (начинаются с префикса `I`, например `IAuthRepository`).
  - `errors/` — мапперы ошибок и кастомные Failure (например, `AuthFailure`).
- **`data/`**:
  - `repositories/` — реализация (суффикс `_repository_impl.dart`).
  - `source/` — удаленные и локальные дата-сорсы (например, Firebase DataSource).
- **`presentation/`**:
  - `cubit/` — логика слоев, предпочитаем Cubit вместо чистого BLoC для большинства экранов. Завершается на `_cubit.dart` и `_state.dart`.
  - `pages/` — экраны фичи (суффикс `_page.dart` или `_screen.dart`).
  - `widgets/` — приватные UI-компоненты фичи.

## Паттерны состояний и сущностей
- Все доменные модели и стейты Cubit должны быть value-type. Если используем генерацию, используем связку `@freezed` и `@JsonSerializable`. 
- Не забывай самостоятельно выполнять генерацию кода: `dart run build_runner build --delete-conflicting-outputs` после создания/изменения файлов.

## Центральный DI
- Все зависимости регистрируются в `lib/injection_container/injection_container.dart`.
- Кубиты регистрируются через `sl.registerFactory(...)`.
- Репозитории и Data Source регистрируются через `sl.registerLazySingleton(...)`.
- Никогда не инициализируй `FirebaseFirestore`, `FirebaseAuth` или сторонние библиотеки напрямую в коде, забирай их через `sl()`.
