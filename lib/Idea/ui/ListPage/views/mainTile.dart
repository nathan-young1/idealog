import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/ListPage/code/SlidableList.dart';
import 'package:idealog/Idea/ui/ListPage/views/percentIndicator.dart';
import 'package:provider/provider.dart';
import 'ToggleSlidable.dart';
import 'ideaTitle.dart';

class MainTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SlidableList>(
      builder: (context, _,__) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SlidableList.isOpen(context)?0:10),
                      boxShadow: [
                        BoxShadow(offset: Offset(0,0),blurRadius: 10,color: Colors.black.withOpacity(0.2))
                      ]
                    ),
          child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PercentageIncidator(),
                      IdeaTitle(),
                      ToggleSlidable(),
                    ],
                  ),
        );
      }
    );
  }
}