import 'package:flutter/material.dart';
import 'package:tinder_flutter/screens/chat_screen.dart';
import 'package:tinder_flutter/screens/chat_wall_screen.dart';
import 'package:tinder_flutter/screens/login_screen.dart';
import 'package:tinder_flutter/screens/picture_screen.dart';
import 'package:tinder_flutter/screens/profile_info.dart';
import 'package:tinder_flutter/screens/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tinder_flutter/screens/swipe_screen.dart';
import 'package:tinder_flutter/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// Login -> match -> chatWall -> chat

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //darkTheme: ThemeData.dark(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ProfileInfoScreen.id: (context) => ProfileInfoScreen(),
        PictureScreen.id: (context) => PictureScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ChatWallScreen.id: (context) => ChatWallScreen(),
        SwipeScreen.id: (context) => SwipeScreen(),
      },
    );
  }
}
