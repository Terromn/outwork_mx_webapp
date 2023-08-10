import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      DocumentReference userRef = usersCollection.doc(uid);

      await userRef.set({
        'name': name,
        'reservedClasses': [],
        'creditsAvailable': 0,
        'profilePicture': '${Random().nextInt(6)}.png',
      });
    } else {
      return;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String? getCurrentUserUID() {
    return currentUser?.uid;
  }
}
