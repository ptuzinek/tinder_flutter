import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinder_flutter/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String imageUrl;
  final String uidClicked;
  final String name;

  UserData({this.imageUrl, this.uidClicked, this.name});
}

class ChatWallRow extends StatelessWidget {
  final String name;
  final String uidClickedUser;
  final String imageUrl;
  ChatWallRow({this.name, this.uidClickedUser, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    var userData =
        UserData(imageUrl: imageUrl, uidClicked: uidClickedUser, name: name);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          print('CLICKED USER UID: $uidClickedUser');
          Navigator.pushNamed(context, ChatScreen.id, arguments: userData);
        },
        child: Container(
          height: 80,
          child: ListTile(
            leading: CircleAvatar(
              // ToDo wyswietl zdjecie profilowe na scianie konwersacji
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: (imageUrl == null)
                    ? Image.asset('images/blanprofile.png')
                    : Image.network(imageUrl),
              ),
            ),
            title: Text(
              name,
            ),
          ),
        ),
      ),
    );
  }
}
