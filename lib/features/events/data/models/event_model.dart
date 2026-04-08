import 'package:go_question/features/events/domain/entities/event_entity.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String location;
  final String category;
  final double price;
  final int participants;
  final String organizer;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
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

  EventEntity toEntity() {
    return EventEntity(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      date: date,
      location: location,
      category: category,
      price: price,
      participants: participants,
      organizer: organizer,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
