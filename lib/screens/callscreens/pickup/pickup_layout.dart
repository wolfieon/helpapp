import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/call.dart';
import 'package:compound/provider/user_provider.dart';
import 'package:compound/resources/call_methods.dart';
import 'package:compound/screens/callscreens/pickup/pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    

    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.id),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);
                print('UserProvider i PickupLayout' + userProvider.getUser.fullName.toString());
                if (!call.hasDialled) {
                  return PickupScreen(call: call);
                }
              }
              
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}