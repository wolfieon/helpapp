import 'package:compound/models/chat.dart';
import 'package:compound/models/helprequest.dart';
import 'package:compound/models/review.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/chat_view.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../locator.dart';

class ReviewView extends StatefulWidget {
  @override
  final User otherUser;
  final User me;
  

  const ReviewView({Key key, this.otherUser, this.me}) : super(key: key);

  @override
  _ReviewViewState createState() => _ReviewViewState();
}
final FirestoreService _firestoreService = locator<FirestoreService>();
 final reviewController = TextEditingController();


bool happy;
bool sad;
Color colorhappy = Colors.grey;
Color colorsad = Colors.grey;

class _ReviewViewState extends State<ReviewView> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 34, 0, 0),
                        child: CircleAvatar(
                          radius: 80.0,
                          backgroundImage: NetworkImage(widget.otherUser.photo),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text("Are you happy with the help?",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                              iconSize: 62,
                              icon: Icon(Icons.mood, color: colorhappy,),
                              onPressed: () {
                                setState(() {
                                  happy = true;
                                  sad = false;
                                  colorhappy = Colors.lightBlueAccent;
                                  colorsad = Colors.grey;
                                });
                              }),
                          IconButton(
                              iconSize: 62,
                              icon: Icon(Icons.mood_bad, color: colorsad),
                              onPressed: () {
                                setState(() {
                                  sad = true;
                                  happy = false;
                                  colorsad= Colors.lightBlueAccent;
                                  colorhappy = Colors.grey;

                                });
                              }),
                        ],
                      ),
                      verticalSpace(21),
                      Container(
                        height: 100,
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.3,
                            color: Colors.lightBlueAccent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
    controller: reviewController,
    textInputAction: TextInputAction.newline,
    keyboardType: TextInputType.multiline,
    maxLines: 13,
  ),
                      ),
                      verticalSpace(35),
                      ButtonTheme(
                    minWidth: 300.0,
                    height: 75.0,
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("Send Review",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600))),
                      onPressed: () async { 
                        //create review notification for recivier, and store the review for the reciverer
                                      Review rev = new Review(from: widget.me.id, to: widget.otherUser.id, description: reviewController.text, happy: happy,);
                                      _firestoreService.sendReviewNotificationAndStore(rev);
                                      Helprequest req = new Helprequest(sender: widget.otherUser.id, reciever: widget.me.id);
                                      await _firestoreService.deleteAcceptRequest(req);
                                      Chatters chat = new Chatters(messengerid1: widget.otherUser.id, messengerid2: widget.me.id);
                                      await _firestoreService.deleteChat(chat);
                                      Navigator.pop(context);










                       
                      },
                    )),
                    ],
                  ),
        ),
      ),
    );
  }

  sendToChat(User reciver, User sender, context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewView(
          me: reciver,
          otherUser: sender,
        ),
      ),
    );
  }
}
