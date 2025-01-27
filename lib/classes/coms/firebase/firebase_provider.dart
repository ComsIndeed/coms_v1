import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coms/classes/coms/terminal_provider.dart';
import 'package:coms/main_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class FirebaseProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get userDocument {
    if (auth.currentUser == null) throw Exception("USER IS NULL");
    final userDoc = firestore.collection("users").doc(auth.currentUser!.uid);
    return userDoc;
  }

  Future<void> reinitialize() async {
    try {
      if (auth.currentUser != null) {
        final currentUser = auth.currentUser!;

        _createUserData(currentUser.uid);
      }
    } catch (e, s) {
      _getTerminalProvider().add("$e, $s");
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
      notifyListeners();
      return auth.currentUser;
    } catch (e, s) {
      _getTerminalProvider().add("$e, $s");
      Fluttertoast.showToast(msg: "$e");
    }
    return null;
  }

  Future<void> signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    notifyListeners();
    Fluttertoast.showToast(msg: "Logged out");
  }

  // !                  FIRESTORE

  Future<void> _createUserData(String userId) async {
    try {
      final userCollection = firestore.collection('users');
      await userCollection.doc(userId).set({
        'metadata': {'lastModified': FieldValue.serverTimestamp()},
      });
    } catch (e, s) {
      _getTerminalProvider().add("$e, $s");
      Fluttertoast.showToast(msg: "$e");
    }
  }

  TerminalProvider _getTerminalProvider() {
    return Provider.of<TerminalProvider>(navigatorKey.currentContext!,
        listen: false);
  }
}
