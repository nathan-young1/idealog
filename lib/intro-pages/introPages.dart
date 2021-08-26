import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/authentication/authHandler.dart';
import 'package:idealog/customWidget/alertDialog/alertDialogComponents.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/internetConnectionChecker.dart';
import 'package:idealog/global/paths.dart';
import 'package:page_transition/page_transition.dart';

class IntroPages extends StatelessWidget {
  IntroPages({ Key? key }) : super(key: key);

  static PageController pageController = PageController();

  final Function skipIntro = ()=> pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.linear);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            Intro1(onSkipPressed: skipIntro),
            Intro2(onSkipPressed: skipIntro),
            Intro3(onSkipPressed: skipIntro)
          ],
        ),
      )
    );
  }
}

class Intro1 extends StatelessWidget {
  const Intro1({
    Key? key,
    required this.onSkipPressed
  }) : super(key: key);

  final Function onSkipPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          SkipButton(onSkipPressed: onSkipPressed),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(Paths.Welcome_Intro_Pic, width: 300, fit: BoxFit.contain),
                  SizedBox(height: 20),
                  Text("Welcome to idealog", style: AppFontWeight.semibold.copyWith(fontSize: AppFontSize.fontSize_26)),
                  SizedBox(height: 10),
          
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Idea management at it’s easiest,  get organized on a button click with idealog.", style: AppFontWeight.light.copyWith(fontSize: AppFontSize.fontSize_23), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      bottomNavigationBar: DotIndicatorWrapper(activePage: 1),
    );
  }
}

class Intro2 extends StatelessWidget {
  const Intro2({
    Key? key,
    required this.onSkipPressed
  }) : super(key: key);

  final Function onSkipPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          SkipButton(onSkipPressed: onSkipPressed),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(Paths.Intro_Pic_2, width: 300, fit: BoxFit.contain),
                  SizedBox(height: 20),
                  Text("Get organized", style: AppFontWeight.semibold.copyWith(fontSize: AppFontSize.fontSize_26)),
                  SizedBox(height: 10),
          
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Increase productivity by breaking down your idea’s into chunk of tasks for higher effiency.", style: AppFontWeight.light.copyWith(fontSize: AppFontSize.fontSize_23), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      bottomNavigationBar: DotIndicatorWrapper(activePage: 2),
    );
  }
}

class Intro3 extends StatelessWidget {
  const Intro3({
    Key? key,
    required this.onSkipPressed
  }) : super(key: key);

  final Function onSkipPressed;

  @override
  Widget build(BuildContext context) {

    Future<dynamic> changeRoute() => Navigator.pushReplacement(context, PageTransition(child: MenuPageView(), type: PageTransitionType.rightToLeftWithFade));
    
    return Scaffold(
      body: Column(
        children: [

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(Paths.Intro_Pic_3, width: 300, fit: BoxFit.contain),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Completed your brilliant ideas with the help of Idealog today.", style: AppFontWeight.light.copyWith(fontSize: AppFontSize.fontSize_23), textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 30),
          
                  Container(
                    height: 50,
                    width: 220,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: DarkBlue),

                    child: TextButton.icon(
                      onPressed: () async {
                        if(UserInternetConnectionChecker.userHasInternetConnection){
                          showSigningInAlertDialog(context: context);
                          if(await signInWithGoogle()){
                            // if google sign in was a success.
                            await downloadBackupFileIfAnyExistsThenWriteToDb();
                            // remove the dialog.
                            Navigator.of(context).pop();
                            changeRoute();
                          } else {
                            // remove the dialog.
                            Navigator.of(context).pop();
                            anErrorOccuredFlushBar(context: context);
                          }

                        } else anErrorOccuredFlushBar(context: context);
                      },
                      icon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(FontAwesomeIcons.google, color: Colors.white),
                      ),
                      label: Text("Continue with google", style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_18, color: Colors.white)),
                    )
                  ),

                  SizedBox(height: 15),
                  Container(
                    height: 50,
                    width: 220,
                    decoration: BoxDecoration(border: Border.all(color: DarkBlue, width: 2), borderRadius: BorderRadius.circular(12)),
                    child: TextButton(
                      onPressed: changeRoute,
                      child: Text("Continue as guest", style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_18)),
                    )
                  )
                ],
              ),
            ),
          )
        ],
      ),

      bottomNavigationBar: DotIndicatorWrapper(activePage: 3, height: 70),
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({
    Key? key,
    required this.onSkipPressed,
  }) : super(key: key);

  final Function onSkipPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 25, right: 25),
        child: Container(
        height: 38,
        width: 75,
        decoration: BoxDecoration(border: Border.all(color: DarkBlue, width: 2), borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          onPressed: ()=> onSkipPressed(),
          child: Text("Skip", style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_16, color: DarkBlue)))),
      ),
    );
  }
}

class DotIndicatorWrapper extends StatelessWidget {
  const DotIndicatorWrapper({
    Key? key,
    required this.activePage,
    this.height
  }) : super(key: key);

  // store which page the pageview is in so that the dot_indicator can reflect change.
  final int activePage;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DotIndicator(isActive: activePage == 1),
          SizedBox(width: 8),
          DotIndicator(isActive: activePage == 2),
          SizedBox(width: 8),
          DotIndicator(isActive: activePage == 3)
        ],
      )
      );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(shape: BoxShape.circle, color: (isActive) ?DarkBlue :DarkerLightGray),
    );
  }
}