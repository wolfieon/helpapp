import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/ui/views/login_view.dart';
import 'package:flutter/material.dart';



class ProfileView extends StatelessWidget {

  final AuthenticationService auth = locator<AuthenticationService>();  
  final FirestoreService _firestoreService = locator<FirestoreService>();
  @override
  
  Widget build(BuildContext context) {

  



    return SingleChildScrollView(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: _firestoreService.getUser(auth.currentUser.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayUserInformation(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
  

  Widget displayUserInformation(context, snapshot) {
    User user = snapshot.data;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Name: ${user.fullName ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Email: ${user.email ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Role: ${user.userRole ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Id: ${user.id ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(user.photo),
        ),
        showSignOut(context),

        
      ],
    );
  }
  

 Widget showSignOut(context) {
    
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          try {
            await auth.signOut();
            
  auth.signOut();
      Navigator.popUntil(context, ModalRoute.withName('/'));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()),);

          } catch (e) {
            print(e);
          }
        },
      );
    }
    
  }
