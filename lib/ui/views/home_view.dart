import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/looking_to_help_view.dart';
import 'package:compound/ui/views/need_help_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:social_share_plugin/social_share_plugin.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    
      
      body: Column(
        children: <Widget>[
          SizedBox( height: screenHeight(context)/15),
        SizedBox(height: screenHeight(context)/3.8,
                       child: Image.asset('assets/images/hand.png'),
        ),
        SizedBox(height: screenHeight(context)/25),
        Align(
        alignment: Alignment.center,
        child: ButtonTheme(
        minWidth: screenWidth(context)/1.5,
            height: screenHeight(context)/10,
            child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),      
            color: Colors.black45,
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
        SizedBox(height: screenHeight(context)/14),
        Align(
        alignment: Alignment.center,
        child: ButtonTheme(
        minWidth: screenWidth(context)/1.5,
        height: screenHeight(context)/10,
        child: RaisedButton(
          color: Colors.black45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: Text("Jag vill hjälpa", style: GoogleFonts.openSans(
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
        SizedBox(height: screenHeight(context)/16),     
        Text("Dela på twitter", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600))),
          Align(
            alignment: Alignment.center,
            child: ButtonTheme(
              child: IconButton(
                iconSize: screenHeight(context)/15,
                icon: Icon(EvaIcons.twitter, color: Colors.blue), 
              onPressed: () async {
                String url = '[insert helpapp link here]';
                final text =
                    'This is a free marketing ploy not only for us, but for you too!';
                final result = await SocialSharePlugin.shareToTwitterLink(
                    text: text,
                    url: url,
                    onSuccess: (_) {
                      print('TWITTER SUCCESS');
                      return;
                    },
                    onCancel: () {
                      print('TWITTER CANCELLED');
                      return;
                    });
                print(result);
              },
            ),
          ),
        ),
           SizedBox(height: screenHeight(context)/10),
        ]
      ),
    );
  }
}