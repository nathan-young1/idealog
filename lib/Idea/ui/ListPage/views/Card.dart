import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/Idea/ui/DetailPage/Detail.dart';
import 'package:idealog/Idea/ui/ListPage/code/SlidableList.dart';
import 'package:idealog/Idea/ui/ListPage/views/slideActions.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:provider/provider.dart';
import 'mainTile.dart';

class IdeaCard extends StatelessWidget{

  IdeaCard({required this.idea, Key? key}):super(key: key);
  final Idea idea;

  @override
  Widget build(BuildContext context) {
      return MultiProvider(
      providers:[ChangeNotifierProvider<Idea>.value(value: idea)],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 35),
        child:  GestureDetector(
          onTap: ()=> Navigator.push(context,
           MaterialPageRoute(builder: (context)=> IdeaDetail(idea: idea))),
    
          child: Slidable(
            key: UniqueKey(),
            movementDuration: Duration(milliseconds: 400),
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: 0.3,
            controller: SlidableList.instance.controller,
            secondaryActions: [
                      TaskAdderSlideAction(idea: idea),
                      DeleteSlideAction(idea: idea)
                      ],
            child: MainTile()
          ),
        ),
      ),
    );
  }
}