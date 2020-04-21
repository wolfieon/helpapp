import 'package:flutter/material.dart';

class Option {
  Icon icon;
  String title;
  String subtitle;

  Option({this.icon, this.title, this.subtitle});
}

final options = [
  Option(
    icon: Icon(Icons.dashboard, size: 40.0),
    title: 'Option One',
    subtitle: 'Titta.',
  ),
  Option(
    icon: Icon(Icons.do_not_disturb, size: 40.0),
    title: 'Option Two',
    subtitle: 'Text.',
  ),
  Option(
    icon: Icon(Icons.account_circle, size: 40.0),
    title: 'Option Three',
    subtitle: 'Kan skriva vad man vill.',
  ),
  Option(
    icon: Icon(Icons.ac_unit, size: 40.0),
    title: 'Option Four',
    subtitle: 'asdasd.',
  ),
  Option(
    icon: Icon(Icons.watch_later, size: 40.0),
    title: 'Option Five',
    subtitle: 'dsasda.',
  ),
  Option(
    icon: Icon(Icons.directions_railway, size: 40.0),
    title: 'Option Six',
    subtitle: 'sdasdasdasd.',
  ),
  Option(
    icon: Icon(Icons.local_airport, size: 40.0),
    title: 'Option Seven',
    subtitle: 'qweqweqwe.',
  ),
  Option(
    icon: Icon(Icons.add_shopping_cart, size: 40.0),
    title: 'Option Eight',
    subtitle: 'asdasdasdasdasd.',
  ),
];