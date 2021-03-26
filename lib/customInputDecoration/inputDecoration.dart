import 'package:flutter/material.dart';

InputDecoration underlineAndFilled = InputDecoration(
  filled: true,
  border: UnderlineInputBorder(borderSide: BorderSide(width: 5.0),
  borderRadius: BorderRadius.only(topLeft:  Radius.circular(10),topRight: Radius.circular(10))),
);

InputDecoration addTasks = InputDecoration(
  filled: true,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.teal,width: 2)
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.teal,width: 2)
  )
);