import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:idealog/Schedule/ui/scheduleListPage.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/idea/ui/ideaListPage.dart';

class MenuPageView extends StatefulWidget {
  @override
  _MenuPageViewState createState() => _MenuPageViewState();
}

class _MenuPageViewState extends State<MenuPageView> {
  PageController _controller = PageController();
  ValueNotifier<int> index = ValueNotifier(0);

  @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: lightModeBackgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
            body: PageView(
              controller: _controller,
              onPageChanged: (int pageIndex) => index.value = pageIndex,
              children: [
                IdeaListPage(),
                ScheduleListPage(),
                Container(color: Colors.green),
                Container(color: Colors.orange)
              ],
            ),
            floatingActionButton: ValueListenableBuilder(
              valueListenable: index,
              builder: (context, int _pageIndex,child) {
                return Visibility(
                  visible: (_pageIndex == 0 || _pageIndex == 1),
                  child: FloatingActionButton(
                    backgroundColor: Colors.blueGrey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    splashColor: Colors.black54,
                    onPressed: ()=> (_pageIndex == 0)
                    ?Navigator.pushNamed(context, addNewIdeaPage)
                    :Navigator.pushNamed(context, addNewSchedulePage),
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
                    icon: Icons.ballot,
                    gap: 4.0,
                    text: 'Schedule',
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
      ));
  }
}