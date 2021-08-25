import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/application-menu/controllers/bottomNavController.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
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
  final TextStyle navDescriptionStyle = AppFontWeight.medium.copyWith(fontSize: AppFontSize.small, color: DarkBlue);
  
  late AnimationController tabAnimationController;
  late Animation<Color?> colorChangeAnimation;
  late Animation<double?> translateAnimation;
  late BottomNavController listenableBottomNavController;
  late BottomNavController nonListenableBottomNavController;
  
  @override
  void initState() {
    tabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400));

    colorChangeAnimation = ColorTween(begin: DarkGray,end: DarkBlue)
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
          builder: (context,_)=> Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Transform.translate(
                offset: Offset(0,-translateAnimation.value!),
                child: Icon(widget.icon, size: 28,color: colorChangeAnimation.value)),
            
            
              Transform.translate(
                offset: Offset(0,translateAnimation.value!),
                child: Opacity(
                  opacity: tabAnimationController.value,
                  child: Text(widget.typeOfTab.toString().split('.').last,style: navDescriptionStyle))),
            ],
          ),
        ),
      ),
    );
  }
}