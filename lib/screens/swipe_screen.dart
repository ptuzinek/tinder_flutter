import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class SwipeScreen extends StatefulWidget {
  static String id = 'swipe_screen';
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  CardController controller;
  int buttonIndex = 0;
  List<String> profileImages = [
    'images/blanprofile.png',
    'images/Fish_logo.png',
  ];
  List<String> uidCurrentMatches = [];
  List<String> uidUsersToMatch = [];

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  User loggedUser;

  @override
  void initState() {
    super.initState();
    getUser();
    print('Current matches: $uidCurrentMatches');
    getUsersToMatch();
    print('Current matches: $uidCurrentMatches');
    addToMatchesOrSelections('Vh1BxaLQbCUAKK49Thnid8D7SSy1');
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

  void swipeLeft() {
    controller.triggerLeft();
  }

  void swipeRight() {
    controller.triggerRight();
  }

  void getUsersToMatch() async {
    // stworzyc liste zawierajaca wszystkie match'e
    print('Current matches: $uidCurrentMatches');
    await _firestore
        .collection('details')
        .doc('${loggedUser.uid}')
        .collection('matches')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                uidCurrentMatches.add(element.reference.id);
              })
            });
    print('Current matches: $uidCurrentMatches');
    // jesli uid istnieje w kolekcji matches to nie dodawaj jej do listy
    await _firestore.collection('details').get().then((value) => {
          value.docs.forEach((element) {
            // jesli lista match zawiera uid z kolekcji match
            if ((uidCurrentMatches != null) &&
                (uidCurrentMatches.contains(element.reference.id))) {
              // to nie wyswietlaj ich

            } else {
              // dodaj do listy uzytkownikow do wyswietlenia
              uidUsersToMatch.add(element.reference.id);
            }
          })
        });
    print('Users to display: $uidUsersToMatch');
  }

  void addToMatchesOrSelections(String uidSelectedUser) async {
    // Jesli tak to dodaj wybranego uzytkownika do kolekcji matches zalogowanego uzytkownika
    // oraz dodaj zalogowanego uzytkownika do kolekcji matches wybranego uzytkownika
    // Jesli nie to dodaj wybranego uzytkownika do kolekcji selections zalogowanego uzytkownika

    // wez dokument wybranego uzytkownika do skopiowania
    final selectedUser =
        await _firestore.collection("details").doc('$uidSelectedUser').get();
    print('wez dokument uzytkownika do skopiowania ${selectedUser.data()}');
    // sprawdz czy zalogowany uzytkownik jest w kolekcji selections wybranego użytkownika
    final snapshot = await _firestore
        .collection('details')
        .doc('$uidSelectedUser')
        .collection('selections')
        .doc('${loggedUser.uid}')
        .get();
    print('snapshot.exists:  ${snapshot.exists}');
    bool check = snapshot != null;
    print('snapshot != null:  $check');
    if (snapshot.exists || snapshot != null) {
      // TUTAJ TEZ USUNAC ZALOGOWANEGO UZYTKOWNIKA Z LISTY SELECTED WYBRANEGO UZYTKOWNIKA
      // umiesc wybranego użytkownika w kolekcji matches zalogowanego uzytkownika
      await _firestore
          .collection('details')
          .doc('${loggedUser.uid}')
          .collection('matches')
          .doc('$uidSelectedUser')
          .set(selectedUser.data());
      print(
          'Umieszczono wybranego użytkownika w kolekcji MATCHES zalogowanego uzytkownika ');
      // umiesc zalogowanego uzytkownika w kolekcji matches wybranego użytkownika
      // wez dokument uzytkownika do skopiowania
      final currentUser =
          await _firestore.collection("details").doc('${loggedUser.uid}').get();
      await _firestore
          .collection('details')
          .doc('$uidSelectedUser')
          .collection('matches')
          .doc('${loggedUser.uid}')
          .set(currentUser.data());
      print(
          'umieszczono zalogowanego uzytkownika w kolekcji MATCHES wybranego użytkownika');
    } else {
      // umiesc wybranego użytkownika w kolekcji selections zalogowanego uzytkownika
      await _firestore
          .collection('details')
          .doc('${loggedUser.uid}')
          .collection('selections')
          .doc('$uidSelectedUser')
          .set(selectedUser.data());
      print(
          'umieszczono wybranego użytkownika w kolekcji SELECTIONS zalogowanego uzytkownika');
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = CardController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: TinderSwapCard(
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {
                print('SWIPE ORIENTATION: $orientation');
                print('SWIPE INDEX $index');
              },
              allowVerticalMovement: false,
              cardController: controller,
              totalNum: 2,
              stackNum: 2,
              maxHeight: MediaQuery.of(context).size.width * 0.9,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,
              swipeEdge: 4.0,
              orientation: AmassOrientation.bottom,
              cardBuilder: (BuildContext context, int index) => Card(
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Image.asset('${profileImages[index]}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            heroTag: getButtonIndex(),
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close),
                            onPressed: () {
                              swipeLeft();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            heroTag: getButtonIndex(),
                            backgroundColor: Colors.green,
                            child: Icon(Icons.check),
                            onPressed: () {
                              swipeRight();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //cardController: controller = CardController(),
            ),
          ),
        ),
      ),
    );
  }

  String getButtonIndex() {
    return (buttonIndex++).toString();
  }
}
