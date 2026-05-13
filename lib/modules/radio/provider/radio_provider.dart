import 'package:flutter/material.dart';
import 'package:informa2/modules/app/service/firestore_service.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';
import 'package:informa2/modules/radio/service/radio_service.dart';

class RadioProvider extends ChangeNotifier{
  RadioService _radioService = RadioService();
  FirestoreService _firestoreService = FirestoreService();
  List<RadioModel> _favoriteRadios = [];
  List<RadioModel> get favoriteRadios => _favoriteRadios;

  Future<void> addRadioToFavorites(String uid, RadioModel radio) async {
    try {
      await _firestoreService.addRadio(uid, radio);
      radio.isFavorite = true;
      _favoriteRadios.add(radio);
      notifyListeners();
    } catch (e) {
      print("Error al agregar radio a favoritos: $e");
    }
  }

  Future<void> removeRadioFromFavorites(String uid, RadioModel radio) async {
    try {
      await _firestoreService.deleteRadio(uid, radio.id.toString());
      radio.isFavorite = false;
      _favoriteRadios.removeWhere((r) => r.id == radio.id);
      notifyListeners();
    } catch (e) {
      print("Error al eliminar radio de favoritos: $e");
    }
  }

  Future<List<RadioModel>> getFavoriteRadios(String uid) async {
    try {
      List<RadioModel> favRadios = await _firestoreService.getRadiosFavorites(uid);
      return favRadios;
    } catch (e) {
      print("Error al obtener radios favoritos: $e");
      return [];
    }
  }

  Future<List<RadioModel>> getRadios() async {
    try {
      final radios = await _radioService.getRadios();
      return radios.map((r) => RadioModel.fromJson(r)).toList();
    } catch (e) {
      print("Error al obtener radios: $e");
      return [];
    }
  }
}