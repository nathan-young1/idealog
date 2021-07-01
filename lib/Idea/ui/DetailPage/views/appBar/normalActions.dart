import 'package:flutter/material.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/Others/AddTasks.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';

class NormalActions extends StatelessWidget {
  const NormalActions({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
         onPressed: ()=> SearchController.instance.startSearch(),
         icon: Icon(Icons.search_outlined),color: Black242424,iconSize: 30),
        SizedBox(width: 10),

        IconButton(
         icon: Icon(Icons.add,size: 32,color: Black242424),
         onPressed: () =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AddToExistingIdea(idea: idea)))
        ),
        SizedBox(width: 10),

        PopupMenuButton(
            iconSize: 30,
            padding: EdgeInsets.zero,
            onSelected: (_) async{ 
              await IdeaManager.deleteIdeaFromDb(idea);
              Navigator.pop(context);
            },

            itemBuilder: (BuildContext context) => [
                PopupMenuItem( 
                  child:  Container(
                    child: Row(
                      children: [
                      Icon(Icons.delete_sweep,size: 30,color: Black242424),
                      SizedBox(width: 10),
                      Text('Delete',style: TextStyle(fontSize: 18))
                    ]),
                  ),
                )
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          )
                     ],
    );
  }
}