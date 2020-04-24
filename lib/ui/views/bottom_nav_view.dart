import 'package:compound/constants/route_names.dart';
import 'package:compound/ui/views/chat_view.dart';
import 'package:compound/ui/views/home_view.dart';
import 'package:compound/ui/views/login_view.dart';
import 'package:compound/ui/views/settings_view.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyBottomNagivation extends StatefulWidget {
  @override
  _MyBottomNagivationState createState() => _MyBottomNagivationState();
}




class _MyBottomNagivationState extends State<MyBottomNagivation> {
  
   int _currentIndex = 1;
  final List<Widget> _children = [
   Chat(), HomeView(), MenuOptionsScreen() // create the pages you want to navigate between
  ];
  
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index){
          setState(() {
            this._currentIndex = index;
          });
          debugPrint("Current Index is $index");
        },
        height: 50,
        items: <Widget>[
          Icon(Icons.chat, size: 20, color: Colors.black,),
          Icon(Icons.home, size: 20, color: Colors.black,),
          Icon(Icons.settings, size: 20, color: Colors.black,),
        ],
        animationDuration: Duration(
          milliseconds: 200
        ),
        index: 1,
        animationCurve: Curves.bounceInOut,

      ),
      
    );
  }
}