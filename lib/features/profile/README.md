# Profile Feature

Управление профилем пользователя, редактирование данных (включая аватары, соцсети, интересы) и сохранение в Firestore.

## Доменные сущности (Domain)
- **`UserEntity`**: Содержит всю информацию профиля.
  - Поля: `id`, `firstName`, `lastName`, `nickname`, `birthDate`, `city`, `email`, `avatarUrl`, `trophies`, `bio`, `socialLinks`, `interests`.

## Состояние и Кубиты (Presentation)
- **`ProfileCubit`**: 
  - `ProfileLoading`
  - `ProfileLoaded(UserEntity user)`
  - `ProfileError(String message)`
- *(Позже добавим методы загрузки и редактирования)*

## Репозитории (Domain / Data)
- **`IProfileRepository`**: Интерфейс для взаимодействия с Firebase (загрузка и обновление `UserEntity`).
- **`ProfileRepositoryImpl`**: Имплементация с обязательной проверкой `NetworkInfo`.
