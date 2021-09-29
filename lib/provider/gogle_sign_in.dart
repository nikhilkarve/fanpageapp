import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  var _userId;
  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    var test = await FirebaseAuth.instance.currentUser();
    _userId = test.uid;
    var nameFirstLast = _user.displayName.split(' ');
    await Firestore.instance.collection('users').document(_userId).setData({
      'first_name': nameFirstLast[0],
      'last_name': nameFirstLast[1],
      'email': _user.email,
      'role': 'user',
    });

    notifyListeners();
  }
}
