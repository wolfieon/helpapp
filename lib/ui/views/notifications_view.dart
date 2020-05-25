import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/models/user.dart';
import 'package:compound/provider/user_provider.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/views/chat_view.dart';
import 'package:compound/ui/views/looking_to_help_view.dart';
import 'package:compound/ui/views/review_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => new _NotificationsViewState();
}

UserProvider userProvider; 
  

class _NotificationsViewState extends State<NotificationsView> {

  
  final AuthenticationService authService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  int count = 0;
  bool requestsButton = true;
  bool acceptedButton = false;
  bool reviewsButton = false;
  String pageText = "Offers to help you";
  var streamMethod;



  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
        
                  body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,45,0,0),
                  child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  'Notifications',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Open Sans',
                      fontSize: 30),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Opacity(
                      opacity: requestsButton?  1:0.3,
                      child: RaisedButton(
                        color: requestsButton ? Colors.lightBlueAccent : Colors.white,
                        textColor: Colors.black,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: requestsButton ? BorderSide(color: Colors.white54) : BorderSide(color: Colors.grey) ),
                        onPressed: () {
                          setState(() {
                            count = 0;
                            reviewsButton = false;
                            requestsButton = true;
                            acceptedButton = false;
                            pageText = "Offers to help you";
                          });
                        },
                        child: Text(
                          "Help offers",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity:acceptedButton? 1:0.3,
                      child: RaisedButton(
                        color: acceptedButton ?  Colors.lightBlueAccent:Colors.white ,
                        textColor: Colors.black,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: acceptedButton ? BorderSide(color: Colors.white54) : BorderSide(color: Colors.grey) ),
                        onPressed: () {
                          setState(() {
                            count = 1;
                            reviewsButton = false;
                            requestsButton = false;
                            acceptedButton = true;
                            pageText = "Accepted your offer to help";

                          });
                        },
                        child: Text(
                          "Your offers",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity:reviewsButton? 1:0.3,
                      child: RaisedButton(
                        color: reviewsButton ?  Colors.lightBlueAccent:Colors.white ,
                        textColor: Colors.black,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: reviewsButton ? BorderSide(color: Colors.white54) : BorderSide(color: Colors.grey) ),
                        onPressed: () {
                          setState(() {
                            count = 2;
                            requestsButton = false;
                            acceptedButton = false;
                            reviewsButton = true;
                            pageText = "New reviews";

                          });
                        },
                        child: Text(
                          "Reviews",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                            pageText,
                            style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Open Sans',
                      fontSize: 13),
                            
                          ),
            ),],
          ),
          color: Colors.white,
          width: 340,
          height: 150,
                  ),
                ),
                cardStream(context),
              ],
            ),
        ),
      ),
    );
  }

  Container cardStream(BuildContext context) {
    if (count == 0) {
      return Container(
        width: 300,
        height: 438,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: StreamBuilder(
              stream: getUserRecievedHelpRequests(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");

                return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return new FutureBuilder(
                        future: _firestoreService.getUser(ds['sender']),
                        builder: (context, usernsnapshot) {
                          if (usernsnapshot.connectionState ==
                              ConnectionState.done) {
                            User sender = usernsnapshot.data;

                            return RequestCard(
                              document: ds,
                              sender: sender,
                              helpReq: ds['requestType'],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        });
                  },
                );
              }),
        ),
      );
    } if (count == 1) {
      return Container(
        width: 300,
        height: 438,
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: StreamBuilder(
              stream: getAcceptedHelpRequests(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");

                return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return new FutureBuilder(
                        future: _firestoreService.getUser(ds['reciever']),
                        builder: (context, usernsnapshot) {
                          if (usernsnapshot.connectionState ==
                              ConnectionState.done) {
                            User sender = usernsnapshot.data;

                            return AcceptCard(
                              document: ds,
                              sender: sender,
                              helpReq: ds['requestType'],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        });
                  },
                );
              }),
        ),
      );
    }if(count == 2){
      return Container(
        width: 300,
        height: 438,
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: StreamBuilder(
              stream: getReviewNotifications(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print("Nodata");
                  return const Text("Loading...");
                  
                };

                return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return new FutureBuilder(
                        future: _firestoreService.getUser(ds['from']),
                        builder: (context, usernsnapshot) {
                          if (usernsnapshot.connectionState ==
                              ConnectionState.done) {
                            User sender = usernsnapshot.data;

                            return ReviewCard(
                              document: ds,
                              from: sender,
                              description: ds['description'],
                              happy: ds['happy'],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        });
                  },
                );
              }),
        ),
      );
    }
  }

  void sendToHelper() {
    _navigationService.navigateTo(HelperViewRoute);
  }

  Stream<QuerySnapshot> getUserRecievedHelpRequests(
      BuildContext context) async* {
    final uid = await authService.currentUser.id;
    yield* Firestore.instance
        .collection('users')
        .document(uid)
        .collection('recievedHelpRequests')
        .orderBy('date')
        .snapshots();
  }

  Stream<QuerySnapshot> getAcceptedHelpRequests(BuildContext context) async* {
    final uid = await authService.currentUser.id;
    yield* Firestore.instance
        .collection('users')
        .document(uid)
        .collection('acceptedGiveHelpRequest')
        .orderBy('date')
        .snapshots();
  }

  Stream<QuerySnapshot> getReviewNotifications(BuildContext context) async* {
    final uid = authService.currentUser.id;
    yield* Firestore.instance
        .collection('users')
        .document(uid)
        .collection('reviewNotification')
        .snapshots();
  }
}

class AcceptCard extends StatelessWidget {
  final User sender;
  final DocumentSnapshot document;
  final String helpReq;

