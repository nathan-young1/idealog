import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Idea/ui/ListPage/ListPage.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/bottomNav/bottomNav.dart';
import 'package:idealog/bottomNav/notifier.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/productivity/code/productivityManager.dart';
import 'package:idealog/productivity/ui/productivity.dart';
import 'package:idealog/settings/ui/settings.dart';
import 'package:provider/provider.dart';

class MenuPageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var userPref = Provider.of<Prefrences>(context);
    
    return MultiProvider(
      providers: [
      Provider<ProductivityManager>.value(value: ProductivityManager(context: context)),
      
      FutureProvider<List<AnalyticChartData>>.value(
      initialData: <AnalyticChartData>[],
      value: AnalyticDB.instance.readAnalytics(),
      catchError: (_,__)=>[]),

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
                      IdeaListPage(),
                      Productivity(),
                      Settings()
                    ],
                  ),
                  floatingActionButton: Visibility(
                        visible: (Provider.of<BottomNavController>(context).currentPage == ActiveNavTab.Ideas),
                        child: FloatingActionButton(
                          tooltip: "Add a new idea",
                          elevation: 10,
                          backgroundColor: !userPref.isDarkMode ?DarkBlue :ActiveTabLight,
                          onPressed: ()=> Navigator.pushNamed(context, addNewIdeaPage),
                          child: Icon(Icons.add,size: 32,color: Colors.white)
                        ),
                      ),
              bottomNavigationBar: BottomNavBar(),
            ));
        }
      ),
    );
  }
}