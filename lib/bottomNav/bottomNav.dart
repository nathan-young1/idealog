import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/bottomNav/notifier.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BottomNavController.instance.bottomNavHeight,
      decoration: BoxDecoration( 
        color: LightGray,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
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
  final TextStyle navDescriptionStyle = Poppins.copyWith(fontSize: 16,fontWeight: FontWeight.w300,color: DarkBlue);
  late AnimationController tabAnimationController;
  late Animation<Color?> colorChangeAnimation;
  late Animation<double?> translateAnimation;

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

    bool tabIsActive = Provider.of<BottomNavController>(context).currentPage == (widget.typeOfTab);
    BottomNavController.instance.controlAnimation(animationController: tabAnimationController, tabIsActive: tabIsActive);

    return GestureDetector(
      onTap: ()=> BottomNavController.instance.currentPage = widget.typeOfTab,

      child: Container(
        alignment: BottomNavController.instance.navTabAlignment(widget.typeOfTab),
        height: BottomNavController.instance.bottomNavHeight * 0.8,
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