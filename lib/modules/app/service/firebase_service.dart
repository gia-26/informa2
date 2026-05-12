
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> iniciarSesion(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registrarUsuario(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> cerrarSesion() {
    return _auth.signOut();
  }
}