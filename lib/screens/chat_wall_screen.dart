import 'package:firebase_auth/firebase_auth.dart';
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

// TUTAJ BLAD BO NIE SKOPIOWALEM JESZCZE DANYCH UZYTKOWNIKA, WIEC NIE MA Z CZEGO BRAC DANYCH DO POPULOWANIA WIERSZY!!!!!!!!!!!!!!!!!!!!!!!!
  List<ChatWallRow> getAllMatches(AsyncSnapshot<QuerySnapshot> snapshot) {
    // ToDo tutaj powinien zwracać tylko tych uzytkownikow, z ktorymi jest match - oddzielna kolekcja dla danego uzytkownika
    return snapshot.data.docs
        .map((doc) => ChatWallRow(
              //Firestore.instance.collection('tournaments').doc(doc.reference.id).snapshots()
              // wez id dokumentu i znajdz taki w kolekcji details i wez ten dokumnt i pobierz z niego dane
              imageUrl: doc['photoUrl'],
              name: doc["name"],
              uidClickedUser: doc.reference.id,
            ))
        .toList();
  }
//   return snapshot.data.docs
//       .map((doc) => ChatWallRow(
//   imageUrl: doc[
//   'photoUrl'],
//   name: doc["name"],
//   uidClickedUser: doc.reference.id,
//   ))
//       .toList();
// }

  @override
  Widget build(BuildContext context) {
    print('Logged User uid: ${loggedUser.uid}');
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('details')
            .doc('${loggedUser.uid}')
            .collection('matches')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return new Text("There is no Matches");
          return new ListView(children: getAllMatches(snapshot));
        },
      ),
    );
  }
}
