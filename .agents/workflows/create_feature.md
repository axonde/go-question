---
description: Строгий алгоритм создания новой корневой фичи с нуля с соблюдением Clean Architecture.
---

# Создание Новой Фичи в Clean Architecture
**Запуск процесса:** Прочитай описание задачи от пользователя и следуй этим шагам по порядку:
1. **Создание директории и README (Обязательно!)**
   - Создай папку `lib/features/<имя_фичи>/`.
   - Создай `lib/features/<имя_фичи>/README.md`.
   - Опиши слои, названия будущих сущностей, методы интерфейса репозитория и состояния Cubit. Это будет наш план.
2. **Создание структуры**
   - Сгенерируй пустые папки: `domain/entities`, `domain/repositories`, `data/repositories`, `data/source`, `presentation/cubit`, `presentation/pages`.
3. **Слой Domain**
   - Напиши сущности в `domain/entities` используя `@freezed`.
   - Разработай контракт `domain/repositories/i_<feature_name>_repository.dart` со всеми методами и обёртками `Result<T, Failure>`.
4. **Слой Data**
   - Напиши `<feature_name>_remote_data_source.dart`.
   - Сделай реализацию `<feature_name>_repository_impl.dart`, обязательно внедри туда проверку через `NetworkInfo`.
5. **Слой Presentation**
   - Напиши `<feature_name>_state.dart` и `<feature_name>_cubit.dart`.
   - Реализуй вызовы репозитория с обработкой состояния (`Loading`, `Success`, `Error`).
6. **Внедрение зависимостей (DI)**
   - Добавь регистрации новых DataSource, RepositoryImpl и Cubit в `lib/injection_container/injection_container.dart`.
7. **Завершение**
   - Запусти `dart run build_runner build --delete-conflicting-outputs`.
   - Доложи пользователю и обнови `README.md` фичи.