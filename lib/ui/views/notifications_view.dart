import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/views/helper_view.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final AuthenticationService authService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
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
                      RaisedButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(5.0),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black)),
                        onPressed: null,
                        child: Text(
                          "Requests",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(5.0),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black)),
                        onPressed: () async {
                          /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelperView(),
                            ),
                          );*/

                          /*
                            push to accepted request view
                            
                            
                            */
                        },
                        child: Text(
                          "Accepted",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              color: Colors.white,
              width: 300,
              height: 150,
            ),
            Container(
              width: 300,
              height: 500,
              child: StreamBuilder(
                  stream: getUsersTripsStreamSnapshots(context),
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
                                return buildTripCard(context,
                                    snapshot.data.documents[index], sender);
                              } else {
                                return CircularProgressIndicator();
                              }
                            });
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void sendToHelper() {
    _navigationService.navigateTo(HelperViewRoute);
  }

  Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
      BuildContext context) async* {
    final uid = await authService.currentUser.id;
    yield* Firestore.instance
        .collection('users')
        .document(uid)
        .collection('recievedHelpRequests')
        .orderBy('date')
        .snapshots();
  }

  Widget buildTripCard(
      BuildContext context, DocumentSnapshot document, User sender) {
    final trip = Helprequest.fromData(document.data);

    //

    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(color: Colors.grey[800], spreadRadius: 1),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Card(
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
                            Text(
                              "Help you " + trip.requestType,
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.pink),
                            ),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Reject"),
                              IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  onPressed: () async {
                                    final currentUser = await _firestoreService
                                        .getCurrentUser();
                                    Helprequest req = new Helprequest(
                                        sender: sender.id,
                                        reciever: currentUser.uid);
                                    await _firestoreService
                                        .deleteHelprequest(req);
                                  }),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Accept"),
                              IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () async {
                                    final currentUser = await _firestoreService
                                        .getCurrentUser();
                                    final User reciever =
                                        await _firestoreService
                                            .getUser(currentUser.uid);
                                    Helprequest req = new Helprequest(
                                        sender: sender.id,
                                        reciever: reciever.id);

                                    Chatters cha = new Chatters(
                                        messengerid1: sender.id,
                                        messengerid2: reciever.id);

                                    await _firestoreService
                                        .deleteHelprequest(req);
                                    await _firestoreService.acceptRequest(req);
                                    await _firestoreService.createChat(cha);
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
      ),
    );
  }
}
