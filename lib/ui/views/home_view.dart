import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/current_activities_view.dart';
import 'package:compound/ui/views/looking_to_help_view.dart';
import 'package:compound/ui/views/need_help_view.dart';
import 'package:flutter/material.dart';
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

  bool currentEvents = false;
  @override
  void initState() {
    super.initState();

    checkIfActiveEvents();
    print("check method if events");
  }

  @override
  Widget build(BuildContext context) {
    return 
           MaterialApp(
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
              CircleAvatar(
        radius: 80,
        backgroundImage: NetworkImage(
              "https://thumbs.dreamstime.com/b/hand-som-rymmer-en-hj%C3%A4lpande-symbol-av-hj%C3%A4lp-och-service-155114278.jpg")),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,16),
                child: Text(
                  'What do you want today?',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Open Sans',
                      fontSize: 18),
                ),
              ),
              
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
                  padding: const EdgeInsets.fromLTRB(16,8.0,16,8),
                  child: Center(
                    child: Text("Request help",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600))),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NeedHelpView()),
                );
              }),
                ),
              ),
              
              Align(
                alignment: Alignment.center,
                child: ButtonTheme(
        
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,27.0,0,0),
          child: RaisedButton(
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: SizedBox(
                  width: 300,
                              child: Padding(
                    padding: const EdgeInsets.fromLTRB(16,8.0,16,8),
                    child: Center(
                      child: Text("Give help",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LookingToHelp()),
                  );
                }),
        ),
                ),
              ),
              
              Container(
        child: currentEvents
              ? ViewCurrentEvents()
              : Padding(
                padding: const EdgeInsets.fromLTRB(0,27,0,0),
                child: Text("You have no active events"),
              )),
              Container(child: Padding(
                padding: const EdgeInsets.fromLTRB(0,27,0,0),
                child: ButtonTheme(
           
            child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.lightBlue,
                child: Text('Share to Twitter', style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600))),
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
              ),),
          ]),
      
    ),
           );
  }

  void checkIfActiveEvents() async {
    final AuthenticationService authService = locator<AuthenticationService>();
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
    });
    if (doc != 0) {
      setState(() {
        currentEvents = true;
      });
    } else {
      setState(() {
        currentEvents = false;
      });
    }
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
        padding: const EdgeInsets.fromLTRB(0,27,0,0),
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
                              fontSize: 25,
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
