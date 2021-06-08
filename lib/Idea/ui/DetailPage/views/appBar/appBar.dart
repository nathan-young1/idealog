import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/MultiSelectTile/Notifier.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

import 'multiSelectAction.dart';
import 'normalActions.dart';

class DetailAppBar extends StatelessWidget {
  
  DetailAppBar({required this.idea});

  final IdeaModel idea;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: LightGray,
      padding: EdgeInsets.only(top: 15,left: 20,right: 10),
      child: Column(
        children: [
          _IdeaAppBarButtons(idea: idea),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15,right: 15),
              child: Center(
                child: Text(idea.ideaTitle,
                style: Overpass.copyWith(fontSize: 35,fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis)),
          )),
        ],
      ),
    );
  }
}

class _IdeaAppBarButtons extends StatelessWidget {
  final IdeaModel idea;
  const _IdeaAppBarButtons({required this.idea});

  @override
  Widget build(BuildContext context) {
    MultiSelect multiSelectObj = Provider.of<MultiSelect>(context);
    return WillPopScope(
      onWillPop: ()async{
        (!multiSelectObj.state)
        ?Navigator.pop(context)
        :Provider.of<MultiSelect>(context,listen: false).stopMultiSelect();
        // if the state is false, navigator pops the page not willPopScope
        // else the multiselect function changes the state to false, so the page do not pop
        return multiSelectObj.state;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       IconButton(icon: Icon(FeatherIcons.arrowLeft,color: Black242424),
       iconSize: 35,
       onPressed: ()=> (!multiSelectObj.state)
       ?Navigator.pop(context)
       :Provider.of<MultiSelect>(context,listen: false).stopMultiSelect()
       ),
    
       (!multiSelectObj.state)
       ?NormalActions(idea: idea)
       :MultiSelectAction(idea: idea,selectedTasks: multiSelectObj.selectedTasks)
      ]),
    );
  }
}

