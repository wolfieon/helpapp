import 'package:compound/models/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MapView extends StatelessWidget {
  const MapView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}


final List<MarkObj> markers = [];
Position position;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    void init() {
    _getCurrentLocation();
  }

  final databaseReference = Firestore.instance;
  bool listMade = false;
  String _address = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new FlutterMap(
            options: new MapOptions(
                center: new LatLng(position.latitude, position.longitude), minZoom: 5.0, maxZoom: 18.0),
            layers: [

              new TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),

              new MarkerLayerOptions(markers: [
                new Marker(
                    width: 45.0,
                    height: 45.0,
                    point: new LatLng(position.latitude, position.longitude),
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
                    point: new LatLng(59.3293, 18.0686), //This is supposed to be the sent variable from chat's location marker. or fetch from active events?
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
   position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   print(position);
   List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
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

  underMenuIno() {
    //menu showing info when clicking on location, comming soon. tm*
  }

}