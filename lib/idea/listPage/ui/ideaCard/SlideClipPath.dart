import 'package:flutter/material.dart';

class SlidableIconContainerClipper extends CustomClipper<Path> {
  
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.arcToPoint(Offset(width * 0.1, height * 0.1),radius: Radius.circular(10));
    path.lineTo(width * 0.1, height * 0.9);
    path.arcToPoint(Offset(0,height),radius: Radius.circular(10));
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}