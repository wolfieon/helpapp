import 'package:cloud_firestore/cloud_firestore.dart';

class MarkObj {
  GeoPoint coords;
  String type;
  String name;
  String desc;
  String userID;
  String markerID;
  double distance;

  GeoPoint get getGeo {
    return coords;
  }

  String get getDesc {
    return desc;
  }

  String get getType {
    return type;
  }

  String get getName {
    return name;
  }

  String get getUserID {
    return userID;
  }

  String get getMarkerID {
    return markerID;
  }

  double get getDistance {
    return distance;
  }

  MarkObj({
    this.coords,
    this.type,
    this.name,
    this.desc,
    this.userID,
    this.markerID,
    this.distance,
  });

  MarkObj.fromData(Map<String, dynamic> data)
      : coords = data['coords'],
        name = data['name'],
        type = data['type'],
        userID = data['userID'],
        desc = data['desc'],
        markerID = data['markerID'],
        distance = data['distance'];
}
