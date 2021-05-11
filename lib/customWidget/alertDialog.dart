import 'package:flutter/material.dart';

AlertDialog progressAlertDialog = AlertDialog(
  title: Row(children: [
    CircularProgressIndicator(),
    SizedBox(width: 25),
    Text('Saving Data')
  ],),
);