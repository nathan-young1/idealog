import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Idea/ui/ListPage/views/Card.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/DoesNotExist.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskSearcher.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'code/SlidableList.dart';

class IdeaListPage extends StatelessWidget {
  IdeaListPage({required this.searchFieldController});
  final TextEditingController searchFieldController;
  
  @override
  Widget build(BuildContext context) {

    return Consumer2<SearchController, List<Idea>>(
      builder:  (_, searchController, ideaListFromProvider, __){
        // All the ideas should be in reverse so that the latest will be on top
        var listOfIdeas = ideaListFromProvider.reversed.where(searchTermExistsInIdea).toList();

        return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: SlidableList.instance)],
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25,left: 20,right: 10,bottom: 10),
              child: _AppBar(searchFieldController: searchFieldController),
            ),
            
            // check if there is data in the idealogDb after initialization, in other to know whether to show idea is not available or not.
            FutureBuilder<List<Map< String, dynamic>>>(
              future: IdealogDb.instance.allIdeasInJsonFormat,
              builder: (context, snapshot){
              // show this illustration if there is no idea in the database.
              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty) return IdeaDoesNotExistIllustration();
              // toggle between the widget depending on if the search term exists in the list.
              else if(listOfIdeas.isEmpty && SearchController.instance.searchIsActive) return SearchNotFoundIllustration(); 

              else return Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: listOfIdeas.length,
                      itemBuilder: (BuildContext context, index) => IdeaCard(idea: listOfIdeas[index], key: UniqueKey()),
                    ),
                  ),
                );
              })
             
          ],
        ),
      );
      },
    );
  }
}



class _AppBar extends StatelessWidget {
  _AppBar({required this.searchFieldController});
  final TextEditingController searchFieldController;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        // if the user is searching just stop search, do not pop otherwise pop the screen.
        if(SearchController.instance.searchIsActive){
          clearSearch(searchFieldController, context);
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('IDEAS',style: dosis.copyWith(fontSize: 30)),
    
          Consumer<List<Idea>>(
            builder:(_, listOfIdeas, __)=>
            // Only show a search bar if there is any idea in the database.
            (listOfIdeas.isNotEmpty)
             ?Align(
              alignment: Alignment.center,
              child: IdeaSearchField(context: context, searchFieldController: searchFieldController))
             :Container(),
          )
        ],
      ),
    );
  }
}

