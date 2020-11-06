import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_flutter/components/rounded_button.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat_screen.dart';
import 'chat_wall_screen.dart';

class PictureScreen extends StatefulWidget {
  static String id = 'picture_screen';
  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  String imageUrl;
  bool isReady = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: Text('Pick a picture'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: [
                Flexible(
                  child: CircleAvatar(
                    radius: 150,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: (imageUrl == null)
                          ? Image.asset('images/blanprofile.png')
                          : Image.network(imageUrl),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                RoundedButton(
                  text: 'Dodaj Zdjecie Profilowe',
                  onPressed: () {
                    uploadImage();
                  },
                ),
                RoundedButton(
                  text: 'Dalej',
                  color: isReady ? Colors.deepOrange : Colors.grey[300],
                  onPressed: () {
                    // goto the next screen - adding photos
                    if (isReady) {
                      Navigator.pushReplacementNamed(
                          context, ChatWallScreen.id);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    //Check permissions
    var permissionStatus = await Permission.photos
        .request(); //it will ask for permissions if there is none
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            // save catalog: user_uid/profilePicture/imageName
            .child('${loggedUser.uid}/profilePicture/profileImage')
            .putFile(file)
            .onComplete;
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          isReady = true;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('GrantPermissions and try again');
    }
  }
}
