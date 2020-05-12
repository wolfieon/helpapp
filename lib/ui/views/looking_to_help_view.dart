import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/chat.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:compound/models/markers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../locator.dart';

class LookingToHelp extends StatefulWidget{
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

class _LookingToHelpState extends State<LookingToHelp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ), 
      body: Column(
        children: <Widget>[
        new Expanded(
        child: FutureBuilder(future: createList() , builder: (BuildContext context, snapshot) { 
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
                  leading: Icon(Icons.chat_bubble),
                  title: Text(markers[index].getName, style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w600))),
                  subtitle: Text('Avstånd: ' + markers[index].getDistance.toString() + " meter" + '\n' + 'Beskrivning: ' + markers[index].getDesc, style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600))),
                  onTap: (){
                      createHelpRequest(authService.currentUser.id, markers[index].getUserID, markers[index].getType);
                          },
                        ),
                      );
                    }
                  );
                }
              }
            ),
          ),
          Container(   
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
        ],
      ),
    );
  }
}


  Future createList() async {
        final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        markers.clear();
        QuerySnapshot snapshot = await databaseReference.collection("markers").getDocuments();
        for(var f in snapshot.documents) {
          distanceInMeters = await Geolocator().distanceBetween(f.data['coords'].latitude, f.data['coords'].longitude, position.latitude, position.longitude);
          MarkObj newMarkObj = MarkObj (coords: f.data['coords'],type: f.data['type'],name: f.data['name'],desc: f.data['desc'],userID: f.data['userID'], markerID: f.documentID, distance: distanceInMeters);
          print(distanceInMeters);
          if (newMarkObj.getType == "Socialt" && socVal == true){
            markers.add(newMarkObj);
          }
          if (newMarkObj.getType == "Teknisk" && tekVal == true){
                      markers.add(newMarkObj);
          }
          if (newMarkObj.getType == "Matvaror" && groVal == true){
                      markers.add(newMarkObj);
          }
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



    //
  createHelpRequest(sender, reciever, requestType) async {
    
    Helprequest req = new Helprequest(sender: sender, reciever: reciever, requestType: requestType);
    await _firestoreService.createHelprequest(req);
  }