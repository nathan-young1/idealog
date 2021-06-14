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

class MenuPageView extends StatefulWidget {
  @override
  _MenuPageViewState createState() => _MenuPageViewState();
}

class _MenuPageViewState extends State<MenuPageView> {
  final PageController _controller = PageController();
  ValueNotifier<int> index = ValueNotifier(0);

  @override
    void initState() {
      super.initState();
    }

  @override
    void dispose() {
      _controller.dispose();
      index.dispose();
      super.dispose();
    }

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
                    controller: BottomNavController.instance.controller,
                    children: [
                      IdeaListPage(),
                      Productivity(),
                      Settings()
                    ],
                  ),
                  floatingActionButton: Visibility(
                        visible: (Provider.of<BottomNavController>(context).currentPage == ActiveNavTab.Ideas),
                        child: FloatingActionButton(
                          elevation: 10,
                          backgroundColor: !userPref.isDarkMode ?DarkBlue :ActiveTabLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onPressed: ()=> Navigator.pushNamed(context, addNewIdeaPage),
                          child: Icon(Icons.add,size: 40,color: Colors.white)
                        ),
                      ),
              bottomNavigationBar: BottomNavBar(),
            ));
        }
      ),
    );
  }
}