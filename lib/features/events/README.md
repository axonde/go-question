# Модуль Events (Мероприятия) 📅

Этот модуль управляет жизненным циклом мероприятий: созданием, отображением списка и детальной информации.

## Технологии
- **Cloud Firestore**: Коллекция `events`.
- **Firebase Storage**: Хранение изображений карточек.
- **UUID**: Генерация уникальных идентификаторов.

## Структура (Clean Architecture)

- **Domain**:
  - `event_entity.dart`: Сущность мероприятия (id, title, description, date, location и др.).
- **Data**:
  - `event_model.dart`: Сериализация данных (fromFirestore/toMap).
  - `events_repository_impl.dart`: Логика CRUD операций.
- **Presentation**:
  - Слой UI для отображения списка и создания ивентов.

## Состояние БД (Поля EventEntity)
- `id`: String (UUID).
- `title`: String.
- `description`: String.
- `imageUrl`: String.
- `date`: DateTime.
- `location`: String.
- `category`: String ("Music", "Sport" и т.д.).
- `price`: double (0.0 — бесплатно).
- `organizer`: String (UID создателя).
- `status`: String ("active", "cancelled", "completed").
