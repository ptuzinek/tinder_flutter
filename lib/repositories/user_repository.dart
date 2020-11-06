import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Constructor - if passed Firebase instance is null, it will create one
  UserRepository({
    FirebaseAuth firebaseAuth,
    FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // sign in method using email and password
  void signInWithEmail(String email, String password) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // check if user uid was created for that email
  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });
    return exist;
  }

  // create the account
  Future<void> signUpWithEmail(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // check if user is signed in
  Future<bool> isSingedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  String getUser() {
    return _firebaseAuth.currentUser.uid;
  }

  // profile setup

}
