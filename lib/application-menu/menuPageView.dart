import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/analytics/analyticsSql.dart';
import 'package:idealog/idea/listPage/ui/ideaListPage.dart';
import 'package:idealog/productivity/code/productivityManager.dart';
import 'package:idealog/productivity/ui/productivity.dart';
import 'package:idealog/settings/ui/settings.dart';
import 'package:idealog/sqlite-db/sqlite.dart';
import 'package:provider/provider.dart';

class MenuPageView extends StatefulWidget {
  @override
  _MenuPageViewState createState() => _MenuPageViewState();
}

class _MenuPageViewState extends State<MenuPageView> {
  PageController _controller = PageController();
  ValueNotifier<int> index = ValueNotifier(0);

  @override
    void initState() {
      super.initState();
    }

  @override
    void dispose() {
      print('me dispose');
      Sqlite.close();
      _controller.dispose();
      index.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      Provider<ProductivityManager>.value(value: ProductivityManager(context: context)),
      FutureProvider<List<AnalyticsData>>.value(
      initialData: [],
      value: AnalyticsSql.readAnalytics())
      ],
      child: SafeArea(
          child: Container(
            decoration: lightModeBackgroundColor,
            child: Scaffold(
              backgroundColor: Colors.transparent,
                body: PageView(
                  controller: _controller,
                  onPageChanged: (int pageIndex) => index.value = pageIndex,
                  children: [
                    IdeaListPage(),
                    Productivity(),
                    Settings()
                  ],
                ),
                floatingActionButton: ValueListenableBuilder(
                  valueListenable: index,
                  builder: (context, int _pageIndex,child) {
                    return Visibility(
                      visible: (_pageIndex == 0),
                      child: FloatingActionButton(
                        backgroundColor: Colors.blueGrey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        splashColor: Colors.black54,
                        onPressed: ()=> Navigator.pushNamed(context, addNewIdeaPage),
                        child: Icon(Icons.add,size: 35,color: Colors.white)
                      ),
                    );
                  }
                ),
                bottomNavigationBar: Container(
                  height: 70,
                  color: lightModeBottomNavColor,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ValueListenableBuilder(
                  valueListenable: index,
                  builder: (context, int _pageIndex,child) {
                  return GNav(
                    selectedIndex: _pageIndex,
                    backgroundColor: Colors.transparent,
                    tabBorderRadius: 50,
                    tabBackgroundGradient: LinearGradient(
                    colors: [
                    Color.fromRGBO(63, 73, 87, 0.4),
                    Color.fromRGBO(117, 71, 74, 0.4)
                      ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                    //padding for the tabs
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    onTabChange: (int index){
                      _controller.jumpToPage(index);
                    },
                    tabs: [
                      GButton(
                        icon: Icons.lightbulb,
                        gap: 4.0,
                        text: 'Ideas',
                      ),
                      GButton(
                        icon: Icons.timeline,
                        gap: 4.0,
                        text: 'Productivity',
                      ),
                      GButton(
                        icon: Icons.settings,
                        gap: 4.0,
                        text: 'Settings',
                      ),
                    ],
                  );
                  }
                ),
            ),
        ),
          )),
    );
  }
}