import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String fullName;
  final String email;
  final String photo;
  final String userRole;
  final int activeEvents;
  String desc;
  GeoPoint lastSeen;
  final int happyCount;
  final int sadCount;
 

  User({this.id, this.fullName, this.email,this.photo, this.userRole, this.activeEvents, this.desc, this.lastSeen,this.happyCount, this.sadCount, });

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        photo = data['photo'],
        userRole = data['userRole'],
        activeEvents=data['activeEvents'],
        desc=data['desc'],
        lastSeen = data['lastSeen'],
        happyCount = data['happyCount'],
        sadCount = data['sadCount']
        ;
        

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'photo': photo,
      'userRole': userRole,
      'activeEvents': activeEvents,
      'desc':desc,
      'lastSeen':lastSeen,
      'happyCount':happyCount,
      'sadCount': sadCount,

    };
  }
}
