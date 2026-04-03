import 'package:go_question/features/events/domain/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.date,
    required super.location,
    required super.category,
    required super.price,
    required super.participants,
    required super.organizer,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      date: entity.date,
      location: entity.location,
      category: entity.category,
      price: entity.price,
      participants: entity.participants,
      organizer: entity.organizer,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory EventModel.fromMap(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      date: json['date'].toDate(),
      location: json['location'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      participants: json['participants'],
      organizer: json['organizer'],
      status: json['status'],
      createdAt: json['createdAt'].toDate(),
      updatedAt: json['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'category': category,
      'price': price,
      'participants': participants,
      'organizer': organizer,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
