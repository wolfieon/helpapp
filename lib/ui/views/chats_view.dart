import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import 'chat_view.dart';



class Chats extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Chats> {
  Future<FirebaseUser> userx = someMethod();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService authService = locator<AuthenticationService>();

  @override
  void initState() {   
    super.initState();
    
  }

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Chat',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Help Chat'),
        ),
        body: FutureBuilder(
          future: _firestoreService.getUser(authService.currentUser.id),
          builder: ( context,snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // data loaded:
              User userman = snapshot.data;
              
              return Scaffold(
                body: new MountainList(user: userman,),
                floatingActionButton: new FloatingActionButton(
                  child: new Icon(Icons.add),
                  onPressed: () {
                    //Dålig konfiguration men bara för att testa, kartfunktionen bör hantera skapandet av chatter.
                    String mottagareID = 'IDtkswOy3FPIOX7HYnVYOtG1dFj1';
          Firestore.instance.collection('chats').document(userman.id).collection('chats').document().setData(
            {
              'messenger2': mottagareID,
              'messenger1': userman.id,
            },
          );
          Firestore.instance.collection('chats').document(mottagareID).collection('chats').document().setData(
            {
              'messenger2': userman.id,
              'messenger1': mottagareID,
            },
          );
        },),
                
              );
            }
          },
        ),
      ),
    );
  }
}

Future<FirebaseUser> someMethod() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user;
  
  }




class MountainList extends StatelessWidget {


final User user;


  const MountainList({Key key, @required this.user}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    
    return new StreamBuilder(
      
      stream: Firestore.instance.collection('chats').document(user.id).collection('chats').snapshots(),
      
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          
          children: snapshot.data.documents.map((document) {
            return new ListTile(
              
              
              title: new Text(document['messenger2']),
              subtitle: new Text(user.fullName),
              onTap: () async {
                sendToChat(document['messenger2'], context);

                
                
                //testCreateChat();
                
                
    //             Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Chat(
    //       user: user,
    //       mottagare: mottagaren,
    //     ),
    //   ),
    // );
              },
              
            );
          }).toList(),
        );
      },
    );
  }

  
 sendToChat(String uid, context) async {
   final FirestoreService _firestoreService = locator<FirestoreService>();
    final User mottagaren = await _firestoreService.getUser(uid);
   Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
          mottagare: mottagaren,
        ),
     ),
    );
 }

// testCreateChat() {
//   Chatters testchatt = Chatters(messengerid1: 'test', messengerid2: 'test2');
//       _firestoreService.createChat(testchatt);
// }

}
