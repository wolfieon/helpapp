import 'package:flutter/material.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/authentication_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        
        
        child: Text('Home'),
      ),
    );
  }
}
