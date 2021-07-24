import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/ListPage/views/percentIndicator.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'ToggleSlidable.dart';
import 'ideaTitle.dart';

class MainTile extends StatelessWidget {
  const MainTile({
    Key? key,
    required this.idea,
    required this.slidableIconState,
  }) : super(key: key);

  final Idea idea;
  final ValueNotifier<bool> slidableIconState;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: slidableIconState,
      builder: (context, _slidableIsOpen,snapshot) {
        return Container(
          padding: EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 10),
          decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular((_slidableIsOpen)?0:10),
                      boxShadow: [
                        BoxShadow(offset: Offset(0,0),blurRadius: 10,color: Colors.black.withOpacity(0.2))
                      ]
                    ),
          child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PercentageIncidator(),
                      IdeaTitle(idea: idea),
                      ToggleSlidable(
                        slidableIsOpen: _slidableIsOpen
                      )
                    ],
                  ),
        );
      }
    );
  }
}