import 'package:flutter/material.dart';
import 'package:idealog/design/colors.dart';

InputDecoration underlineAndFilled = InputDecoration(
  labelStyle: TextStyle(fontSize: 16),
  filled: true,
  fillColor: LightGray,
  border: UnderlineInputBorder(borderSide: BorderSide(width: 10,color: Colors.grey[600]!),
  borderRadius: BorderRadius.only(topLeft:  Radius.circular(10),topRight: Radius.circular(10))),
);