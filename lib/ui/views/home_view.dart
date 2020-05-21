import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/current_activities_view.dart';
import 'package:compound/ui/views/looking_to_help_view.dart';
import 'package:compound/ui/views/need_help_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:social_share_plugin/social_share_plugin.dart';

import '../../locator.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final db = Firestore.instance;
  final AuthenticationService authService = locator<AuthenticationService>();
  bool currentEvents = false;
  @override
  void initState() {
    super.initState();
    BottomAppBar();
    checkIfActiveEvents();
    lastSeen();
    print("check method if events");
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
                child: Text(
                  'Helping hand',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Open Sans',
                      fontSize: 30),
                ),
              ),
              SizedBox(height: screenHeight(context) / 80),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: screenHeight(context) / 3.8,
                  child: Image.asset('assets/images/hand.png'),
                ),
              ),
              SizedBox(height: screenHeight(context) / 25),
              Align(
                child: Text("What Do You Want To Do Today?",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600))),
              ),
              SizedBox(height: screenHeight(context) / 40),
              Align(
                alignment: Alignment.center,
                child: ButtonTheme(
                  child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
                          child: Center(
                            child: Text("Request help",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NeedHelpView()),
                        );
                      }),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ButtonTheme(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 27.0, 0, 0),
                    child: RaisedButton(
                        color: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
                            child: Center(
                              child: Text("Give help",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LookingToHelp()),
                          );
                        }),
                  ),
                ),
              ),
              Container(
                  child: currentEvents
                      ? ViewCurrentEvents()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(0, 27, 0, 0),
                          child: Text("You have no active events"),
                        )),
              SizedBox(height: screenHeight(context) / 30),
              Text("Share to twitter",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w600))),
              Align(
                alignment: Alignment.center,
                child: ButtonTheme(
                  child: IconButton(
                    iconSize: screenHeight(context) / 15,
                    icon: Icon(EvaIcons.twitter, color: Colors.lightBlue),
                    onPressed: () async {
                      String url = '[insert helpapp link here]';
                      final text =
                          'This is a free marketing ploy not only for us, but for you too!';
                      final result = await SocialSharePlugin.shareToTwitterLink(
                          text: text,
                          url: url,
                          onSuccess: (_) {
                            print('TWITTER SUCCESS');
                            return;
                          },
                          onCancel: () {
                            print('TWITTER CANCELLED');
                            return;
                          });
                      print(result);
                    },
                  ),
                ),
              )
            ]),
      ),
    );
  }

  void lastSeen() async {
    var user = await authService.getCurrentUID();
    final userPos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    db.collection('users').document(user).updateData({
      'lastSeen': new GeoPoint(userPos.latitude, userPos.longitude),
    });
  }

  void checkIfActiveEvents() async {
    var user = await authService.getCurrentUID();
    int doc = 0;

    QuerySnapshot qs = await Firestore.instance
        .collection('users')
        .document(user)
        .collection('acceptedGiveHelpRequest')
        .getDocuments();
    qs.documents.forEach((DocumentSnapshot snap) {
      doc++;
    });

    QuerySnapshot qsa = await Firestore.instance
        .collection('users')
        .document(user)
        .collection('acceptedHelpRequest')
        .getDocuments();
    qsa.documents.forEach((DocumentSnapshot snap) {
      doc++;
    });if(mounted) {
    if (doc != 0) {
      setState(() {
        currentEvents = true;
      });
    } else {
      setState(() {
        
        currentEvents = false;
      });
    }}
  }
}

class ViewCurrentEvents extends StatelessWidget {
  const ViewCurrentEvents({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 27, 0, 0),
        child: RaisedButton(
            color: Colors.lightBlueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("View current activities",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrentActivities()),
              );
            }),
      ),
    );
  }
}
