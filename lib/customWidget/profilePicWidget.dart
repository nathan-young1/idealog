import 'package:flutter/material.dart';
import 'package:idealog/design/colors.dart';

class ProfilePicture extends StatelessWidget {

  const ProfilePicture({
    Key? key,
    required this.photoUrl,
    required this.height,
    required this.width
  }) : super(key: key);

  final String photoUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: DarkBlue,
      ),
      child: ClipOval(child: Image.network(photoUrl,fit: BoxFit.fill)));
  }
}