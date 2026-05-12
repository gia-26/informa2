class UserModel {
  final String uid;
  final String email;

  UserModel({
    required this.uid,
    required this.email,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }
}