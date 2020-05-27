import 'package:flutter/material.dart';

class Option {
  Icon icon;
  String title;
  String subtitle;

  Option({this.icon, this.title, this.subtitle});
}

final options = [
  Option(
    icon: Icon(Icons.account_circle, size: 40.0),
    title: 'Account settings',
    subtitle: 'Titta.',
  ),
  Option(
    icon: Icon(Icons.perm_identity, size: 40.0),
    title: 'Personal information',
    subtitle: 'Text.',
  ),
  Option(
    icon: Icon(Icons.group_add, size: 40.0),
    title: 'Invite',
    subtitle: 'Kan skriva vad man vill.',
  ),
  Option(
    icon: Icon(Icons.gavel, size: 40.0),
    title: 'User Terms',
    subtitle: 'asdasd.',
  ),
  Option(
    icon: Icon(Icons.remove_circle, size: 40.0),
    title: 'Report user',
    subtitle: 'dsasda.',
  ),
  Option(
    icon: Icon(Icons.block, size: 40.0),
    title: 'Block user',
    subtitle: 'sdasdasdasd.',
  ),
  
];