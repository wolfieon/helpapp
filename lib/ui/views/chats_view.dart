import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/models/user.dart';
import 'package:compound/provider/user_provider.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/ui/views/map_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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
  UserProvider userProvider; 

  @override
  void initState() {
    super.initState();
    

    SchedulerBinding.instance.addPostFrameCallback((_){
      userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser();
    

    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create:(context) => UserProvider(),

    child: MaterialApp(
      title: 'Help Chat',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Text('Chats', style: TextStyle(color: Colors.black),)),
        ),
        body: FutureBuilder(
          future: _firestoreService.getUser(authService.currentUser.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          height: 200.0,
                          width: 200.0,
                        ),
                      );
            } else {
              // data loaded:
              User userman = snapshot.data;

              return Scaffold(
                body: new MountainList(
                  user: userman,
                ),
                floatingActionButton: new FloatingActionButton(
                  child: new Icon(Icons.add),
                  onPressed: ()  async {
                    //Dålig konfiguration men bara för att testa, kartfunktionen bör hantera skapandet av chatter.
                    Chatters chat = new Chatters(
                        messengerid1: userman.id,
                        messengerid2: 'eGFUoNHg1ohZMyHcRGbnZCoKLm83');
                   await _firestoreService.createChat(chat);
                  },
                ),
              );
            }
          },
        ),
      ),
    ),);
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
    final FirestoreService _firestoreService = locator<FirestoreService>();

    return new StreamBuilder(
      stream: Firestore.instance
          .collection('chats')
          .document(user.id)
          .collection('chats')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          height: 200.0,
                          width: 200.0,
                        ),
                      );
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new ListTile(
              leading: FutureBuilder(
                
                  future: _firestoreService.getUser(document['messengerid2']),
                  builder: (context, usernsnapshot) {
                    if (usernsnapshot.connectionState == ConnectionState.done) {
                      User userx = usernsnapshot.data;
                      return CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(userx.photo));
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              trailing: 
                  Wrap(
                    spacing: 12,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.map,), onPressed: () async { 
                        final userPos = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        GeoPoint targetPos = userPos as GeoPoint; //TODO this has to be fucking fixed to add new variable from accepted requests of target user?
                        Navigator.push(context,MaterialPageRoute(builder: (context) => MapView(userPos: userPos, targetPos: targetPos,)),);
                       },),
                      
                       new IconButton(
                      
                        icon: Icon(Icons.block),
                        
                        
                        onPressed: () {
                          //pop up window that ask if u are sure you want to remove chat
                          //then remove

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Remove chat?'),
                              content: FutureBuilder(
                                  future: _firestoreService
                                      .getUser(document['messengerid2']),
                                  builder: (context, usernsnapshot) {
                                    if (usernsnapshot.connectionState ==
                                        ConnectionState.done) {
                                      User userx = usernsnapshot.data;
                                      return Text(
                                          "Do you want to stop chatting with " +
                                              userx.fullName +
                                              "?");
                                    } else {
                                      return Text('Loading...');
                                    }
                                  }),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                ),
                                 FlatButton(
                                   child: Text("Yes"),
                                   onLongPress: null,
                                  onPressed: () async {
                                     Chatters chat = Chatters(
                                         messengerid1: document['messengerid1'],
                                         messengerid2: document['messengerid2']);
                                     await _firestoreService.deleteChat(chat);
                                     Navigator.of(context, rootNavigator: true)
                                         .pop('dialog');
                                   },
                                 ),
                              ],
                            ),
                            barrierDismissible: false,
                          );
                        }),
                    ],),
                
              
              title: FutureBuilder(
                  future: _firestoreService.getUser(document['messengerid2']),
                  builder: (context, usernsnapshot) {
                    if (usernsnapshot.connectionState == ConnectionState.done) {
                      User userx = usernsnapshot.data;
                      return Text(userx.fullName);
                    } else {
                      return Text('Loading...');
                    }
                  }),
              
              onTap: () async {
                sendToChat(document['messengerid2'], context);

                
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
