import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';

class IdeaTitle extends StatelessWidget {
  const IdeaTitle({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final IdeaModel idea;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text(idea.ideaTitle,
      style: ReemKufi.copyWith(fontSize: 30),
      overflow: TextOverflow.ellipsis)));
  }
}