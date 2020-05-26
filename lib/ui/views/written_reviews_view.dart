import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/models/review.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../locator.dart';

class WrittenReviewsView extends StatefulWidget {
  final String id;
  @override
  WrittenReviewsView({this.id});
  State<StatefulWidget> createState() => _InspectWrittenReviewState(id: id);
}

final List<Review> reviews = [];
final db = Firestore.instance;
final AuthenticationService authService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();

class _InspectWrittenReviewState extends State<WrittenReviewsView> {
  String id;

_InspectWrittenReviewState({this.id});

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
          "Commitments",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          new Expanded(
            child: FutureBuilder(
                future: createList(id),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                                leading: FutureBuilder(
                                    future: _firestoreService
                                        .getUser(reviews[index].getTo),
                                    builder: (context, usernsnapshot) {
                                      if (usernsnapshot.connectionState ==
                                          ConnectionState.done) {
                                        User userx = usernsnapshot.data;
                                        return CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                NetworkImage(userx.photo));
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }),
                                title: Text(reviews[index].getToName,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600))),
                                subtitle: Text(
                                    "Good: " +
                                        reviews[index].getHappy.toString() +
                                        '\n' +
                                        'Description: ' +
                                        reviews[index].getDescription,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600))),
                                onTap: () {
                                  print(reviews[index].description);
                                }),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}

Future createList(String id) async {
  reviews.clear();
  User userData = await _firestoreService.getUser(id);
  QuerySnapshot snapshot = await db
      .collection("users")
      .document(userData.id)
      .collection("sentReviews")
      .getDocuments();
  for (var f in snapshot.documents) {
    Review newReview = Review(
        from: f.data['from'],
        to: f.data['to'],
        description: f.data['description'],
        happy: f.data['happy'],
        fromName: f.data['fromName'],
        toName: f.data['toName']);

    reviews.add(newReview);
  }
}
