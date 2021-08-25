import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

class IdeaTitle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Idea idea = Provider.of<Idea>(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Center(child: Text(idea.ideaTitle,
        style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.large),
        overflow: TextOverflow.ellipsis)),
      ));
  }
}