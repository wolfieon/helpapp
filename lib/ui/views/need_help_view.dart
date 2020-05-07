import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/startup_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:compound/models/markers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:compound/services/firestore_service.dart';

import '../../locator.dart';


class NeedHelpView extends StatefulWidget{
  @override
  _NeedHelpViewState createState() => _NeedHelpViewState();
}

enum Services { Matvaror, Socialt, Teknisk }
Services _services = Services.Matvaror;

class _NeedHelpViewState extends State<NeedHelpView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
        children: <Widget>[      
            SizedBox(height: 110),
            Align(
                  child: Text("Vilken typ av hjälp behöver du?", style: GoogleFonts.openSans(
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
        onChanged: (Services value) { setState(() { _services = value; }); },
            ),
          ),
          Align(
        child: RadioListTile<Services>(
        title: const Text('Socialt'),
        value: Services.Socialt,
        groupValue: _services,
        onChanged: (Services value) { setState(() { _services = value; }); },
           ),
          ),
          Align(
        child: RadioListTile<Services>(
        title: const Text('Teknisk'),
        value: Services.Teknisk,
        groupValue: _services,
        onChanged: (Services value) { setState(() { _services = value; }); },
           ),
          ),
          SizedBox(height: 40),
            Align(
                  child: Text("Beskriv vad du behöver hjälp med?", style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w600))),
        ),
        SizedBox(height:20),
        Align(
        child:Container(
          width: screenWidth(context)-70,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: new TextField(
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      ),
    )
        ),

        SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          ButtonTheme(
            height: 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: RaisedButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Text("Avbryt", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
          ),
        ButtonTheme(
        height: 50,
        child: RaisedButton(
          color: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Text("Godkänn", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))),
          onPressed: () async {
               await _helpLogic().listthething2();
               await _helpLogic().sorthething();
               await _helpLogic().hardcodedChatmetod();

               },
              ),
            ),
          ]
        )
        ],
        ),
      )
    );
  }
}

class _helpLogic  {

final List<MarkObj> markers = [];
final AuthenticationService authService = locator<AuthenticationService>();

  final databaseReference = Firestore.instance;
  bool listMade = false;
  String _address = "";

  void getCurrentLocation() async {
   final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   print(position);
   List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(59.3293, 18.0686);
   Placemark placeMark  = placemark[0]; 
   String name = placeMark.name;
   String subLocality = placeMark.subLocality;
   String locality = placeMark.locality;
   String administrativeArea = placeMark.administrativeArea;
   String postalCode = placeMark.postalCode;
   String country = placeMark.country;
   String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
   _address = address;
   print(_address);
   
   //double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);        Usefull later for distance
  }
  
  fetchthething() {
    databaseReference.collection("markers").getDocuments().then((snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    print(snapshot.documents[1].data['coords'].latitude);
    print(snapshot.documents[1].documentID);
    removethething(snapshot.documents[1].documentID);
    });
  }


      listthething2() async {
        QuerySnapshot snapshot = await databaseReference.collection("markers").getDocuments();

        for(var f in snapshot.documents) {
          double distanceInMeters = await Geolocator().distanceBetween(f.data['coords'].latitude, f.data['coords'].longitude, 52.3546274, 4.8285838);
          MarkObj newMarkObj = MarkObj (coords: f.data['coords'],name: f.data['name'],desc: f.data['desc'],userID: f.data['userID'], markerID: f.documentID, distance: distanceInMeters);
          print(distanceInMeters);
          markers.add(newMarkObj);
        }
  }


  sorthething() { // snapshot data document ID (fetchthething)
        if (markers.length > 1) {
          markers.sort((a, b) => a.getDistance.compareTo(b.getDistance));
          print(markers[0].distance);
          print('list sorted');
      } else {
          print('list is less than 2');
      }
  }


    addthething() {
    Firestore.instance.collection('markers').add({
      'type': 'a type',
      'name': 'a place',
      'desc': 'a description',
      'userID': 'user billy',
      'coords':
          new GeoPoint(42, 42),
      });
    }

    removethething(index) { // snapshot data document ID = index (fetchthething)
      databaseReference.collection('markers').document(index).delete();
    }


    dothething() async {
      print('started');
      double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
      print(distanceInMeters);
      print('stopped');
    }


    hardcodedChatmetod() async  { // will add closest marker to chat with you
      Chatters nyChat = new Chatters (messengerid1: markers[0].userID, messengerid2: await authService.getCurrentUID());
      FirestoreService().createChat(nyChat);
    }
}

