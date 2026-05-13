import 'package:cloud_firestore/cloud_firestore.dart';

class RadioModel {
  final int id;
  final String name;
  final String frequency;
  final String imageUrl;
  final String slogan;
  final String streamingUrl;
  final String acronimo;
  final String category;
  bool isFavorite;

  RadioModel({
    required this.id,
    required this.name,
    required this.frequency,
    required this.imageUrl,
    required this.category,
    required this.slogan,
    required this.streamingUrl,
    required this.acronimo,
    this.isFavorite = false,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    //['stations'][0]
    return RadioModel(
      id: json['id'] ?? 0,
      name: json['program_name'] ?? '',
      frequency: json['stations'][0]['station_frequency'] ?? '',
      imageUrl: json['stations'][0]['station_image'] ?? '',
      slogan: json['stations'][0]['station_slogan'] ?? '',
      streamingUrl: json['stations'][0]['station_streaming'] ?? '',
      acronimo: json['stations'][0]['station_acronym'] ?? '',
      category: json['category'][0]['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'imageUrl': imageUrl,
      'slogan': slogan,
      'streamingUrl': streamingUrl,
      'acronimo': acronimo,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  factory RadioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RadioModel(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      frequency: data['frequency'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      slogan: data['slogan'] ?? '',
      streamingUrl: data['streamingUrl'] ?? '',
      acronimo: data['acronimo'] ?? '',
      category: data['category'] ?? '',
      isFavorite: true,
    );
  }
}