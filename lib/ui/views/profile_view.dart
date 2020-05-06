import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: screenHeight(context)/7,
          ),
          Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            minRadius: screenWidth(context)/6,
            backgroundColor: Colors.black45,
            child: Text('Profil namn', style: TextStyle(
              color: Colors.white
            ),),
            )
          ),
         SizedBox(
           height: screenHeight(context)/10,
         ),
         ButtonTheme(
          padding: EdgeInsets.all(10.0),
          minWidth: screenWidth(context)/1.2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: RaisedButton(
            color: Colors.grey,
              child: Text("Redigera Profil", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))), 
            onPressed: () {},
            ),
         ),
         SizedBox(
           height: screenHeight(context)/10,
         ),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
              ButtonTheme(
                minWidth: screenWidth(context)/3.3,
                height: 40,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: RaisedButton(
                  color: Colors.grey,
                  child: Text("Historik", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600))),
                  onPressed: () {},
                  ),
              ),
              ButtonTheme(
                height: 42,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: RaisedButton(
                  color: Colors.grey,
                  child: Text("Recensioner", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600))),
                  onPressed: () {},
                  ),
              ),
           ]
         )
        ],
      ),
    );
  }
}