import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/models/markers.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestInspectView extends StatelessWidget {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService auth = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final String markerId;
  final User user;

  RequestInspectView({this.markerId, this.user});

  @override
  Widget build(BuildContext context) {
    print(markerId);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).copyWith().size.height,
        width: MediaQuery.of(context).copyWith().size.width,
        child: Row(
          children: <Widget>[
            Expanded(
                child: FutureBuilder(
              future: _firestoreService.getMarker(markerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print('Got It');
                  return displayRequest(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ))
          ],
        ),
      ),
    );
  }

//todo kolla på textoverflow
  Widget displayRequest(context, snapshot) {
    MarkObj marker = snapshot.data;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '${marker.name}s request ',
            style: TextStyle(color: Colors.black),
          )),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            //Cirlce icon & text
            children: <Widget>[
              //profile pic

              SizedBox(
                width: screenWidth(context) / 20,
              ),
              Column(
                children: <Widget>[
                   SizedBox(
                height: screenHeight(context) / 50,
              ),
                  GestureDetector(
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfilePage(uid: marker.userID)),
                            )
                          },
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            backgroundImage: NetworkImage(user.photo),
                          ))),
                  SizedBox(
                    height: screenHeight(context) / 50,
                  ),
                ],
              ),

              SizedBox(
                width: screenWidth(context) / 40,
              ),
              Column(children: <Widget>[
                Text(marker.name,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))),
              ])
            ],
          ),
          SizedBox(
            height: screenHeight(context) / 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //Vad och när
            children: <Widget>[
              //Vad
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Need help with:",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w600))),
                  SizedBox(
                    height: screenHeight(context) / 60,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.shopping_basket),
                        Text("${marker.type}")
                      ]),
                  SizedBox(
                    height: screenHeight(context) / 60,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Icon(Icons.check), Text("YEEEt")]),
                  SizedBox(
                    height: screenHeight(context) / 60,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Icon(Icons.check), Text("ZIT")])
                ],
              ),

              //När
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("When?",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)))),
                  SizedBox(
                    height: screenHeight(context) / 60,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        Text("Date")
                      ]),
                  SizedBox(
                    height: screenHeight(context) / 60,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[Icon(Icons.timer), Text("Time")])
                ],
              )
            ],
          ),
          SizedBox(
            height: screenHeight(context) / 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(16.0)),
              Text("Description:",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)))
            ],
          ),
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(16.0)),
              SizedBox(
                  height: screenHeight(context) / 5,
                  width: MediaQuery.of(context).copyWith().size.width - 40,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("${marker.desc}",
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600))),
                  ))
            ],
          ),
          Row(
              //bottom Row
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: screenHeight(context) / 60,
                ),
                SizedBox(
                  width: screenWidth(context) / 8,
                ),
                ButtonTheme(
                    minWidth: 300.0,
                    height: 75.0,
                    child: RaisedButton(
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("Offer to help",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600))),
                      onPressed: () {
                        print(markerId);
                        print(marker.coords);
                        print(marker.desc);
                        print(marker.distance);
                        print("Name: ${marker.name}");
                        print(marker.markerID);
                        createHelpRequest(auth.currentUser.id, marker.userID,
                            marker.type, markerId);
                      },
                    )),
                Spacer(flex: 1)
              ])
        ],
      ),
    );
  }

  createHelpRequest(sender, reciever, requestType, markerID) async {
    User userData = await _firestoreService.getUser(auth.currentUser.id);
    int nowActiveEvents = userData.activeEvents + 1;
    if (userData.activeEvents >= 3) {
      _dialogService.showDialog(
        title: 'Error',
        description: "You cannot have more than 3 active events",
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
}
