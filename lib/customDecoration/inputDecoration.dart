import 'package:flutter/material.dart';

InputDecoration underlineAndFilled = InputDecoration(
  filled: true,
  labelStyle: TextStyle(fontSize: 15),
  errorStyle: TextStyle(fontSize: 15),
  border: UnderlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15))
  )
);