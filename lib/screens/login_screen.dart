import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login_screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  final _auth=FirebaseAuth.instance;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black
                ),
                onChanged: (value) {
                  this.email=value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email'
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black
                ),
                onChanged: (value) {
                  this.password=value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                onPress: () async{
                  this.setState((){
                    showSpinner=true;
                  });
                  try {
                    UserCredential userCredential = await _auth
                        .signInWithEmailAndPassword(
                        email: this.email!, password: this.password!);
                    if(userCredential!=null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    this.setState((){
                      showSpinner=false;
                    });
                  }catch(error){
                    this.setState((){
                      showSpinner=false;//show warning instead
                    });
                    print(error);
                  }
                 },
                buttonTitle: "Log In",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
