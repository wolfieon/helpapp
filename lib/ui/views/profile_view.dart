import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileView> {
  //const ProfileView({Key key}) : super(key: key);
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService auth = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 1000,
        width: 500,
        child: Row(
          children: <Widget>[
            Expanded(
                child: FutureBuilder(
              future: _firestoreService.getUser(auth.currentUser.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print('Got It');
                  return displayProfile(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget displayProfile(context, snapshot) {
    User user = snapshot.data;
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Profil'),
          leading: FlatButton(
              textColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {}),
          actions: <Widget>[
            FlatButton(
                textColor: Colors.white,
                child: Text(
                  'HELP',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  print(user.fullName);
                  //String fullName= 'cool';
                  //AuthenticationService().updateFullname(fullName: fullName);
                })
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(user.photo),
            ),
            GestureDetector(
              onTap: () {
                print(user.fullName);
              },
              child: Container(
                height: 50,
                color: Colors.blue,
                child: Center(
                    child: Text(
                  "Email: ${user.fullName ?? 'Anonymous'}",
                )),
              ),
            ),
            Container(
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text(
                "Email: ${user.email ?? 'Anonymous'}",
              )),
            ),
            Container(
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text(
                "Role: ${user.userRole ?? 'Anonymous'}",
              )),
            ),
            Container(
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text(
                "Id: ${user.id ?? 'Anonymous'}",
              )),
            ),
            GestureDetector(
              onTap: () {
                navigateToChangePassword();
                print(user.fullName);
              },
              child: Container(
                height: 50,
                color: Colors.red,
                child: Center(
                    child: Text(
                  "Change password",
                )),
              ),
            ),
              GestureDetector(
              onTap: () {
                _showDialog(user);
                //todo ta bort kommentar i showDialog samt i destenationen för att aktivera funktionen bortkommenterad för att undvika misstag
                //_firestoreService.removeUser(user);
                print(user.fullName);
              },
              child: Container(
                height: 50,
                color: Colors.red,
                child: Center(
                    child: Text(
                  "Remove user",
                )),
              ),
            )
          ],
        ),
        bottomSheet: Container(
          width: double.infinity,
          height: 40.0,
          color: Colors.deepOrange,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Print user data',
                  style: TextStyle(
                    color: Colors.lime,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(width: 8.0),
                new IconButton(
                    icon: new Icon(Icons.supervisor_account),
                    color: Colors.black,
                    onPressed: () {
                      print('yeet');
                    }),
              ],
            ),
          ),
        ));
  }

  void _showDialog(User user) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Radera kontot ${user.fullName ?? 'Anonymous'}?"),
            content: new Text("Är du säker detta går ej att ångra"),
            actions: <Widget>[
              new FlatButton(
                  textColor: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Nej jag vill inte radera kontot")),
              new FlatButton(
                  textColor: Colors.red,
                  onPressed: () {
                    //_firestoreService.removeUser(user);
                  },
                  child: new Text("Ja jag vill radera kontot"))
            ],
          );
        });
  }

  void navigateToChangePassword() {
    _navigationService.navigateTo(ChangePasswordViewRoute);
  }
}
