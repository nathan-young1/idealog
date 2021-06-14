import 'package:flutter/material.dart';

enum ActiveNavTab{Ideas,Productivity,Settings}

class BottomNavController with ChangeNotifier{

  BottomNavController._();
  static BottomNavController instance = BottomNavController._();

  final PageController controller = PageController(keepPage: true);
  final double bottomNavHeight = 75;
  int _currentPage = 0;

  ActiveNavTab? get currentPage{ 
        switch(_currentPage){
          case 0:
            return ActiveNavTab.Ideas;

          case 1: 
            return ActiveNavTab.Productivity;

          case 2: 
            return ActiveNavTab.Settings;
        }
  }

  set currentPage(ActiveNavTab? activeTab){
    // if the index of the active tab in the enum is not equals to the current page index the change the page
    if(activeTab!.index != _currentPage){
      _currentPage = activeTab.index;

      controller.animateToPage(_currentPage, duration: Duration(milliseconds: 400), curve: Curves.linear);
      notifyListeners();
    }
  }

  void controlAnimation({required AnimationController animationController,required bool tabIsActive}) =>
        (tabIsActive)
            ?animationController.forward()
            :animationController.reverse();
         

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Icon alignment because i used expanded to capture gesture detector within that area, so i have to align them well
  // within the expanded widget
  Alignment? navTabAlignment(ActiveNavTab tab){
    switch(tab){
      
      case ActiveNavTab.Ideas:
        return Alignment.centerLeft;
        
      case ActiveNavTab.Productivity:
        return Alignment.center;

      case ActiveNavTab.Settings:
        return Alignment.centerRight;
    }
  }
}