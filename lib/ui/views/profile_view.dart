import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text('Profile')
      ),
    );
  }
}
