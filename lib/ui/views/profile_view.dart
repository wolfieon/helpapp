
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/change_password_view.dart';
import 'package:compound/ui/views/recived_reviews_view.dart';
import 'package:compound/ui/views/written_reviews_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

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
        height: screenHeight(context) -50,
        width: screenWidth(context),
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
          GestureDetector(
            //top lådan med pennan etc
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordView(),
                ),
              );
            },
            child: SizedBox(
              height: screenHeight(context) / 7,
              width: screenWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        //SizedBox(height: screenHeight(context) / 15),
                        //editprofile
                        Column(children: <Widget>[
                          Text("Edit profile",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600))),
                        ]),

                        // pen icon
                        Column(children: <Widget>[
                          Icon(Icons.edit),
                        ]),
                      ]),
                  SizedBox(
                    width: screenWidth(context) / 20,
                  ),
                ],
              ),
            ),
          ),
          Row(
            //bilden
            children: <Widget>[
              SizedBox(
                width: (screenWidth(context) / 2) - (screenWidth(context) / 8),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: screenWidth(context) / 8,
                    backgroundImage: NetworkImage("${user.photo}"),
                    backgroundColor: Colors.transparent,
                  )),
            ],
          ),
          Row(
            //namnet under bilden
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: screenHeight(context) / 20,
              ),
              Text("${user.fullName}",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600)))
            ],
          ),
          SizedBox(
            height: screenHeight(context) / 50,
          ),
          Row(
              //ska förmodligen bort men gjorde för att imitera desigen
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Icon(Icons.map), Text("Stockholm , Stockholm county")]),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Column(
              children: <Widget>[Icon(Icons.tag_faces), Text("${user.happyCount}")],
            ),
            SizedBox(width: screenWidth(context) / 20),
            Column(
              children: <Widget>[Icon(Icons.mood_bad), Text("${user.sadCount}")],
            ),
            SizedBox(width: screenWidth(context) / 15)
          ]),
          Row(
            //skriver bara om mig
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: screenWidth(context) / 15,
              ),
              Text("About me",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)))
            ],
          ),
          Row(
            // user desc,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: screenWidth(context) / 15,
              ),
              Container(
                width: screenWidth(context) -
                    (screenWidth(context) / 15 + screenWidth(context) / 15),
                height: screenHeight(context) / 5,
                child: Text(
                    "${user.desc ?? "Detta är så att inte skiten ska crasha om du inte har en desc i din user på firebase, Se konto W3EifD6........ om du inte försår hur det ska se ut."}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 7,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(110, 110, 110, 1),
                            fontSize: 11,
                            fontWeight: FontWeight.w600))),
              ),
              SizedBox(
                width: screenWidth(context) / 15,
              ),
            ],
          ),
          // todo lägg till grått sträck?
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: screenWidth(context) / 15,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text("Commitments",
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)))),
              SizedBox(
                width: screenWidth(context) / 50,
              ),
              Icon(Icons.view_headline),
              SizedBox(
                width: screenWidth(context) / 2.4,
              ),
              
              GestureDetector(
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => WrittenReviewsView(id: user.id)))},
                child: Row(
                  children: <Widget>[Icon(Icons.mode_comment),Icon(Icons.arrow_right),],

                )
              ),
              
            ],
          ),
          SizedBox(height: screenHeight(context)/20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: screenWidth(context) / 15,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text("Reviews",
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)))),
              SizedBox(
                width: screenWidth(context) / 50,
              ),
              Icon(Icons.tag_faces),
              SizedBox(
                width: screenWidth(context) / 50,
              ),
              Icon(Icons.mood_bad),
              SizedBox(
                width: screenWidth(context) / 2.26,
              ),
              
              GestureDetector(
                onTap: () => {
                  
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewsView(id: user.id)))},
                child: Row(
                  children: <Widget>[Icon(Icons.comment),Icon(Icons.arrow_right),],

                )
              ),
              
            ],
          ),
         

        
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