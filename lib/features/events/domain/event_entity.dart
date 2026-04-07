class EventEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startTime; // время начала
  final String location;
  final String category;
  final double price; // средний чек / цена входа
  final int maxUsers; // максимальное кол-во участников
  final int participants; // текущее кол-во участников
  final String organizer;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startTime,
    required this.location,
    required this.category,
    required this.price,
    required this.maxUsers,
    required this.participants,
    required this.organizer,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
