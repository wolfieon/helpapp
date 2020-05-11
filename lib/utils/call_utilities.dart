import 'dart:math';

import 'package:compound/models/call.dart';
import 'package:compound/models/user.dart';
import 'package:compound/resources/call_methods.dart';
import 'package:compound/screens/callscreens/call_screen.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.id,
      callerName: from.fullName,
      callerPic: from.photo,
      receiverId: to.id,
      receiverName: to.fullName,
      receiverPic: to.photo,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
       Navigator.push(
           context,
           MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
      

    }
  }
}