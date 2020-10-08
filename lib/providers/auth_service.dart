import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  FirebaseApp get app => _auth.app;
  Stream<User> get currentUser => _auth.authStateChanges();
  Future<dynamic> signInWithCredential(AuthCredential credential) async =>
      await _auth.signInWithCredential(credential);
  Future<void> logout() => _auth.signOut();
}
