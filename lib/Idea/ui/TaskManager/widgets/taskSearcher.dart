import 'package:flutter/material.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';

// ignore: non_constant_identifier_names
Widget TaskSearchField({required int flex}){
  
  return Expanded(
              flex: flex,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  decoration: elevatedBoxDecoration,
                  child: TextField(
                    decoration: formTextField.copyWith(
                      hintText: 'Search for a task'
                    ),
                  ),
                ),
              ));
}