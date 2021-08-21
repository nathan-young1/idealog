import 'package:flutter/material.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';

// ignore: non_constant_identifier_names
Widget TaskSearchField({required int flex, required BuildContext context, required TextEditingController searchFieldController}){

  return Expanded(
              flex: flex,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  decoration: elevatedBoxDecoration,
                  child: TextField(
                    controller: searchFieldController,
                    decoration: formTextField.copyWith(
                      labelText: 'Search for a task',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: ()=> clearSearch(searchFieldController, context))
                    ),
                    onChanged: onSearchFieldChanged,
                  ),
                ),
              ));
}

// ignore: non_constant_identifier_names
Widget IdeaSearchField({required BuildContext context, required TextEditingController searchFieldController}){
  
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        controller: searchFieldController,
        decoration: formTextField.copyWith(
          labelText: 'Search for an idea',
          fillColor: LightGray,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: ()=> clearSearch(searchFieldController, context))
        ),
        onChanged: onSearchFieldChanged
      ),
    ),
  );
}


/// Stops the search controller from searching and clear the text in the text field then dismisses the keyboard.
void clearSearch(TextEditingController searchFieldController, BuildContext context){
  SearchController.instance.stopSearch();
  searchFieldController.clear();
  FocusScope.of(context).unfocus();
}

/// Update the search controller as the user is typing.
void onSearchFieldChanged(String? value){
  // if the search controller is not on turn it on.
  if (!SearchController.instance.searchIsActive) SearchController.instance.startSearch();
  SearchController.instance.searchFor(value);
}