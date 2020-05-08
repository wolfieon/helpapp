import 'package:compound/models/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//This map widget is in a state of chaos, please ask daniel to fix his shit :D


class MapView extends StatelessWidget {
  const MapView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

//marker list
final List<MarkObj> markers = [];

// ends here


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final databaseReference = Firestore.instance;
  bool listMade = false;
  String _address = "";

  void _getCurrentLocation() async {
   final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new FlutterMap(
            options: new MapOptions(
                center: new LatLng(59.3293, 18.0686), minZoom: 5.0, maxZoom: 18.0),
            layers: [

              new TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),

              new MarkerLayerOptions(markers: [
                new Marker(
                    width: 45.0,
                    height: 45.0,
                    point: new LatLng(59.3293, 18.0686),
                    builder: (context) => new Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.red,
                            iconSize: 45.0,
                            onPressed: () async {
                              //_getCurrentLocation();
                              //print('WOAH');
                              await listthething2();
                              await sorthething();
                            },
                          ),
                        ))
              ])
            ]));
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

    removethething(index) { // snapshot data document ID (fetchthething)
      databaseReference.collection('markers').document(index).delete();
    }


    dothething() {
      print('started');
      double distanceInMeters = Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838) as double;
      print(distanceInMeters);
      print('stopped');
    }
}






// generate new marker, upload to collection
// lock from posting more?
// await request? - not part of this function


// show map currently
//  fetch X marker (x for data) (if no current, ignore)
//  Print marker fetched + your own geo location circle


// TODO list order
// - Fetch marker list
// Run for list - sort by distance to user (Get user getlocation) run geodistance in foreach loop for each marker
// make a new list, with distance new variable.
// print list in stack order 


// if print list selected, push friend request, lock out of active requests?


// Delete marker --- Check also if marker deleted, undo the block and undo friendlist +markers