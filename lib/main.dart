// ignore_for_file: deprecated_member_use

import 'package:fanpage_app/provider/gogle_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import './screens/splash.dart';

void main() => runApp(FanApp());

class FanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          title: 'FlutterChat',
          theme: ThemeData(
              primarySwatch: Colors.grey,
              backgroundColor: Colors.grey,
              accentColor: Color.fromRGBO(1, 1, 1, 1),
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Colors.grey,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
          home: Splash()
          // StreamBuilder(
          //     stream: FirebaseAuth.instance.onAuthStateChanged,
          //     builder: (ctx, userSnapshot) {
          //       if (userSnapshot.hasData) {
          //         return MessageScreen();
          //       }
          //       return Splash();
          //     }),
          ),
    );
  }
}
