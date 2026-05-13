class UserModel {
  final String? uid;
  final String name;
  final String email;
  final String? profilePictureUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.profilePictureUrl,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePictureUrl: map['profilePictureUrl'],
    );
  }
}