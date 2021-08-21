import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/popupMenu.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskSearcher.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class SearchBar_ReorderPopup extends StatelessWidget {
  SearchBar_ReorderPopup({required this.idea, required this.searchFieldController});
  final Idea idea;
  final TextEditingController searchFieldController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        clearSearch(searchFieldController, context);
        if (ReorderListController.instance.reOrderIsActive){
            ReorderListController.instance.disableReordering();
            return false;
        }
        
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 35, top: 10),
        child: Consumer<ReorderListController>(
          builder: (context, reorderListController, _)=>
          // Show this menu on top if the list is not in reordering mode.
          (!reorderListController.reOrderIsActive)
          ?Container(
            child: Row(
              children: [
                TaskSearchField(flex: 4, context: context, searchFieldController: searchFieldController),
                PopupMenu_reorder(flex: 1)
              ]
            ),
          )
          // Show this menu if the list is in reorder mode.
          :Align(
            alignment: Alignment(1, 0),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 250,
                decoration: elevatedBoxDecoration.copyWith(color: Colors.white),
                child: TextButton.icon(
                  onPressed: () async {
                        clearSearch(searchFieldController, context);
                        await reorderListController.updateAndSaveTaskOrderIndex(idea, reorderListController);
                        },
                  icon: Icon(FeatherIcons.check),
                  label: Text('Save tasks order', style: dosis.copyWith(fontSize: 22))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ignore: camel_case_types
class SearchBar_MultiSelectPopup extends StatelessWidget {
  SearchBar_MultiSelectPopup({required this.searchFieldController});
  final TextEditingController searchFieldController;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        clearSearch(searchFieldController, context);
        if (MultiSelectController.instance.state){
            MultiSelectController.instance.stopMultiSelect();
            return false;
        }
        
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 35, top: 10),
        child: Consumer2<MultiSelectController, Idea>(
          builder: (context,MultiSelectController multiSelectController, Idea idea, _)=>
          // Show this menu on top if the list is not in multi-selection mode.
          (!multiSelectController.state)
          ?Container(
            child: Row(
              children: [
                TaskSearchField(flex: 4, context: context, searchFieldController: searchFieldController),
                PopupMenu_MultiSelect(flex: 1)
              ]
            ),
          )
          // Show this menu if the list is in multi-selection mode.
          :Align(
            alignment: Alignment(1, 0),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){ 
                  clearSearch(searchFieldController, context);
                  multiSelectController.multiDelete(idea);
                  },
              ),
            ),
          ),
        ),
      ),
    );
  }

}
