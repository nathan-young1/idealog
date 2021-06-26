import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/SearchBar/SearchBar.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/SearchBar/SearchNotifier.dart';
import 'package:idealog/Idea/ui/ListPage/views/Card.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

class IdeaListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // All the ideas should be in reverse so that the latest will be on top
    var listOfIdeas = Provider.of<List<IdeaModel>>(context).reversed.where(_searchTermExists).toList();
    SearchController searchController = Provider.of<SearchController>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25,left: 20,right: 10,bottom: 10),
          child: (searchController.searchIsActive)
          ?SearchAppBar(hintText: 'Idea')
          :IdeasAppBar(),
        ),
        Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: listOfIdeas.length,
                itemBuilder: (_,index) => IdeaCard(idea: listOfIdeas[index],
                slidableIconState: ValueNotifier(false)),
              ),
            ),
          )
         
      ],
    );
  }
}

class IdeasAppBar extends StatelessWidget {
  const IdeasAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('IDEAS',style: Poppins.copyWith(fontSize: 30)),
        Row(
          children: [
            IconButton(icon: Icon(Icons.search_sharp),
            onPressed: ()=> SearchController.instance.startSearch(),
            iconSize: 32),
            IconButton(icon: Icon(Icons.filter_list), onPressed: (){},iconSize: 32)
          ],
        )
      ],
    );
  }
}

// check if the search term exists in the list
bool _searchTermExists(IdeaModel idea)=> idea.ideaTitle.contains(SearchController.instance.searchTerm);