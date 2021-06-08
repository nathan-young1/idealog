import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Idea/ui/ListPage/ListPage.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
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
      catchError: (_,__)=>[])
      ],
      child: SafeArea(
          child: Scaffold(
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
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
                      elevation: 10,
                      backgroundColor: !userPref.isDarkMode ?LightPink.withOpacity(1) :ActiveTabLight,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onPressed: ()=> Navigator.pushNamed(context, addNewIdeaPage),
                      child: Icon(Icons.add,size: 40,color: Colors.white)
                    ),
                  );
                }
              ),
              bottomNavigationBar: Container(
                height: 70,
                decoration: BoxDecoration( 
                  color: LightGray,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ValueListenableBuilder(
                valueListenable: index,
                builder: (context, int _pageIndex,child) {
                return GNav(
                  gap: 6,
                  iconSize: 35,
                  activeColor: Colors.white,
                  color: !userPref.isDarkMode ?ActiveTabLight :DarkRed,
                  selectedIndex: _pageIndex,
                  backgroundColor: Colors.transparent,
                  tabBorderRadius: 20,
                  textStyle: Righteous.copyWith(fontSize: 18,color: Colors.white),
                  tabBackgroundColor: !userPref.isDarkMode ?ActiveTabLight :DarkRed,
                  //padding for the tabs
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  onTabChange: (int index){
                    _controller.jumpToPage(index);
                  },
                  tabs: [
                    GButton(
                      icon: Icons.lightbulb,
                      text: 'Ideas',
                      iconSize: 30,
                    ),
                    GButton(
                      icon: Icons.timeline,
                      text: 'Productivity',
                    ),
                    GButton(
                      icon: Icons.settings,
                      iconSize: 30,
                      text: 'Settings',
                    ),
                  ],
                );
                }
              ),
          ),
        )),
    );
  }
}