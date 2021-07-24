import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
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
         icon: Icon(FeatherIcons.heart,size: 28,color: Black242424),
         onPressed: (){}
        ),
        SizedBox(width: 5),

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