class User {
  final String id;
  String fullName;
  final String email;
  final String photo;
  final String userRole;
  final int activeEvents;
  String desc;
 

  User({this.id, this.fullName, this.email,this.photo, this.userRole, this.activeEvents, this.desc});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        photo = data['photo'],
        userRole = data['userRole'],
        activeEvents=data['activeEvents'],
        desc=data['desc'];
        

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'photo': photo,
      'userRole': userRole,
      'photo': photo,
      'activeEvents': activeEvents,
      'desc':desc,
    };
  }
}
