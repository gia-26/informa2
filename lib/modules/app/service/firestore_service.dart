import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:informa2/modules/app/models/user_model.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:informa2/modules/radio/models/program_model.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';

class FirestoreService {
  FirebaseFirestore fbFirestore = FirebaseFirestore.instance;

  Future<void> agregarUsuario(UserModel user) {
    return fbFirestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': user.name,
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

  Future<void> addNews(String uid, NewsModel news) {
    return 
    fbFirestore
      .collection('users')
      .doc(uid)
      .collection('fav_news')
      .doc(news.id.toString())
      .set(news.toMap());
  }

  Future<void> deleteNews(String uid, String newId) {
    return fbFirestore
      .collection('users')
      .doc(uid)
      .collection('fav_news')
      .doc(newId)
      .delete();
  }

  Future<void> addRadio(String uid, RadioModel radio) {
    return fbFirestore
      .collection('users')
      .doc(uid)
      .collection('fav_radios')
      .doc(radio.id.toString())
      .set(radio.toMap());
  }

  Future<void> deleteRadio(String uid, String radioId) {
    return fbFirestore
      .collection('users')
      .doc(uid)
      .collection('fav_radios')
      .doc(radioId)
      .delete();
  }

  Future<void> addProgram(String uid, ProgramModel program) {
    return fbFirestore
      .collection('users')
      .doc(uid)
      .collection('fav_programs')
      .doc(program.id.toString())
      .set(program.toMap());
  }

  Future<void> deleteProgram(String uid, String programId) {
    return fbFirestore
      .collection('users')
      .doc(uid)
      .collection('fav_programs')
      .doc(programId)
      .delete();
  }

  Future<List<NewsModel>> getNewsFavorites(String uid) async {
    QuerySnapshot snapshot = await fbFirestore
        .collection('users')
        .doc(uid)
        .collection('fav_news')
        .get();

    return snapshot.docs.map((doc) {
      final news = NewsModel.fromFirestore(doc);
      return news;
    }).toList();
  }

  Future<List<RadioModel>> getRadiosFavorites(String uid) async {
    QuerySnapshot snapshot = await fbFirestore
        .collection('users')
        .doc(uid)
        .collection('fav_radios')
        .get();

    return snapshot.docs.map((doc) {
      final radio = RadioModel.fromFirestore(doc);
      return radio;
    }).toList();
  }

  Future<List<ProgramModel>> getProgramsFavorites(String uid) async {
    QuerySnapshot snapshot = await fbFirestore
        .collection('users')
        .doc(uid)
        .collection('fav_programs')
        .get();

    return snapshot.docs.map((doc) {
      final program = ProgramModel.fromFirestore(doc);
      return program;
    }).toList();
  }
}