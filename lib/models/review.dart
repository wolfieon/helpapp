import 'package:flutter/widgets.dart';

class Review {
  final String from;
  final String to;
  final String description;
  final bool happy;
  

  Review({@required this.from, @required this.to,this.description,this.happy, });

  Review.fromData(Map<String, dynamic> data)
      : from = data['from'],
        to = data['to'],
        description = data['description'],
        happy = data['happy'];

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'description' : description,
      'happy' : happy,
    };
  }

  Map<String, dynamic> toJsonSwap() {
    return {
      'from': to,
      'to': from,
      'description' : description,
      'happy' : happy,
      
    };
  }
}
