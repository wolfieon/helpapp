import 'package:flutter/widgets.dart';

class Review {
  final String from;
  final String to;
  final String description;
  final bool happy;
  final String fromName;
  final String toName;

  Review({
    @required this.from,
    @required this.to,
    this.description,
    this.happy,
    this.fromName,
    this.toName
  });

  Review.fromData(Map<String, dynamic> data)
      : from = data['from'],
        to = data['to'],
        description = data['description'],
        happy = data['happy'],
        fromName = data['fromName'],
        toName = data['toName'];

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'description': description,
      'happy': happy,
      'fromName': fromName,
      'toName': toName
    };
  }

  String get getFrom {
    return from;
  }

  String get getTo {
    return to;
  }

  String get getDescription {
    return description;
  }

  bool get getHappy {
    return happy;
  }
   String get getFromName {
    return fromName;
  }
   String get getToName {
    return toName;
  }

  Map<String, dynamic> toJsonSwap() {
    return {
      'from': to,
      'to': from,
      'description': description,
      'happy': happy,
    };
  }
}
