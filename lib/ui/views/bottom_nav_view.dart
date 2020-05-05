
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/ui/views/chat_view.dart';
import 'package:compound/ui/views/home_view.dart';

import 'package:compound/ui/views/map_view.dart';
import 'package:compound/ui/views/profile_view.dart';
import 'package:compound/ui/views/settings_view.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../locator.dart';
import 'chats_view.dart';


class MyBottomNagivation extends StatefulWidget {
  @override
  _MyBottomNagivationState createState() => _MyBottomNagivationState();
}




class _MyBottomNagivationState extends State<MyBottomNagivation> {
  final AuthenticationService auth = locator<AuthenticationService>();
  
   int _currentIndex = 2;
  final List<Widget> _children = [
   Chats(), MapView() , HomeView(), ProfileView(), MenuOptionsScreen() // create the pages you want to navigate between
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Colors.deepPurple,
        index: 2,
        onTap: (index){
          setState(() {
            this._currentIndex = index;
          });
          debugPrint("Current Index is $index");
        },
        height: 50,
        items: <Widget>[
          Icon(Icons.chat, size: 20, color: Colors.black,),
          Icon(Icons.map, size: 20, color: Colors.black,),
          Icon(Icons.home, size: 20, color: Colors.black,),
          Icon(Icons.person, size: 20, color: Colors.black,),
          Icon(Icons.settings, size: 20, color: Colors.black,),
        ],
        animationDuration: Duration(
          milliseconds: 200
        ),
        animationCurve: Curves.bounceInOut,

      ),
    );
    
  }}
//   Future<FirebaseUser> loginUser() async {
//     FirebaseUser user = await auth.getCurrentUser();
//     return user;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Chat(
//           user: user,
//         ),
//       ),
//     );
//   }
// }