import 'package:flashchat/components/rounded_button.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner=false;
  final _auth=FirebaseAuth.instance;
  String? email;
  String? password;
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
                style: TextStyle(
                  color: Colors.black
                ),
                textAlign: TextAlign.center,

                onChanged: (value) {
                  this.email=value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  this.password=value;
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: Colors.blueAccent,
                  buttonTitle: "Register",
                  onPress: () async{
                    setState((){
                      showSpinner=true;
                    });
                      try {
                        final newUser = await _auth.createUserWithEmailAndPassword(
                            email: this.email!, password: this.password!);
                        if(newUser!=null){
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState((){//when window is popped it should stop spinning
                          showSpinner=false;
                        });
                      }catch(error){
                        setState((){
                          showSpinner=false;
                        });
                      }
                    }
                  )
            ],
          ),
        ),
      ),
    );
  }
}
