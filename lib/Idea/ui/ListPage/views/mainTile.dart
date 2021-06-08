import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/ListPage/views/percentIndicator.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'ToggleSlidable.dart';
import 'ideaTitle.dart';

class MainTile extends StatelessWidget {
  const MainTile({
    Key? key,
    required this.percent,
    required this.idea,
    required this.slidableIconState
  }) : super(key: key);

  final double percent;
  final IdeaModel idea;
  final ValueNotifier<bool> slidableIconState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 10),
      decoration: BoxDecoration(
                  color: IdeaCardLight,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PercentageIncidator(percent: percent),
                  IdeaTitle(idea: idea),
                  ToggleSlidable(
                    slidableIconState: slidableIconState
                  )
                ],
              ),
    );
  }
}