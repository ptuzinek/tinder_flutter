import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_flutter/components/rounded_button.dart';
import 'package:tinder_flutter/components/rounded_text_field.dart';
import 'package:tinder_flutter/screens/picture_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinder_flutter/services/database_service.dart';

class ProfileInfoScreen extends StatefulWidget {
  static String id = 'profile_info_screen';
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  bool isFemale = false;
  bool isMale = false;
  bool isNext = false;
  bool isReady = false;
  String name;
  String email;
  String age;
  String gender;
  String school;
  String aboutMe;
  final _auth = FirebaseAuth.instance;
  User loggedUser;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void checkIfReady() {
    if (name != null && age != null && gender != null) {
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
                hintText: 'Imie',
                onChanged: (value) {
                  name = value;
                  if (name.length == 0) {
                    name = null;
                  }
                  checkIfReady();
                },
              ),
              RoundedTextField(
                hintText: 'Wiek',
                onChanged: (value) {
                  age = value;
                  if (age.length == 0) {
                    age = null;
                  }
                  checkIfReady();
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                      color: isFemale ? Colors.deepOrange : Colors.grey[300],
                      textColor: isFemale ? Colors.white70 : Colors.black45,
                      text: 'Kobieta',
                      onPressed: () {
                        setState(() {
                          isFemale = !isFemale;
                          if (isMale) isMale = !isMale;
                          if (isFemale) gender = 'female';
                          if (isMale == false && isFemale == false) {
                            gender = null;
                          }
                          checkIfReady();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RoundedButton(
                      color: isMale ? Colors.deepOrange : Colors.grey[300],
                      textColor: isMale ? Colors.white70 : Colors.black45,
                      text: 'Mezczyzna',
                      onPressed: () {
                        setState(() {
                          isMale = !isMale;
                          if (isFemale) isFemale = !isFemale;
                          if (isMale) gender = 'male';
                          if (isMale == false && isFemale == false) {
                            gender = null;
                          }
                          checkIfReady();
                        });
                      },
                    ),
                  ),
                ],
              ),
              RoundedTextField(
                hintText: 'Szkola',
                onChanged: (value) {
                  school = value;
                },
              ),
              RoundedTextField(
                hintText: 'O Mnie...',
                maxLines: 6,
                onChanged: (value) {
                  aboutMe = value;
                },
              ),
              SizedBox(
                height: 25,
              ),
              RoundedButton(
                text: 'Dalej',
                color: isReady ? Colors.deepOrange : Colors.grey[300],
                onPressed: () async {
                  // Get user and update his data
                  await DatabaseService(uid: loggedUser.uid)
                      .setUserData(name, age, loggedUser.email);
                  // goto the next screen - adding photos
                  if (isReady) {
                    Navigator.pushNamed(context, PictureScreen.id);
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
