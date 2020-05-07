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

class LookingToHelp extends StatefulWidget{
  @override
  _LookingToHelpState createState() => _LookingToHelpState();
}

class _LookingToHelpState extends State<LookingToHelp> {
bool groVal = true;
bool socVal = true;
bool tekVal = true;
List<String> testList = [
  "Test1","Test2","Test3","Test4","Test4","Test5","Test6","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hjälp App"),
        backgroundColor: Colors.white,
      ), 
      body: ListView.builder(
        itemCount: testList.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
                title: Text(testList[index]),
                onTap: () {
                },
              ),
            );
          } 
        ),
      bottomSheet: Container(
      width: screenWidth(context),
      height: screenHeight(context)/6,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(height:20),
          Text("Visa Endast", style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),),
          SizedBox(height:10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Text("Sociala"),
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
                      Text("Tekniska"),
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
                      Text("Matvaror"),
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
            ]
          )
        ],
      ),
    ),
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


    addthething() { //this needs to be filled our in need help view not here.
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

