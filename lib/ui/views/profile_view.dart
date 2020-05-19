
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/change_password_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          SizedBox(
            height: screenHeight(context) / 7,
          ),
          Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: NetworkImage("${user.photo}"),
                backgroundColor: Colors.transparent,
              )),
          SizedBox(
            height: screenHeight(context) / 10,
          ),
          ButtonTheme(
            padding: EdgeInsets.all(10.0),
            minWidth: screenWidth(context) / 1.2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: RaisedButton(
              color: Colors.grey,
              child: Text("Namn: ${user.fullName ?? 'Anonymous'}",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600))),
              onPressed: () {
                print(user.id);
                print('activeEvents: ');
                print(user.activeEvents);

              },
            ),
          ),
          SizedBox(
            height: screenHeight(context) / 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                minWidth: screenWidth(context) / 3.3,
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: RaisedButton(
                  color: Colors.grey,
                  child: Text("Ändra användaruppgifter",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordView(),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                height: 42,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: RaisedButton(
                  color: Colors.grey,
                  child: Text("Radera kontot",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600))),
                  onPressed: () {
                    _showDialog(user);
                    //todo ta bort kommentar i _showDialog samt i destenationen för att aktivera funktionen bortkommenterad för att undvika misstag
                    print(user.fullName);
                    print("Den fungerar men är opraktiskt om den kör");
                  },
                ),
              ),
            ],
          )
        ]));
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
                    _firestoreService.removeUser(user);
                    print(
                        "Konto skulla vara borta om koden ovan denna skulle vara bor kommenterad");
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