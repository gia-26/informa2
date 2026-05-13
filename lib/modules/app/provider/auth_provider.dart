import 'package:informa2/modules/app/service/firebase_service.dart';
import 'package:informa2/modules/app/service/firestore_service.dart';
import 'package:informa2/modules/app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProviderApp with ChangeNotifier {
  //Variables privadas
  final _fbService = FirebaseService();
  final _fsService = FirestoreService();
  UserModel? _usuarioActual;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _errorMessage = '';

  //Getters
  UserModel? get usuarioActual => _usuarioActual;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) throw Exception("Rellene los espacios en blanco");
      UserCredential userCredential = await _fbService.iniciarSesion(email, password);
      _isLoggedIn = true;
      _usuarioActual = await _fsService.obtenerUsuario(userCredential.user!.uid);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoggedIn = false;

      // Guardar el error en la variable
      if (e.code == 'user-not-found') {
        _errorMessage = 'No existe una cuenta con ese email';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Contraseña incorrecta';
      } else if (e.code == 'invalid-credential') {
        _errorMessage = 'Email o contraseña incorrectos';
      } else if (e.code == 'invalid-email') {
        _errorMessage = 'El email no tiene un formato válido';
      } else {
        _errorMessage = 'Ocurrió un error inesperado: ${e.code}';
      }

      rethrow;
    } catch (e) {
      _isLoggedIn = false;
      _errorMessage = 'Error: ' + e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registrarUsuario(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty)  throw Exception("Rellene los espacios en blanco");
      
      UserCredential userCredential = await _fbService.registrarUsuario(email, password);
      
      _usuarioActual = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );
      
      await _fsService.agregarUsuario(_usuarioActual!);
      
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMessage = 'Ese email ya está registrado';
      } else if (e.code == 'weak-password') {
        _errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      } else if (e.code == 'invalid-email') {
        _errorMessage = 'El email no tiene un formato válido';
      } else {
        _errorMessage = 'Ocurrió un error inesperado: ${e}';
      }

      rethrow;
    } catch (e) {
      _errorMessage = 'Error: ' + e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void cerrarSesion() {
    _usuarioActual = null;
    _fbService.cerrarSesion();
    notifyListeners();
  }
}