import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';

import 'SearchNotifier.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Provider.of<SearchController>(context);

    return WillPopScope(
      onWillPop: ()async{
        (!searchController.searchIsActive)
        ?Navigator.pop(context)
        :SearchController.instance.stopSearch();

        // if the state is false, navigator pops the page not willPopScope
        // else the searchController changes the state to false, so the page do not pop
        return searchController.searchIsActive;
      },
      
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(FeatherIcons.arrowLeft,color: Black242424),
              iconSize: 35,
              onPressed: ()=> SearchController.instance.stopSearch()
            ),
    
            Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: "Task",
                  suffixIcon: IconButton(
                   onPressed: ()=> SearchController.instance.stopSearch(),
                   icon: Icon(Icons.close)
                   )
                ),
                onChanged: (String? value)=> SearchController.instance.searchFor(value),
              ),
            )
          ]
      ),
    );
  }
}