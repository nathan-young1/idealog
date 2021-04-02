import 'package:flutter/material.dart';

AlertDialog progressAlertDialot = AlertDialog(
  title: Row(children: [
    CircularProgressIndicator(),
    SizedBox(width: 25),
    Text('Saving Data')
  ],),
);