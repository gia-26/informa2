
import 'package:flutter/material.dart';
import 'package:informa2/modules/app/service/firestore_service.dart';
import 'package:informa2/modules/radio/models/program_model.dart';
import 'package:informa2/modules/radio/service/program_service.dart';

class ProgramProvider extends ChangeNotifier {

  ProgramsService programService = ProgramsService();
  FirestoreService _firestoreService = FirestoreService();
  List<ProgramModel> _favoritePrograms = [];
  List<ProgramModel> get favoritePrograms => _favoritePrograms;

  Future<void> addProgramToFavorites(String uid, ProgramModel program) async {
    try {
      await _firestoreService.addProgram(uid, program);
      program.isFavorite = true;
      _favoritePrograms.add(program);
      notifyListeners();
    } catch (e) {
      print("Error al agregar programa a favoritos: $e");
    }
  }

  Future<void> removeProgramFromFavorites(String uid, ProgramModel program) async {
    try {
      await _firestoreService.deleteProgram(uid, program.id.toString());
      program.isFavorite = false;
      _favoritePrograms.removeWhere((p) => p.id == program.id);
      notifyListeners();
    } catch (e) {
      print("Error al eliminar programa de favoritos: $e");
    }
  }

  Future<List<ProgramModel>> getFavoritePrograms(String uid) async {
    try {
      List<ProgramModel> favPrograms = await _firestoreService.getProgramsFavorites(uid);
      return favPrograms;
    } catch (e) {
      print("Error al obtener programas favoritos: $e");
      return [];
    }
  }

  Future<List<ProgramModel>> getPrograms() async {
    try {
      final programsData = await programService.getPrograms();
      return programsData.map((data) => ProgramModel.fromJson(data)).toList();
    } catch (e) {
      print("Error al obtener programas: $e");
      return [];
    }
  }
}