import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/looking_to_help_view.dart';
import 'package:compound/ui/views/need_help_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/authentication_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Hjälp App'),
      ),
      body: Column(
        children: <Widget>[
        SizedBox(height: 110),
        Align(
        alignment: Alignment.center,
        child: ButtonTheme(
        minWidth: screenWidth(context)/1.5,
        height: screenHeight(context)/6,
        child: RaisedButton(
          color: Colors.black45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Text("Jag behöver hjälp", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))),
                onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NeedHelpView()),
                  );
                }
              ),
            ),
        ),
        SizedBox(height: screenHeight(context)/10),
        Align(
        alignment: Alignment.center,
        child: ButtonTheme(
        minWidth: screenWidth(context)/1.5,
        height: screenHeight(context)/6,
        child: RaisedButton(
          color: Colors.black45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Text("Jag Vill Hjälpa", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))),
                onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LookingToHelp()),
                  );
                }
              ),
            ),
        ),
        ]
      ),
    );
  }
}