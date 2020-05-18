import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:compound/models/markers.dart';
import 'package:geolocator/geolocator.dart';


class LookingToHelp extends StatefulWidget{
  @override
  _LookingToHelpState createState() => _LookingToHelpState();
}

class _LookingToHelpState extends State<LookingToHelp> {
final List<MarkObj> markers = [];
final databaseReference = Firestore.instance;
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

void initState() {
  createList();
}

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

       createList() async {
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
}
