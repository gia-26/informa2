import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:informa2/modules/app/models/user_model.dart';

class FirestoreService {
  FirebaseFirestore fbFirestore = FirebaseFirestore.instance;

  Future<void> agregarUsuario(UserModel user) {
    return fbFirestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
      });
  }

  Future<UserModel?> obtenerUsuario(String uid) async {
    DocumentSnapshot doc = await fbFirestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}