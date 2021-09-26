import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  // const AuthForm({ Key? key }) : super(key: key);
  AuthForm(this.submitFn, this.loadingScreen);

  final bool loadingScreen;
  final void Function(String uEmail, String uPass, String uFname, String uLname,
      bool logIn, BuildContext context) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _globalFormKey = GlobalKey<FormState>();

  var _uEmail = '';
  var _uName = '';
  var _uLastName = '';
  var _uPassword = '';
  var _logInPage = true;

  void _formSubmit() {
    final formResult = _globalFormKey.currentState.validate();
    print(formResult);
    if (formResult) {
      _globalFormKey.currentState.save();
      widget.submitFn(_uEmail.trim(), _uPassword, _uName.trim(),
          _uLastName.trim(), _logInPage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      elevation: 20,
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _globalFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_logInPage)
                  TextFormField(
                    key: ValueKey('fname'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Your First Name',
                    ),
                    onSaved: (value) {
                      _uName = value;
                    },
                  ),
                if (!_logInPage)
                  TextFormField(
                    key: ValueKey('lname'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Your Last Name',
                    ),
                    onSaved: (value) {
                      _uLastName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid statement.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Your Email',
                  ),
                  onSaved: (value) {
                    _uEmail = value;
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      return 'Password must be at least 4 characters long';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  onSaved: (value) {
                    _uPassword = value;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 25),
                if (widget.loadingScreen) CircularProgressIndicator(),
                if (!widget.loadingScreen)
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 300),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).accentColor),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors.grey.withOpacity(0.04);
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed))
                              return Colors.grey.withOpacity(0.12);
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: _formSubmit,
                      child: Text(_logInPage ? 'Login' : 'Register'),
                    ),
                  ),
                if (_logInPage)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text('Don\'t have an account?'),
                  ),
                if (!widget.loadingScreen)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _logInPage = !_logInPage;
                      });
                      _formSubmit;
                    },
                    child:
                        Text(_logInPage ? 'Be a fan!' : 'I am already a fan!'),
                  )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
