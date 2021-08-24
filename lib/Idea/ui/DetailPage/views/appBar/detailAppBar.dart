import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

import 'appBarButtons.dart';

class DetailAppBar extends StatelessWidget {
  
  DetailAppBar({required this.idea});

  final Idea idea;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 250,
      color: LightGray,
      padding: EdgeInsets.only(top: 15,left: 20,right: 10),
      child: Column(
        children: [
          DetailAppBarButtons(idea: idea),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15,right: 15),
              child: Center(
                child: Text(idea.ideaTitle,
                style: dosis.copyWith(fontSize: 35,fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis)),
          )),
        ],
      ),
    );
  }
}