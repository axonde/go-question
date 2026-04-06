# Feature: Auth

Модуль аутентификации пользователей через Firebase (Email/Password, Google).

## Архитектура (Clean Architecture)

- **Presentation**: `AuthCubit` управляет состояниями экрана входа и регистрации.
- **Domain**: Сущности `RegistrationInput`, репозиторий `IAuthRepository`.
- **Data**: `AuthRepositoryImpl` с проверкой `NetworkInfo`, `AuthRemoteDataSource` (Firebase Auth).

## Состояния (States - AuthCubit)

- `AuthInitial`: Начальное состояние (не авторизован).
- `AuthLoading`: Процесс загрузки (вход/регистрация).
- `AuthAuthenticated`: Успешная авторизация (хранит `RegistrationInput`).
- `AuthAwaitingVerification`: Ожидание подтверждения Email.
- `AuthError`: Ошибка (хранит сообщение).

## База данных (Firebase Auth / Firestore)

- Используется стандартный `FirebaseAuth`.
- Дополнительные данные пользователя могут храниться в коллекции `users` (в планах).

## Логика Connectivity

Перед каждым запросом к Firebase в `AuthRepositoryImpl` проверяется наличие интернет-соединения через `NetworkInfo`. Если соединения нет, возвращается `AuthFailure(AuthFailureType.network)`.
