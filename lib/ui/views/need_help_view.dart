import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../locator.dart';

class NeedHelpView extends StatefulWidget {
  @override
  _NeedHelpViewState createState() => _NeedHelpViewState();
}

enum Services { Matvaror, Socialt, Teknisk }
Services _services = Services.Matvaror;

class _NeedHelpViewState extends State<NeedHelpView> {
  String desc = 'no Description';
  String type = 'Matvaror';
  final databaseReference = Firestore.instance;
  final AuthenticationService authService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  addRequest() async {
    User userData = await _firestoreService.getUser(authService.currentUser.id);
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (userData.activeEvents >= 3) {
      _dialogService.showDialog(
        title: 'Error',
        description: "Du kan inte ha mer än tre aktiva events",
      );
    } else {
      int nowActiveEvents = userData.activeEvents +1;
      Firestore.instance.collection('markers').add({
        'type': type,
        'name': userData.fullName, // GetCurrentUser Name ask philip.
        'desc': desc,
        'userID': userData.id,
        'coords': new GeoPoint(position.latitude, position.longitude),
      }
      );
      Firestore.instance.collection('users').document(userData.id).updateData({'activeEvents': nowActiveEvents});
    }

    //Trigged flag on account here. prevent more posts.
    //Move back to main menu?
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 110),
          Align(
            child: Text("Vilken typ av hjälp behöver du?",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600))),
          ),
          SizedBox(height: 20),
          Align(
            child: RadioListTile<Services>(
              title: const Text('Matvaror'),
              value: Services.Matvaror,
              groupValue: _services,
              onChanged: (Services value) {
                setState(() {
                  _services = value;
                  type = 'Matvaror';
                });
              },
            ),
          ),
          Align(
            child: RadioListTile<Services>(
              title: const Text('Socialt'),
              value: Services.Socialt,
              groupValue: _services,
              onChanged: (Services value) {
                setState(() {
                  _services = value;
                  type = 'Socialt';
                });
              },
            ),
          ),
          Align(
            child: RadioListTile<Services>(
              title: const Text('Teknisk'),
              value: Services.Teknisk,
              groupValue: _services,
              onChanged: (Services value) {
                setState(() {
                  _services = value;
                  type = 'Teknisk';
                });
              },
            ),
          ),
          SizedBox(height: 40),
          Align(
            child: Text("Beskriv vad du behöver hjälp med?",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w600))),
          ),
          SizedBox(height: 20),
          Align(
              child: Container(
            width: screenWidth(context) - 70,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              border: new Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: new TextField(
              onChanged: (text) {
                desc = text;
              },
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                border: InputBorder.none,
              ),
            ),
          )),
          SizedBox(height: 80),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("Avbryt",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600))),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                ButtonTheme(
                  height: 50,
                  child: RaisedButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("Godkänn",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600))),
                    onPressed: () async {
                      await addRequest();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ])
        ],
      ),
    ));
  }
}
