import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_flutter/components/rounded_button.dart';
import 'package:tinder_flutter/components/rounded_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinder_flutter/screens/chat_screen.dart';
import 'package:tinder_flutter/screens/profile_info.dart';
import 'package:tinder_flutter/services/database_service.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool isReady = false;

  void checkIfReady() {
    if (email != null && password != null) {
      setState(() {
        isReady = true;
      });
    } else {
      setState(() {
        isReady = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: Text('Rejestracja'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              RoundedTextField(
                hintText: 'email',
                onChanged: (value) {
                  email = value.trim();
                  if (email.length == 0) {
                    email = null;
                  }
                  checkIfReady();
                },
              ),
              RoundedTextField(
                hintText: 'haslo',
                onChanged: (value) {
                  password = value;
                  if (password.length == 0) {
                    password = null;
                  }
                  checkIfReady();
                },
              ),
              SizedBox(
                height: 25,
              ),
              RoundedButton(
                text: 'Dalej',
                color: isReady ? Colors.deepOrange : Colors.grey[300],
                onPressed: () async {
                  // Register user
                  try {
                    final result = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    User user = result.user;

                    // create a new document for the new user with uid
                    await DatabaseService(uid: user.uid)
                        .updateUserData('name', 'age', 'email');

                    // goto the next screen - adding photos
                    if (isReady && result != null) {
                      print('Navigator.push called');
                      Navigator.pushReplacementNamed(
                          context, ProfileInfoScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
