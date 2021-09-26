import 'package:fanpage_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'message_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    _navigatehome();
  }

  _navigatehome() async {
    await Future.delayed(Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  // userDocument = userSnapshot.data.data();

                  return MessageScreen();
                }
                return AuthScreen();
              }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Image.asset('assets/img/meghalaya.jpg')));
  }
}
