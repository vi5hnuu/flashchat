import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flashchat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.black54
          )
        )
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        ChatScreen.id:(context)=>ChatScreen(),
      },
    );
  }
}
