import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_flutter/constants.dart';
import 'package:tinder_flutter/screens/chat_wall_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String messageText;

  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {}
    }
  }

  void getUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        print('PRINT UID OF CURRENT USER:  ${loggedUser.uid}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uidClickedUser = ModalRoute.of(context)
        .settings
        .arguments; // tutaj przychodzi informacja o wybranym uzytkowniku do chatu, trzeba ja przeslac do widgetu nizej - MessagesStream, zeby dobry czat sciagnal
    print('PRINT UID OF RECEIVER: $uidClickedUser');

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStream(
              uidClickedUser: uidClickedUser,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore
                          .collection('details')
                          .doc('${loggedUser.uid}')
                          .collection('chats')
                          .doc(
                              '$uidClickedUser') // kazdy czat mial swoj unikalny id - info z kim dana konwersacja
                          .collection('messages')
                          .add({
                        'text': messageText,
                        'sender': loggedUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      if (loggedUser.uid != uidClickedUser) {
                        _firestore
                            .collection('details')
                            .doc('$uidClickedUser')
                            .collection('chats')
                            .doc(
                                '${loggedUser.uid}') // kazdy czat mial swoj unikalny id - info z kim dana konwersacja
                            .collection('messages')
                            .add({
                          'text': messageText,
                          'sender': loggedUser.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String messageSender;
  final bool isMe;

  const MessageBubble({this.messageText, this.messageSender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            'sender: $messageSender',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
            ),
          ),
          Material(
            color: isMe ? Colors.orangeAccent : Colors.grey[300],
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$messageText',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String uidClickedUser;

  MessagesStream({this.uidClickedUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('details')
          .doc('${loggedUser.uid}')
          .collection('chats')
          .doc(
              '$uidClickedUser') // wczyta konwersacje z uzytkownikiem jaki zostal klikniety w ChatWall i stamtad przyjdzie informacja
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageWidgets = [];
        if (snapshot.hasData) {
          final messages = snapshot.data.docs;
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = loggedUser.email;
            final messageWidget = MessageBubble(
                isMe: (currentUser == messageSender),
                messageText: messageText,
                messageSender: messageSender);
            messageWidgets.add(messageWidget);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.all(10),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
