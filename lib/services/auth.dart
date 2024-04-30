import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  Stream<User?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((event) {
      _user = event;
      return event;
    });
  }

  User? get currentUser {
    return _user;
  }

  Future<void> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      _user = result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  void signOut() {
    _firebaseAuth.signOut();
    notifyListeners();
  }
}
