import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String category;
  final String title;
  final String place;
  final String city;
  final String date;
  final String time;
  final String text;
  final List<String> images;
  final Timestamp? timestamp;

  Event({
    required this.id,
    required this.category,
    required this.title,
    required this.place,
    required this.city,
    required this.date,
    required this.time,
    required this.text,
    required this.images,
    required this.timestamp,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      place: data['place'] ?? '',
      city: data['city'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      text: data['text'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      timestamp: data['timestamp'],
    );
  }
}
