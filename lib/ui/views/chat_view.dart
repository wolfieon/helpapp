import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  static const String id = "CHAT";
  final User user;
  final User mottagare;

  const Chat( {Key key, this.user, this.mottagare}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final Firestore _firestore = Firestore.instance;
  final NavigationService _navigationService = locator<NavigationService>();
  
  
  

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Object get user =>  _auth.currentUser();

  

  

  
  

   Future<void> loginUser() async {
    //Future user = await _firestoreService.getUser(_auth.currentUser);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
        ),
      ),
    );
  }
  

  Future<void> callback() async {
    //print('This is the current user' + _currentUser.toString());
    
    
    if (messageController.text.length > 0) {
      //adda till sändarens collection samt mottagarens collection
      //duplicate code bara för att jag orkar inte, addar meddelanden till bägge users databas
      await _firestore.collection('chats').document(widget.user.id).collection(widget.mottagare.id).add({
        'text': messageController.text,
        'from': widget.user.fullName,
        'date': DateTime.now().toIso8601String().toString(),
      });
      await _firestore.collection('chats').document(widget.mottagare.id).collection(widget.user.id).add({
        'text': messageController.text,
        'from': widget.user.fullName,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    print(uid);
    //print(uemail);
  }

  @override
  Widget build(BuildContext context) {
    
    if(User().email == null){
      //loginUser();
      
    }
    

    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40.0,
            child: Image.network(widget.mottagare.photo),
          ),
        ),
        title: Text('talking to: ' + widget.mottagare.fullName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: ()  async {
              Navigator.pop(context);
               //_navigationService.navigateTo(ChatListRoute);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .document(widget.user.id)
                    .collection(widget.mottagare.id)
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['from'],
                            text: doc.data['text'],
                            me: widget.user.fullName == doc.data['from'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  SendButton(
                    text: "Send",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<String> getEmailCurrent() async {
    FirebaseUser userb = await _auth.currentUser();
    return userb.email.toString();
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          
          Text(
            from,
          ),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}