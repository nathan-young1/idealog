import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/controllers/bottomNavController.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';

class MenuBottomNav extends StatelessWidget {
  const MenuBottomNav({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: Provider.of<BottomNavController>(context,listen: false).bottomNavHeight,
      color: LightGray,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: ActiveTab(typeOfTab: ActiveNavTab.Ideas,icon: FontAwesomeIcons.solidLightbulb)),
            Expanded(
              flex: 1,
              child: ActiveTab(typeOfTab: ActiveNavTab.Productivity,icon: FontAwesomeIcons.waveSquare)),
            Expanded(
              flex: 1,
              child: ActiveTab(typeOfTab: ActiveNavTab.Settings,icon: FontAwesomeIcons.cog))
          ]),
      ),
    );
  }
}

class ActiveTab extends StatefulWidget {

  final ActiveNavTab typeOfTab;
  final IconData icon;

  ActiveTab({Key? key,required this.typeOfTab,required this.icon}) : super(key: key); 

  @override
  _ActiveTabState createState() => _ActiveTabState();
  
}

class _ActiveTabState extends State<ActiveTab> with SingleTickerProviderStateMixin{
  
  late AnimationController tabAnimationController;
  late Animation<Color?> lightColorChangeAnimation;
  late Animation<Color?> darkColorChangeAnimation;
  late Animation<double?> translateAnimation;
  late BottomNavController listenableBottomNavController;
  late BottomNavController nonListenableBottomNavController;
  
  @override
  void initState() {
    tabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400));

    lightColorChangeAnimation = ColorTween(begin: DarkGray,end: DarkBlue)
    .animate(tabAnimationController);

    darkColorChangeAnimation = ColorTween(begin: DarkGray,end: DarkRed)
    .animate(tabAnimationController);

    translateAnimation = Tween<double>(begin: 0,end: BottomNavController.instance.bottomNavHeight * 0.18)
    .animate(tabAnimationController);

    super.initState();
  }

  @override
  void dispose() {
    tabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    listenableBottomNavController = Provider.of<BottomNavController>(context);
    nonListenableBottomNavController = Provider.of<BottomNavController>(context,listen: false);
    
    bool tabIsActive = listenableBottomNavController.currentPage == (widget.typeOfTab);
    nonListenableBottomNavController.controlAnimation(animationController: tabAnimationController, tabIsActive: tabIsActive);


    return GestureDetector(
      onTap: ()=> nonListenableBottomNavController.currentPage = widget.typeOfTab,

      child: Container(
        alignment: nonListenableBottomNavController.navIconAlignment(widget.typeOfTab),
        height: nonListenableBottomNavController.bottomNavHeight * 0.8,
        color: Colors.transparent,

        child: AnimatedBuilder(
          animation: tabAnimationController,
          builder: (context,_){
            /// use a different color animation depending on the application theme.
            Color? currentColorForBottomNav = (Prefrences.instance.isDarkMode)
                  ?darkColorChangeAnimation.value
                  :lightColorChangeAnimation.value;

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Transform.translate(
                offset: Offset(0,-translateAnimation.value!),
                child: Icon(widget.icon, size: 28,
                color: currentColorForBottomNav)),
            
            
              Opacity(
                opacity: tabAnimationController.value,
                // when the opacity is 0 the text painter throws an exception, so i am hiding the widget when
                // the opacity is zero(but maintaining the size).
                child: Visibility(
                  visible: (tabAnimationController.value != 0),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Transform.translate(
                    offset: Offset(0,translateAnimation.value!),
                    child: Text(widget.typeOfTab.toString().split('.').last,
                    style: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle!)),
                ),
              ),
            ],
          );}
        ),
      ),
    );
  }
}