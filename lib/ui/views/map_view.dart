import 'package:compound/models/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';



//This needs 2 vars to be determined when requested to open the page.
class MapView extends StatelessWidget { //Navigator.push(context,MaterialPageRoute(builder: (context) => MapView(userPos: userPos, targetPos: targetPos,)),);
  final databaseReference = Firestore.instance;
  final Position userPos;
  final GeoPoint targetPos;
  final List<MarkObj> markers = []; 
  MapView({this.userPos, this.targetPos});



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new FlutterMap(
            options: new MapOptions(
                center: new LatLng(1, 1), minZoom: 5.0, maxZoom: 18.0),
            layers: [

              new TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),

              new MarkerLayerOptions(markers: [
                new Marker(
                    width: 45.0,
                    height: 45.0,
                    point: new LatLng(1, 1),
                    builder: (context) => new Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.blue,
                            iconSize: 45.0,
                            onPressed: () async {
                            },
                          ),
                        ))
                ,new Marker(
                    width: 45.0,
                    height: 45.0,
                    point: new LatLng(1, 1), //This is supposed to be the sent variable from chat's location marker. or fetch from active events?
                    builder: (context) => new Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.red,
                            iconSize: 45.0,
                            onPressed: () async {
                            },
                          ),
                        ))
              ])
            ]));
  }
  


  fetchthething() { //might have to fetch from users,activeevent,markerID to fetch marker? to find location of current activity goal? ALT - send that var from chat
    databaseReference.collection("markers").getDocuments().then((snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    print(snapshot.documents[1].data['coords'].latitude);
    print(snapshot.documents[1].documentID);
    removethething(snapshot.documents[1].documentID);
    });
  }

    removethething(index) { // snapshot data document ID (fetchthething)
      databaseReference.collection('markers').document(index).delete();
    }

  void _getCurrentLocation() async { // part of possible under-menu that appears when you click on marker.
   List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(userPos.latitude, userPos.longitude);
   Placemark placeMark  = placemark[0]; 
   String name = placeMark.name;
   String subLocality = placeMark.subLocality;
   String locality = placeMark.locality;
   String administrativeArea = placeMark.administrativeArea;
   String postalCode = placeMark.postalCode;
   String country = placeMark.country;
   String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
   //double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);        Usefull later for distance
  }

  underMenuIno() {
    //menu showing info when clicking on location, comming soon. tm*
  }

}