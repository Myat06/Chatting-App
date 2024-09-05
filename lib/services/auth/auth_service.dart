import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //for store data in firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    // try sign in user
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    //catch errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, password, name, phone) async {
    // try sign in user
    try {
      //create user
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //for addin user to firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phoneno': phone,
        'uid': userCredential.user!.uid
      });

      return userCredential;
    }
    //catch errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> singOut() async {
    return await _firebaseAuth.signOut();
  }

  //delete account
  Future<void> deleteAccount() async {
    User? user = getCurrentUser();

    if (user != null) {
      //delete the user's data from firestore
      await _firestore.collection('users').doc(user.uid).delete();

      //delete the user's auth service
      await user.delete();
    }
  }

  //posssible error message
}
