class EventEntity {
  final String id; // id события
  final String title; // название события
  final String description; // описание события
  final String imageUrl; // ссылка на изображение события
  final DateTime date; // дата события
  final String location; // место проведения события
  final String category; // категория события
  final double price; // цена билета
  final int participants; // количество участников
  final String organizer; // организатор события
  final String status; // статус события
  final DateTime createdAt; // дата создания события
  final DateTime updatedAt; // дата обновления события

  EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.category,
    required this.price,
    required this.participants,
    required this.organizer,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}