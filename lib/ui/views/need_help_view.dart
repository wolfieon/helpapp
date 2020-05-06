import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class NeedHelpView extends StatefulWidget{
  @override
  _NeedHelpViewState createState() => _NeedHelpViewState();
}

enum Services { Matvaror, Socialt, Teknisk }
Services _services = Services.Matvaror;

class _NeedHelpViewState extends State<NeedHelpView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
        children: <Widget>[      
            SizedBox(height: 110),
            Align(
                  child: Text("Vilken typ av hjälp behöver du?", style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600))),
        ),
        SizedBox(height: 20),
      Align(
      child: RadioListTile<Services>(
        title: const Text('Matvaror'),
        value: Services.Matvaror,
        groupValue: _services,
        onChanged: (Services value) { setState(() { _services = value; }); },
            ),
          ),
          Align(
        child: RadioListTile<Services>(
        title: const Text('Socialt'),
        value: Services.Socialt,
        groupValue: _services,
        onChanged: (Services value) { setState(() { _services = value; }); },
           ),
          ),
          Align(
        child: RadioListTile<Services>(
        title: const Text('Teknisk'),
        value: Services.Teknisk,
        groupValue: _services,
        onChanged: (Services value) { setState(() { _services = value; }); },
           ),
          ),
          SizedBox(height: 40),
            Align(
                  child: Text("Beskriv vad du behöver hjälp med?", style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w600))),
        ),
        SizedBox(height:20),
        Align(
        child:Container(
          width: screenWidth(context)-70,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: new TextField(
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      ),
    )
        ),

        SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          ButtonTheme(
            height: 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: RaisedButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Text("Avbryt", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
          ),
        ButtonTheme(
        height: 50,
        child: RaisedButton(
          color: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Text("Godkänn", style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600))),
          onPressed: () {
               },
              ),
            ),
          ]
        )
        ],
        ),
      )
    );
  }
}