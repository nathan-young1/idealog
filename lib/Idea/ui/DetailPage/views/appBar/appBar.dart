import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/MultiSelectTile/Notifier.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/SearchBar/SearchBar.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

import 'appBarButtons.dart';
import 'multiSelectAction.dart';
import 'normalActions.dart';

class DetailAppBar extends StatelessWidget {
  
  DetailAppBar({required this.idea});

  final IdeaModel idea;

  @override
  Widget build(BuildContext context) {
    
    SearchController searchController = Provider.of<SearchController>(context);

    return Container(
      height: 250,
      color: LightGray,
      padding: EdgeInsets.only(top: 15,left: 20,right: 10),
      child: Column(
        children: [
          (searchController.searchIsActive)
          ?SearchAppBar()
          :IdeaAppBarButtons(idea: idea),
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