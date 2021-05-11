import 'package:flutter/material.dart';

InputDecoration underlineAndFilled = InputDecoration(
  filled: true,
  border: UnderlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15))
  )
);