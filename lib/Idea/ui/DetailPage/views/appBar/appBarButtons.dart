import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'normalActions.dart';

class IdeaAppBarButtons extends StatelessWidget {
  final Idea idea;
  const IdeaAppBarButtons({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
     IconButton(icon: Icon(FeatherIcons.arrowLeft,color: Black242424),
     iconSize: 35,
     onPressed: ()=> Navigator.pop(context)
     ),
    
     NormalActions(idea: idea)
    ]);
  }
}

