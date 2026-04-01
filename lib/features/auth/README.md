# Модуль Авторизации (Auth Feature)

Данный модуль содержит бизнес-логику для Firebase логина и регистрации по Email и Паролю, а также отвечает за проверку наличия интернета перед отправкой запросов.

## Сущность (Что мы храним): `UserEntity`
- `id` (String) — Уникальный идентификатор (UID) пользователя из Firebase.
- `email` (String) — Почта пользователя.

---

## 🛠 Как использовать в UI (Гайд для верстальщика)

Вся логика инкапсулирована внутри класса `AuthCubit` (State Management). Тебе не нужно вызывать репозитории или FirebaseAuth напрямую. 

### 1. Подключение к UI (BlocConsumer)
Оберни экран авторизации в `BlocConsumer<AuthCubit, AuthState>`, чтобы реагировать на изменения:

```dart
BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      // Автоматическая подстановка текста ошибки с бэкенда (нет сети, неверный пароль)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
    } else if (state is AuthAuthenticated) {
      // Пользователь залогинился! Можно делать навигацию на Главный экран
      // state.userId и state.email доступны прямо здесь
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) {
      // Покажи CircularProgressIndicator() поверх кнопки или в центре экрана
    }
    // В дефолтном состоянии отдай форму (TextField для почты и пароля)
    return YourLoginFormWidget(); 
  }
)
```

### 2. Запуск методов (Действия по клику)
Вызывай эти функции при нажатии на твои UI кнопки:

- **Авторизация**: 
  `context.read<AuthCubit>().signIn(emailController.text, passwordController.text);`

- **Регистрация**: 
  `context.read<AuthCubit>().signUp(emailController.text, passwordController.text);`

- **Выход из аккаунта (Где-то в профиле)**: 
  `context.read<AuthCubit>().signOut();`

> **Примечание по Авто-логину**: Метод `checkAuthStatus()` уже вызывается при старте приложения в `main.dart`. Он проверяет кэш Firebase. Если сессия активна, кубит сам бросит стейт `AuthAuthenticated` и экран моментально перекинет тебя внутрь приложения без показа форм.
