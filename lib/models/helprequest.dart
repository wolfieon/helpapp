import 'package:flutter/widgets.dart';

class Helprequest {
  final String sender;
  final String reciever;
  final String date;
  final String requestType;

  
 

  Helprequest({@required this.sender, @required this.reciever, this.date, this.requestType});

  Helprequest.fromData(Map<String, dynamic> data)
      : sender = data['sender'],
        reciever= data['reciever'],
        date= data['date'],
        requestType = data['requestType'];
        

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'reciever': reciever,
      'date': DateTime.now().toIso8601String().toString(),
      'requestType': requestType,
      
    };
  }
}
