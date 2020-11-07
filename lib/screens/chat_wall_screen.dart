import 'package:flutter/material.dart';
import 'package:tinder_flutter/components/chat_wall_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatWallScreen extends StatefulWidget {
  static String id = 'chat_wall_screen';
  @override
  _ChatWallScreenState createState() => _ChatWallScreenState();
}

class _ChatWallScreenState extends State<ChatWallScreen> {
  // ToDo pobrac liste uztkownikow i wyswietlic ją w widzetach
  final _firestore = FirebaseFirestore.instance;

  List<ChatWallRow> getAllUsers(AsyncSnapshot<QuerySnapshot> snapshot) {
    // ToDo tutaj powinien zwracać tylko tych uzytkownikow, z ktorymi jest match - oddzielna kolekcja dla danego uzytkownika
    return snapshot.data.docs
        .map((doc) => ChatWallRow(
              imageUrl: doc[
                  'photoUrl'], // ToDo dac tutaj jakies zabezpieczenie jakby uzytkownik nie mial zdjecia ale kazdy powinin miec
              name: doc["name"],
              uidClickedUser: doc.reference.id,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('details').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return new Text("There is no expense");
          return new ListView(children: getAllUsers(snapshot));
        },
      ),
    );
  }
}
