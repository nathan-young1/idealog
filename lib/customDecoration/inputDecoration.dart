import 'package:flutter/material.dart';

final InputDecoration formTextField = InputDecoration(
  filled: true,
  hintStyle: TextStyle(fontSize: 15),
  errorStyle: TextStyle(fontSize: 15),
  border: UnderlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(5)
  ),
);

final BoxDecoration elevatedBoxDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
    offset: Offset(0,0),
    blurRadius: 10,
    color: Colors.black.withOpacity(0.2))
  ]
);