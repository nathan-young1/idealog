import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:provider/provider.dart';

import 'ideaCard.dart';

class IdeaListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Idea> listOfIdeas = Provider.of<List<Idea>>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.only(top: 15,left: 20,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('IDEAS',style: TextStyle(fontSize: 27,fontWeight: FontWeight.w600)),
              Row(
                children: [
                  IconButton(icon: Icon(Icons.search_sharp), onPressed: (){},iconSize: 30),
                  IconButton(icon: Icon(Icons.filter_list), onPressed: (){},iconSize: 30)
                ],
              )
            ],
          ),
        ),
        Expanded(
            child: ListView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              shrinkWrap: true,
              children: listOfIdeas.map((idea) => IdeaCard(idea: idea)).toList(),
            ),
          )
         
      ],
    );
  }
}