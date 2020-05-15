import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CurrentActivities extends StatefulWidget {
  @override
  final User me;
  

  const CurrentActivities({Key key, this.me}) : super(key: key);

  @override
  _CurrentActivitiesState createState() => _CurrentActivitiesState();
}

final AuthenticationService authService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();



  int count = 0;
  bool givingHelpButton = true;
  bool recivingHelpButton = false;
  bool reviewsButton = false;
  String pageText = "People you are giving help to";





class _CurrentActivitiesState extends State<CurrentActivities> {
  Widget build(BuildContext context) {
    return  
                Scaffold(
                  
                                  body: Center(
                                    child: Flexible(
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
                          'Your activities',
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
                              opacity: givingHelpButton?  1:0.3,
                              child: RaisedButton(
                                color: givingHelpButton ? Colors.lightBlueAccent : Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: givingHelpButton ? BorderSide(color: Colors.white54) : BorderSide(color: Colors.grey) ),
                                onPressed: () {
                                      setState(() {
                                        count = 0;
                                        reviewsButton = false;
                                        givingHelpButton = true;
                                        recivingHelpButton = false;
                                        pageText = "People you are giving help to";
                                        
                                      });
                                },
                                child: Text(
                                      "Giving help",
                                      style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity:recivingHelpButton? 1:0.3,
                              child: RaisedButton(
                                color: recivingHelpButton ?  Colors.lightBlueAccent:Colors.white ,
                                textColor: Colors.black,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: recivingHelpButton ? BorderSide(color: Colors.white54) : BorderSide(color: Colors.grey) ),
                                onPressed: () {
                                      setState(() {
                                        count = 1;
                                        reviewsButton = false;
                                        givingHelpButton = false;
                                        recivingHelpButton = true;
                                        pageText = "People that are helping you";
                                        

                                      });
                                },
                                child: Text(
                                      "Reciving help",
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
  }

Stream<QuerySnapshot> getAcceptedHelpRequests(BuildContext context) async* {
    final uid =  authService.currentUser.id;
    yield* Firestore.instance
        .collection('users')
        .document(uid)
        .collection('acceptedHelpRequest')
        .orderBy('date')
        .snapshots();
  }

  Stream<QuerySnapshot> getAcceptedGiveHelpRequests(BuildContext context) async* {
    final uid =  authService.currentUser.id;
    yield* Firestore.instance
        .collection('users')
        .document(uid)
        .collection('acceptedGiveHelpRequest')
        .orderBy('date')
        .snapshots();
  }

Container cardStream(BuildContext context) {
  
  
    
      return Container(
        width: 300,
        height: 438,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: StreamBuilder(
              stream: givingHelpButton? getAcceptedGiveHelpRequests(context) : getAcceptedHelpRequests(context)//get acceptedgivehelprequest
                
              ,
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
                            
                            if(givingHelpButton == true) {
                              return GivingHelp(
                              document: ds,
                              sender: sender,
                              helpReq: ds['requestType'],
                            );}
                            if(recivingHelpButton == true) {
                            return new RecivingHelp(
                              document: ds,
                              sender: sender,
                              helpReq: ds['requestType'],
                            );
                            }
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


  class GivingHelp extends StatelessWidget {
  final User sender;
  final DocumentSnapshot document;
  final String helpReq;

  const GivingHelp({Key key, this.sender, this.document, this.helpReq})
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
                                  
                                      ' You are helping ' + sender.fullName + " with " + helpReq,
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
                              "Stop helping",
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
  }}

  class RecivingHelp extends StatelessWidget {
  final User sender;
  final DocumentSnapshot document;
  final String helpReq;

  const RecivingHelp({Key key, this.sender, this.document, this.helpReq})
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
                                      ' is helping you with ' + helpReq,
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
                              "Stop Helping",
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
  }}