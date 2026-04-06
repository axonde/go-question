import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const UserEntity._(); // Необходим для геттеров/кастомных методов

  const factory UserEntity({
    required String id,             // ID из Firebase Auth
    
    // Личная информация
    required String firstName,      // Имя
    required String lastName,       // Фамилия
    required String nickname,       // Никнейм (@max_maximov)
    DateTime? birthDate,            // Дата рождения
    String? city,                   // Город
    
    // Детали профиля (Bio, Интересы)
    String? bio,                           // Небольшое описание профиля
    @Default([]) List<String> interests,   // Интересы
    
    // Социальные сети
    // Ключ - название соцсети (например, 'vk', 'telegram', 'instagram'), Значение - ссылка
    @Default({}) Map<String, String> socialLinks,
    
    // Контакты
    required String email,          // Email
    
    // Игровые/приложенческие статы
    String? avatarUrl,              // Ссылка на фото
    @Default(0) int trophies,       // Количество кубков
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  // Хелпер: Получение полного имени
  String get fullName => '$firstName $lastName'.trim();

  // Хелпер: Возраст
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month || 
       (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }
}
