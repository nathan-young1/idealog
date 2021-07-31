import 'package:flutter/material.dart';

class SearchController extends ChangeNotifier{

  SearchController._();
  static SearchController instance = SearchController._();


  String _searchTerm = '';
  bool _searchState = false;


  bool get searchIsActive => _searchState;

  set searchIsActive(bool state){
    _searchState = state;
    
// if the state of the search bar is set to false then clear the search term
    if (!state) clearSearch();

    notifyListeners();
  }


  String get searchTerm => _searchTerm;

  set searchTerm(String keyword){
      _searchTerm = keyword;
      notifyListeners();
  }

  void clearSearch()=> searchTerm = "";
  /// close the search textField if open.
  void stopSearch()=> searchIsActive = false;
  void startSearch()=> searchIsActive = true;
  void searchFor(String? term)=> searchTerm = term!;

}