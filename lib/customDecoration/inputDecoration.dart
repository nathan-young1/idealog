import 'package:flutter/material.dart';

InputDecoration underlineAndFilled = InputDecoration(
  labelStyle: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),
  filled: true,
  border: UnderlineInputBorder(borderSide: BorderSide(width: 5.0),
  borderRadius: BorderRadius.only(topLeft:  Radius.circular(10),topRight: Radius.circular(10))),
);