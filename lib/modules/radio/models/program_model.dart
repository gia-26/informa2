import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramModel {
  final int id;
  final String program_icon;
  final String program_name;
  bool isFavorite;

  ProgramModel({
    required this.id,
    required this.program_icon,
    required this.program_name,
    this.isFavorite = false,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] ?? 0,
      program_icon: json['program_icon'] ?? '',
      program_name: json['program_name'] ?? '',
    );
  }

  factory ProgramModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgramModel(
      id: data['id'] ?? 0,
      program_icon: data['program_icon'] ?? '',
      program_name: data['program_name'] ?? '',
      isFavorite: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'program_icon': program_icon,
      'program_name': program_name,
      'isFavorite': isFavorite,
    };
  }
}