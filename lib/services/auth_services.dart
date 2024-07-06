import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Register user with email and password
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Registration Error: $e');
      return null;
    }
  }

  // Login user with email and password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Check if a user is currently logged in
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  // Get the current user object
  User? get currentUser => _firebaseAuth.currentUser;
}
