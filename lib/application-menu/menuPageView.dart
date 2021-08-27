import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/ListPage/ListPage.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/widgets/floatingActionButton.dart';
import 'package:idealog/application-menu/widgets/bottomNav.dart';
import 'package:idealog/application-menu/controllers/bottomNavController.dart';
import 'package:idealog/productivity/code/productivityManager.dart';
import 'package:idealog/productivity/ui/productivity.dart';
import 'package:idealog/settings/ui/settings.dart';
import 'package:provider/provider.dart';

class MenuPageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  
    return Consumer<Prefrences>(
      builder: (_, userPref,__){
        final TextEditingController searchFieldController = new TextEditingController();
    
        return MultiProvider(
        providers: [
          Provider<ProductivityManager>.value(value: ProductivityManager(context: context)),
          ChangeNotifierProvider<BottomNavController>.value(value: BottomNavController.instance)
        ],
        child: Builder(
          builder: (context) {
            return SafeArea(
                child: Scaffold(
                    body: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: Provider.of<BottomNavController>(context,listen: false).controller,
                      children: [
                        IdeaListPage(searchFieldController: searchFieldController),
                        Productivity(),
                        Settings(searchFieldController: searchFieldController) 
                      ],
                    ),
                    floatingActionButton: MenuFloatingActionButton(searchFieldController: searchFieldController),
                    bottomNavigationBar: MenuBottomNav(),
              ));
          }
        ),
      );}
    );
  }
}