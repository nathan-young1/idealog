import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';
import 'package:idealog/idea/listPage/ui/addToExisting.dart';

class DetailAppBar extends StatelessWidget {
  DetailAppBar({required this.idea});

  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: LightGray,
      padding: EdgeInsets.only(top: 15,left: 20,right: 10),
      child: Column(
        children: [
          _IdeaAppBarButtons(idea: idea),
          Expanded(child: Padding(
            padding: EdgeInsets.only(left: 15,right: 15),
            child: Center(
              child: Text(idea.ideaTitle,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis)),
          )),
        ],
      ),
    );
  }
}

class _IdeaAppBarButtons extends StatelessWidget {
  final Idea idea;
  const _IdeaAppBarButtons({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
     IconButton(icon: Icon(FeatherIcons.arrowLeft,color: Black242424),
     iconSize: 35,
     onPressed: ()=>Navigator.pop(context)),
     Row(
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         IconButton(icon: Icon(Icons.add,size: 35,color: Black242424), onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddToExistingIdea(idea: idea)));
         }),
         SizedBox(width: 15),
         PopupMenuButton<int>(
                        iconSize: 33,
                        padding: EdgeInsets.zero,
                        onSelected: (_) async{ 
                          await IdeaManager.deleteIdeaFromDb(idea);
                          Navigator.pop(context);
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem<int>( 
                          value: 0,
                          child:  Container(
                            child: Row(
                              children: [
                              Icon(Icons.delete_sweep,size: 30,color: Black242424),
                              SizedBox(width: 10),
                              Text('Delete',style: TextStyle(fontSize: 18))
                            ],),
                          ),
                        )],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      )
      ],
    )
    ]);
  }
}