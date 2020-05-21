import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/firestore_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/utils/call_utilities.dart';
import 'package:compound/utils/permissions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:compound/ui/views/user_profile_view.dart';

class Chat extends StatefulWidget {
  //static const String id = "CHAT";
  final User user;
  final User mottagare;

  const Chat({
    Key key,
    this.user,
    this.mottagare,
  }) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final Firestore _firestore = Firestore.instance;
  final NavigationService _navigationService = locator<NavigationService>();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    var today = DateTime.now();
    var date2 = today.millisecondsSinceEpoch;

    //print('This is the current user' + _currentUser.toString());

    if (messageController.text.length > 0) {
      //adda till sändarens collection samt mottagarens collection
      //duplicate code bara för att jag orkar inte, addar meddelanden till bägge users databas
      await _firestore
          .collection('chats')
          .document(widget.user.id)
          .collection(widget.mottagare.id)
          .add({
        'text': messageController.text,
        'from': widget.user.fullName,
        'date': date2.toString(),
      });
      await _firestore
          .collection('chats')
          .document(widget.mottagare.id)
          .collection(widget.user.id)
          .add({
        'text': messageController.text,
        'from': widget.user.fullName,
        'date': date2.toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
  }

  @override
  Widget build(BuildContext context) {
    if (User().email == null) {
      //loginUser();

    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Hero(
          tag: 'backbutton',
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.pop(context);
              //_navigationService.navigateTo(ChatListRoute);
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfilePage(widget.mottagare)),
                    );
                  },
                  child: CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(widget.mottagare.photo)),
                ),
                Text(
                  widget.mottagare.fullName,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.video_call,
              color: Colors.black,
            ),
            onPressed: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                        from: widget.user,
                        to: widget.mottagare,
                        context: context,
                      )
                    : {},
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .document(widget.user.id)
                    .collection(widget.mottagare.id)
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['from'],
                            text: doc.data['text'],
                            me: widget.user.fullName == doc.data['from'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextField(
                        onSubmitted: (value) => callback(),
                        decoration: InputDecoration(
                          hintText: "Enter a Message...",
                          border: const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(40))),
                        ),
                        controller: messageController,
                      ),
                    ),
                  ),
                  SendButton(
                    text: "Send",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getEmailCurrent() async {
    FirebaseUser userb = await _auth.currentUser();
    return userb.email.toString();
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 100,
      height: 60,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(color: Colors.black)),
        onPressed: callback,
        child: Text(text),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment:
              me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              from,
            ),
            Material(
              color: me ? Colors.teal : Colors.red,
              borderRadius: BorderRadius.circular(10.0),
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text(
                  text,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
