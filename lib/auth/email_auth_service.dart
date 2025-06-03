import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Register error: $e");
      return null;
    }
  }

  // Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
