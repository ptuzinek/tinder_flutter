import 'package:flutter/material.dart';
import 'package:tinder_flutter/components/chat_wall_row.dart';

class ChatWallScreen extends StatefulWidget {
  static String id = 'chat_wall_screen';
  @override
  _ChatWallScreenState createState() => _ChatWallScreenState();
}

class _ChatWallScreenState extends State<ChatWallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ChatWallRow(
            text: 'Marianna',
          ),
          ChatWallRow(
            text: 'Agata',
          ),
          ChatWallRow(
            text: 'Ewa',
          ),
          ChatWallRow(
            text: 'Franka',
          ),
          ChatWallRow(
            text: 'Agnieszka',
          ),
          ChatWallRow(
            text: 'Marta',
          ),
          ChatWallRow(
            text: 'Ula',
          ),
          ChatWallRow(
            text: 'Patrycja',
          ),
        ],
      ),
    );
  }
}
