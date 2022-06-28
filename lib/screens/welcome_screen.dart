
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id='welcome_screen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(
      duration: Duration(seconds: 2),
      vsync:this,
    );
    animation=ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState((){});
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset("images/logo.png"),
                    height: 60,
                    // height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts:[
                    TypewriterAnimatedText(
                        'Flash Chat',
                      speed: Duration(milliseconds: 200),
                      textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPress: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },
              buttonTitle: "Log In",
            ),
            RoundedButton(
              color: Colors.blueAccent,
              buttonTitle: "Register",
              onPress: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
            ),
          ],
        ),
      ),
    );
  }
}