  const AcceptCard({Key key, this.sender, this.document, this.helpReq})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = locator<FirestoreService>();
    
    //final trip = Helprequest.fromData(document.data);

    //

    return Container(
      padding: EdgeInsets.all(1),
      child: Container(
        child: ClipRRect(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white10, width: 40),
              borderRadius: BorderRadius.circular(9),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(sender.photo)),
                          Expanded(
                              child: Text(
                                  sender.fullName +
                                      ' accepted your offer to help with ' + helpReq,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black))),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "Regret",
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                                icon: Icon(Icons.do_not_disturb, color: Colors.blueAccent,),
                                onPressed: () async {
                                  var currentuserid = await authService.getCurrentUID();
                                  Helprequest req = new Helprequest(sender: sender.id, reciever: currentuserid);
                                  await _firestoreService.deleteAcceptRequest(req);

                                }),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Open chat",
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                                icon: Icon(Icons.chat, color: Colors.blueAccent,), onPressed: () async {
                                  sendToChat(context);
                                }),
                          ],
                        ),

                        //Spacer(),
                        //(tripType.containsKey(trip.travelType))? tripType[trip.travelType]: tripType["other"],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  sendToChat(context) async {
    final FirestoreService _firestoreService = locator<FirestoreService>();
    final AuthenticationService authService = locator<AuthenticationService>();
    final uid = await authService.currentUser.id;
    final User user = await _firestoreService.getUser(uid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
          mottagare: sender,
        ),
      ),
    );
  }
}
class ReviewCard extends StatelessWidget {
  final User from;
  final DocumentSnapshot document;
  final String description;
  final bool happy;

  const ReviewCard({Key key, this.from, this.document, this.description, this.happy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = locator<FirestoreService>();
    
    //final trip = Helprequest.fromData(document.data);

    //

    return Container(
      padding: EdgeInsets.all(1),
      child: Container(
        child: ClipRRect(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white10, width: 40),
              borderRadius: BorderRadius.circular(9),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(from.photo)),
                          Expanded(
                              child: Text(
                                  from.fullName + " gave you a review!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black))),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            // Text(
                            //   "Regret",
                            //   style: TextStyle(fontSize: 16),
                            // ),
                            // IconButton(
                            //     icon: Icon(Icons.do_not_disturb, color: Colors.blueAccent,),
                            //     onPressed: () async {
                                  
                            //       //await _firestoreService.deleteReviewNotification();

                            //     }),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Leave a review",
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                                icon: Icon(Icons.rate_review, color: Colors.lightBlueAccent,), onPressed: () async {
                                  FirebaseUser us = await authService.getCurrentUser();
                                  User me = await _firestoreService.getUser(us.uid);
                                  sendToReview(me, from, context);
                                  //sendToChat(context);
                                }),
                          ],
                        ),

                        //Spacer(),
                        //(tripType.containsKey(trip.travelType))? tripType[trip.travelType]: tripType["other"],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
   sendToReview(User me, User otherUser, context) async {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewView(
          me: me,
          otherUser: otherUser,
          isRespondReview: true,
        ),
      ),
    );
  }}

class RequestCard extends StatelessWidget {
  final User sender;
  final DocumentSnapshot document;
  final String helpReq;

  const RequestCard({Key key, this.sender, this.document, this.helpReq})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = locator<FirestoreService>();
    //final trip = Helprequest.fromData(document.data);

    //

    return new Container(
      padding: EdgeInsets.all(1),
      child: Container(
        child: ClipRRect(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white10, width: 40),
              borderRadius: BorderRadius.circular(9),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Text("${trip.date}"),
                          Expanded(
                              child: Text(
                                  
                                      'Accept help with ' + helpReq + " help",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black))),
                          //Spacer(),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.grey[800], spreadRadius: 1),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30.0, 2, 30, 2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                                    child: CircleAvatar(
                                        radius: 45,
                                        backgroundImage:
                                            NetworkImage(sender.photo)),
                                  ),
                                  Text(
                                    sender.fullName,
                                    style: new TextStyle(fontSize: 15.0),
                                  ),
                                  //Spacer(),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Text("Reject"),
                              IconButton(
                                  icon: Icon(Icons.delete_forever, color: Colors.redAccent,),
                                  onPressed: () async {
                                    final currentUser =
                                        await _firestoreService
                                            .getCurrentUser();
                                    Helprequest req = new Helprequest(
                                        sender: sender.id,
                                        reciever: currentUser.uid);
                                    await _firestoreService
                                        .deleteHelprequest(req);
                                    
                                  }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: Column(
                            children: <Widget>[
                              Text("Accept"),
                              IconButton(
                                  icon: Icon(Icons.check, color: Colors.greenAccent,),
                                  onPressed: () async {
                                    final currentUser =
                                        await _firestoreService
                                            .getCurrentUser();
                                    final User reciever =
                                        await _firestoreService
                                            .getUser(currentUser.uid);
                                    print(helpReq);
                                    Helprequest req = new Helprequest(
                                        sender: sender.id,
                                        reciever: reciever.id,
                                        requestType: helpReq);

                                    Chatters cha = new Chatters(
                                        messengerid1: sender.id,
                                        messengerid2: reciever.id);

                                    await _firestoreService
                                        .deleteHelprequest(req);
                                    await _firestoreService
                                        .acceptRequest(req);
                                    await _firestoreService.createChat(cha);
                                    await Firestore.instance
                                        .collection('markers')
                                        .document(document['markerID'])
                                        .delete();
                                  }),
                            ],
                          ),
                        ),

                        //Spacer(),
                        //(tripType.containsKey(trip.travelType))? tripType[trip.travelType]: tripType["other"],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
