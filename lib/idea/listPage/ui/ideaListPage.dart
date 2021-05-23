import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'ideaCard.dart';

class IdeaListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<IdeaModel> listOfIdeas = Provider.of<List<IdeaModel>>(context);
    print('refreshed');
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25,left: 20,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('IDEAS',style: Poppins.copyWith(fontSize: 30)),
              Row(
                children: [
                  IconButton(icon: Icon(Icons.search_sharp), onPressed: (){},iconSize: 35),
                  IconButton(icon: Icon(Icons.filter_list), onPressed: (){},iconSize: 35)
                ],
              )
            ],
          ),
        ),
        Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: listOfIdeas.length,
                itemBuilder: (_,index) =>IdeaCard(idea: listOfIdeas[index]),
              ),
            ),
          )
         
      ],
    );
  }
}