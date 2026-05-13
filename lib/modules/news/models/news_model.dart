import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String imageUrl;
  final String category;
  final DateTime dateTime;
  bool isFavorite;
  
  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.dateTime,
    this.isFavorite = false,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      excerpt: map['excerpt'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      dateTime: map['date'],
    );
  }

  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      excerpt: data['excerpt'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      isFavorite: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'imageUrl': imageUrl,
      'category': category,
      'dateTime': Timestamp.fromDate(dateTime),
      'isFavorite': isFavorite,
    };
  }
}