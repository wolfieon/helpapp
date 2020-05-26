import 'package:compound/locator.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/recived_reviews_view.dart';
import 'package:compound/ui/views/written_reviews_view.dart';
import 'package:flutter/material.dart';
import 'package:compound/models/user.dart';
import 'package:google_fonts/google_fonts.dart';



class UserProfilePage extends StatelessWidget {
   final FirestoreService _firestoreService = locator<FirestoreService>();
 final String uid;
  UserProfilePage({this.uid});


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
              future: _firestoreService.getUser(uid),
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
         appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ), onPressed:  () async {
              Navigator.pop(context);
              //_navigationService.navigateTo(ChatListRoute);
            },),
          title: Text(
            '${user.fullName}s profile ',
            style: TextStyle(color: Colors.black),
          )),
        body: Column(children: <Widget>[
          SizedBox(height:screenHeight(context)/50),
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
              children: <Widget>[Icon(Icons.map), Text("Stad , Län")]),
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
          SizedBox(height: screenHeight(context)/75),
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
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => WrittenReviewsView(id:user.id)))
                },
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
                  
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewsView(id:user.id)))
                  },
                child: Row(
                  children: <Widget>[Icon(Icons.comment),Icon(Icons.arrow_right),],

                )
              ),
              
            ],
          ),
         

        
        ]));
  }




 
}