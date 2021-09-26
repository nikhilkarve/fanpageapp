import 'package:fanpage_app/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  // const AuthScreen({ Key? key }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _loadingScreen = false;
  void _submitUserDetails(String uEmail, String uPassword, String firstName,
      String lastName, bool loggedIn, BuildContext ctx) async {
    AuthResult authResult;

    try {
      setState(() {
        _loadingScreen = true;
      });
      if (loggedIn) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: uEmail, password: uPassword);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: uEmail, password: uPassword);

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'first_name': firstName,
          'last_name': lastName,
          'email': uEmail,
          'role': 'user',
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _loadingScreen = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitUserDetails,
        _loadingScreen,
      ),
    );
  }
}
