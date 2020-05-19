
import 'package:compound/models/user.dart';
import 'package:compound/provider/user_provider.dart';
import 'package:compound/screens/callscreens/pickup/pickup_layout.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/ui/views/chat_view.dart';
import 'package:compound/ui/views/home_view.dart';

import 'package:compound/ui/views/map_view.dart';
import 'package:compound/ui/views/notifications_view.dart';
import 'package:compound/ui/views/profile_view.dart';
import 'package:compound/ui/views/settings_view.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'chats_view.dart';


class MyBottomNagivation extends StatefulWidget {
  @override
  _MyBottomNagivationState createState() => _MyBottomNagivationState();
}




class _MyBottomNagivationState extends State<MyBottomNagivation> {
  final AuthenticationService auth = locator<AuthenticationService>();

UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });

    
  }
  
   int _currentIndex = 2;
  final List<Widget> _children = [
   Chats(), MenuOptionsScreen() , HomeView(), ProfileView(), NotificationsView() // create the pages you want to navigate between
  ];
  @override
  Widget build(BuildContext context) {
        
    return PickupLayout(
          scaffold: new Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.black,
          index: 2,
          onTap: (index){
            setState(() {
              this._currentIndex = index;
              
            });
            debugPrint("Current Index is $index");
          },
          height: 50,
          items: <Widget>[
          Icon(Icons.chat, size: 20, color: Colors.white,),
          Icon(Icons.settings, size: 20, color: Colors.white,),
          Icon(Icons.home, size: 20, color: Colors.white,),
          Icon(Icons.person, size: 20, color: Colors.white,),
          Icon(Icons.notifications, size: 20, color: Colors.white,),
          ],
          animationDuration: Duration(
            milliseconds: 200
          ),
          animationCurve: Curves.bounceInOut,

        ),
      ),
    );
    
  }}
