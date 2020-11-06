import 'package:flutter/material.dart';
import 'package:tinder_flutter/screens/chat_screen.dart';

class ChatWallRow extends StatelessWidget {
  final String text;
  final String uidReceiver;
  ChatWallRow({this.text, this.uidReceiver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          print('CLICKED USER UID: $uidReceiver');
          Navigator.pushNamed(context, ChatScreen.id, arguments: uidReceiver);
        },
        child: Container(
          height: 80,
          child: ListTile(
            leading: CircleAvatar(
              child: Image.asset('images/blanprofile.png'),
            ),
            title: Text(
              text,
            ),
          ),
        ),
      ),
    );
  }
}
