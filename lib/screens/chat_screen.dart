import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';

final _fireStore=FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String id='chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextControler=TextEditingController();
  final _auth=FirebaseAuth.instance;
  String? messageText;
  void getCurrentUser() async{
    try {
      final user =await _auth.currentUser;
      if (user != null){
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    }catch(error){
      print(error);
    }
    }
  void messagesStream() async{
   await for(var snapshot in _fireStore.collection('messages').snapshots()){
      for(var message in snapshot.docs)
          print(message.data());
   }
  }
    @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(onPressed: (){
            _auth.signOut();
            Navigator.pop(context);
          }, icon: Icon(Icons.close)),
        ],
        title: Text("⚡️Chat"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextControler,
                      onChanged: (value){
                        messageText=value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                      onPressed: (){
                        //messagetext+loggedInUser
                        _fireStore.collection('messages').add(
                          {'text':messageText,'sender':loggedInUser!.email}
                        );
                        messageTextControler.clear();
                      },
                      child: Text(
                          'Send',
                        style: kSendButtonTextStyle,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context,snapshot){
        List<MessageBubble> messageBubbles = [];
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
            final messages=snapshot.data!.docs.reversed;
          List<Text> messageWidget=[];
          for(var message in messages){
            final messageText=message.get('text');
            final messageSender=message.get('sender');
            final currentUser=loggedInUser!.email;
            final messageBubble=MessageBubble(sender: messageSender,text: messageText,isMe: currentUser==messageSender?true:false,);
            messageBubbles.add(messageBubble);
          }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
      stream: _fireStore.collection('messages').snapshots(),);
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  const MessageBubble({required this.sender,required this.text,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ?CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
              sender,
            style: TextStyle(
              fontSize: 12.0,
              color:Colors.black54,
            ),
          ),
          Material(
          elevation: 5.0,
          borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):BorderRadius.only(topRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
          color: isMe ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Text('$text',
              style: TextStyle(
                  color: isMe?Colors.white:Colors.black54,
                      fontSize: 15.0
              ),
            ),
          ),
        ),
      ],
      ),
    );;
  }
}
