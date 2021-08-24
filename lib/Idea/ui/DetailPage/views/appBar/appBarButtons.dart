import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/global/routes.dart';
import 'actionButtons.dart';

class DetailAppBarButtons extends StatelessWidget {
  final Idea idea;
  const DetailAppBarButtons({required this.idea});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacementNamed(context, menuPageView);
        return false;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       IconButton(icon: Icon(FeatherIcons.arrowLeft,color: Black242424),
       iconSize: 35,
       onPressed: () async => await Navigator.pushReplacementNamed(context, menuPageView)
       ),
      
       ActionButtons(idea: idea)
      ]),
    );
  }
}

