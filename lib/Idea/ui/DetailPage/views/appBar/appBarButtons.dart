import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'actionButtons.dart';

class DetailAppBar extends StatelessWidget {
  final Idea idea;
  const DetailAppBar({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
     IconButton(icon: Icon(FeatherIcons.arrowLeft,color: Black242424),
     iconSize: 35,
     onPressed: ()=> Navigator.pop(context)
     ),
    
     ActionButtons(idea: idea)
    ]);
  }
}

