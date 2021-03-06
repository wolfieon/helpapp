import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/request_inspect_view.dart';
import 'package:flutter/material.dart';
import 'package:compound/models/markers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../locator.dart';

class LookingToHelp extends StatefulWidget {


  @override
  _LookingToHelpState createState() => _LookingToHelpState();
}

bool groVal = true;
bool socVal = true;
bool tekVal = true;
double distanceInMeters;
final List<MarkObj> markers = [];
final databaseReference = Firestore.instance;
final AuthenticationService authService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();
final DialogService _dialogService = locator<DialogService>();
final NavigationService _navigationService = locator<NavigationService>();

class _LookingToHelpState extends State<LookingToHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          new Expanded(
            child: FutureBuilder(
                future: createList(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: markers.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: FutureBuilder(
                                  future: _firestoreService
                                      .getUser(markers[index].getUserID),
                                  builder: (context, usernsnapshot) {
                                    if (usernsnapshot.connectionState ==
                                        ConnectionState.done) {
                                      User userx = usernsnapshot.data;
                                      return CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage(userx.photo));
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  }),
                              title: Text(markers[index].getName,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600))),
                              subtitle: Text(
                                  'Distance: ' +
                                      markers[index]
                                          .getDistance
                                          .toStringAsFixed(2) +
                                      " meter" +
                                      '\n' +
                                      "Type of problem: " +
                                      markers[index].getType +
                                      '\n' +
                                      'Description: ' +
                                      markers[index].getDesc,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600))),
                              onTap: () async {
                                print(markers[index].getMarkerID);
                                print(markers[index].name);
                                print("userId: ");
                                print(markers[index].userID);
                                User requestUser = await _firestoreService
                                    .getUser(markers[index].userID);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RequestInspectView(
                                          markerId: markers[index].getMarkerID,
                                          user: requestUser)),
                                );
                              },
                            ),
                          );
                        });
                  }
                }),
          ),
          Container(
            width: screenWidth(context),
            height: screenHeight(context) / 6,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  "I only want help with",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Social problems"),
                          Checkbox(
                            value: socVal,
                            onChanged: (bool value) {
                              setState(() {
                                socVal = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Technical Problems"),
                          Checkbox(
                            value: tekVal,
                            onChanged: (bool value) {
                              setState(() {
                                tekVal = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Grocery shopping"),
                          Checkbox(
                            value: groVal,
                            onChanged: (bool value) {
                              setState(() {
                                groVal = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future createList() async {
  final position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  markers.clear();
  User userData = await _firestoreService.getUser(authService.currentUser.id);
  QuerySnapshot snapshot =
      await databaseReference.collection("markers").getDocuments();
  for (var f in snapshot.documents) {
    distanceInMeters = await Geolocator().distanceBetween(
        f.data['coords'].latitude,
        f.data['coords'].longitude,
        position.latitude,
        position.longitude);
    MarkObj newMarkObj = MarkObj(
        coords: f.data['coords'],
        type: f.data['type'],
        name: f.data['name'],
        desc: f.data['desc'],
        userID: f.data['userID'],
        markerID: f.documentID,
        distance: distanceInMeters);
    print(distanceInMeters);
    if (userData.id != newMarkObj.getUserID) {
      if (newMarkObj.getType == "Groceries" && groVal == true) {
        markers.add(newMarkObj);
      }
     if (newMarkObj.getType == "Technical" && tekVal == true) {
        markers.add(newMarkObj);
      }
    if (newMarkObj.getType == "Social" && socVal == true) {
        markers.add(newMarkObj);
      }
    }
  }
  sorthething();
}


sorthething() {
  // snapshot data document ID (fetchthething)
  if (markers.length > 1) {
    markers.sort((a, b) => a.getDistance.compareTo(b.getDistance));
    print(markers[0].distance);
    print('list sorted');
  } else {
    print('list is less than 2');
  }
}

//

//
createHelpRequest(sender, reciever, requestType, markerID) async {
  User userData = await _firestoreService.getUser(authService.currentUser.id);
  int nowActiveEvents = userData.activeEvents + 1;
  if (userData.activeEvents >= 3) {
    _dialogService.showDialog(
      title: 'Error',
      description: "You cannot have more than 3 active events!",
    );
  } else {
    Helprequest req = new Helprequest(
        sender: sender,
        reciever: reciever,
        requestType: requestType,
        markerID: markerID);
    await _firestoreService.createHelprequest(req);
    Firestore.instance
        .collection('users')
        .document(userData.id)
        .updateData({'activeEvents': nowActiveEvents});
  }
  _navigationService.navigateTo(HomeViewRoute);
}
