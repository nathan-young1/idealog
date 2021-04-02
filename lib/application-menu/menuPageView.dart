import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(63, 73, 87, 1),Color.fromRGBO(117, 71, 74, 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
            body: PageView(
              controller: _controller,
              onPageChanged: (int pageIndex) => index.value = pageIndex,
              children: [
                IdeaListPage(),
                Container(color: Colors.blue),
                Container(color: Colors.green),
                Container(color: Colors.orange)
              ],
            ),
            floatingActionButton: ValueListenableBuilder(
              valueListenable: index,
              builder: (context, int _pageIndex,child) {
                return Visibility(
                  visible: (_pageIndex == 0 || _pageIndex == 2),
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    splashColor: Colors.red,
                    onPressed: (){},
                    child: Icon(Icons.add,size: 35,color: Colors.black)
                  ),
                );
              }
            ),
            bottomNavigationBar: Container(
              height: 70,
              color: Color.fromRGBO(71, 71, 73, 0.7),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ValueListenableBuilder(
              valueListenable: index,
              builder: (context, int _pageIndex,child) {
              return GNav(
                selectedIndex: _pageIndex,
                backgroundColor: Colors.transparent,
                tabBorderRadius: 50,
                tabBackgroundColor: Color.fromRGBO(18, 7, 8, 0.6),
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