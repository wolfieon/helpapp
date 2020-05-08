import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:compound/models/markers.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../../locator.dart';


class LookingToHelp extends StatefulWidget{
  @override
  _LookingToHelpState createState() => _LookingToHelpState();
}

bool groVal = true;
bool socVal = true;
bool tekVal = true;
final List<MarkObj> markers = [];
final databaseReference = Firestore.instance;
final AuthenticationService authService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();

class _LookingToHelpState extends State<LookingToHelp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hjälp App"),
        backgroundColor: Colors.white,
      ), 
      body: FutureBuilder(future: createList() , builder: (BuildContext context, snapshot) { 
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Text("Loading"),
          );
        }
        else {
          return ListView.builder(
            itemCount: markers.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(markers[index].getName),
                  onTap: (){
                      createChat(markers[index].getUserID, authService.currentUser.id );
                  },
                ),
              );
             }
          );
        }
       },
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


  Future createList() async {
        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        QuerySnapshot snapshot = await databaseReference.collection("markers").getDocuments();
        for(var f in snapshot.documents) {
          double distanceInMeters = await Geolocator().distanceBetween(f.data['coords'].latitude, f.data['coords'].longitude, position.latitude, position.longitude);
          MarkObj newMarkObj = MarkObj (coords: f.data['coords'],name: f.data['name'],desc: f.data['desc'],userID: f.data['userID'], markerID: f.documentID, distance: distanceInMeters);
          print(distanceInMeters);
          markers.add(newMarkObj);
        }
        sorthething();
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

  createChat(userOne, userTwo) async {
    Chatters test = new Chatters(messengerid1: userOne, messengerid2: userTwo);
    await _firestoreService.createChat(test);
  }