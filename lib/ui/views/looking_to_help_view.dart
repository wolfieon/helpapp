import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:compound/models/markers.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';


class LookingToHelp extends StatefulWidget{
  @override
  _LookingToHelpState createState() => _LookingToHelpState();
}

bool groVal = true;
bool socVal = true;
bool tekVal = true;

class _LookingToHelpState extends State<LookingToHelp> {
final List<MarkObj> markers = [];
final databaseReference = Firestore.instance;

Future getPosts() async {
  var fireStore = Firestore.instance;

  QuerySnapshot qn = await fireStore.collection("markers").getDocuments();
  

  return qn.documents;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hjälp App"),
        backgroundColor: Colors.white,
      ), 
      body: FutureBuilder(future: getPosts() , builder: (BuildContext context, snapshot) { 
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Text("Loading"),
          );
        }
        else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(snapshot.data[index].data["name"]),
                  onTap: (){

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

