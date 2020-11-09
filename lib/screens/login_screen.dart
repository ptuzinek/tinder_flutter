import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tinder_flutter/components/rounded_button.dart';
import 'package:tinder_flutter/components/rounded_text_field.dart';
import 'package:tinder_flutter/screens/swipe_screen.dart';

import 'chat_screen.dart';
import 'chat_wall_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/Fish_logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  RoundedTextField(
                    hintText: 'Wprowadz swoj email',
                    onChanged: (value) {
                      email = value.trim();
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RoundedTextField(
                    hintText: 'Podaj haslo',
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    text: 'Log in',
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (UserCredential != null) {
                          Navigator.pushReplacementNamed(
                              context, SwipeScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
