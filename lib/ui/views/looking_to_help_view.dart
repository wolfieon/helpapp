import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LookingToHelp extends StatefulWidget{
  @override
  _LookingToHelpState createState() => _LookingToHelpState();
}

class _LookingToHelpState extends State<LookingToHelp> {
bool groVal = true;
bool socVal = true;
bool tekVal = true;
List<String> testList = [
  "Test1","Test2","Test3","Test4","Test4","Test5","Test6","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
  "Test","Test","Test","Test","Test","Test","Test","Test","Test","Test",
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hjälp App"),
        backgroundColor: Colors.white,
      ), 
      body: ListView.builder(
        itemCount: testList.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
                title: Text(testList[index]),
                onTap: () {
                },
              ),
            );
          } 
        ),
      bottomSheet: Container(
      width: screenWidth(context),
      height: screenHeight(context)/6,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(height:20),
          Text("Visa Endast", style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),),
          SizedBox(height:10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Text("Sociala"),
                      Checkbox(
                          value: socVal,
                          onChanged: (bool value) {
                              setState(() {
                                  socVal = value;
                              });
                          },
                      ),
                  ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Text("Tekniska"),
                      Checkbox(
                          value: tekVal,
                          onChanged: (bool value) {
                              setState(() {
                                  tekVal = value;
                              });
                          },
                      ),
                  ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Text("Matvaror"),
                      Checkbox(
                          value: groVal,
                          onChanged: (bool value) {
                              setState(() {
                                  groVal = value;
                              });
                          },
                      ),
                  ],
              ),
            ]
          )
        ],
      ),
    ),
    );
  }
}