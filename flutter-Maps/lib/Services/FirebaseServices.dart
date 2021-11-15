import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  // ignore: deprecated_member_use
  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser).uid;
  }

  Future<String> signUp(String email, String password, String placa,
      String name, String vehi, String phone) async {
    try {
      print(email);
      print(password);
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await updateUserName(name, authResult.user);

      final ref = FirebaseStorage.instance.ref().child('PeopleIcon.png');

      var url = await ref.getDownloadURL();

      var status = await OneSignal.shared.getPermissionSubscriptionState();
      String tokenId = status.subscriptionStatus.userId;

      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        "name": name,
        "celular": phone,
        "email": email,
        "vehiculo": vehi,
        "placa": placa,
        "UserID": FirebaseAuth.instance.currentUser.uid,
        "password": password,
        "image": url,
        "tokenId": tokenId
      }).then((_) {
        print("Success!");
      });
      return "Signed UP";
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message);
    }
  }

  Future<String> createReservation(String idParking, String idUser,
      String vehiculo, String placa, String datetime, String hora) async {
    try {
      String idRes = firestoreInstance.collection("Reservations").doc().id;
      firestoreInstance.collection("Reservations").doc(idRes).set({
        "Estado": "nueva",
        "IDParking": idParking,
        "IDUser": idUser,
        "vehiculo": vehiculo,
        "placa": placa,
        "reserID": idRes,
        "Time": datetime,
        "Hora": hora,
      }).then((_) {
        print("Success!");
      });
      return "Reservado";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return Future.error(e.message);
    }
  }

  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future updateUserName(String name, User currentUser) async {
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  // Email & Password Sign In

  Future signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message.toString());
    }
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }
}
