import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/authentication/authHandler.dart';
import 'package:idealog/customWidget/alertDialog/alertDialogComponents.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroPages extends StatelessWidget {
  IntroPages({ Key? key }) : super(key: key);

  static PageController pageController = PageController();

  final Function skipIntro = ()=> pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.linear);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: PageView(
            controller: pageController,
            children: [
              Intro1(onSkipPressed: skipIntro),
              Intro2(onSkipPressed: skipIntro),
              Intro3(onSkipPressed: skipIntro)
            ],
          ),
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
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: percentWidth(77),
                    constraints: BoxConstraints(maxWidth: 300.w),
                    child: Image.asset(Paths.Welcome_Intro_Pic, fit: BoxFit.contain)),
            
                  SizedBox(height: percentHeight(2.6)),
                  AutoSizeText("Welcome to idealog", 
                    style: AppFontWeight.semibold,
                    maxFontSize: AppFontSize.fontSize_27,
                    minFontSize: AppFontSize.fontSize_24,
                    ),
                  SizedBox(height: percentHeight(1.3)),
                    
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: percentWidth(7.7)),
                    child: AutoSizeText("Idea management at it’s easiest,  get organized on a button click with idealog.",
                     style: AppFontWeight.light,
                    textAlign: TextAlign.center,
                    maxFontSize: AppFontSize.fontSize_24,
                    minFontSize: 21),
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
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: percentWidth(77),
                    constraints: BoxConstraints(maxWidth: 300.w),
                    child: Image.asset(Paths.Intro_Pic_2, fit: BoxFit.contain)),
            
                  SizedBox(height: percentHeight(2.6)),
                  AutoSizeText("Get organized", 
                    style: AppFontWeight.semibold,
                    maxFontSize: AppFontSize.fontSize_27,
                    minFontSize: AppFontSize.fontSize_24,
                    ),
                  SizedBox(height: percentHeight(1.3)),
                      
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: percentWidth(7.7)),
                    child: AutoSizeText("Increase productivity by breaking down your idea’s into chunk of tasks for higher efficiency.",
                     style: AppFontWeight.light,
                    textAlign: TextAlign.center,
                    maxFontSize: AppFontSize.fontSize_24,
                    minFontSize: 21)
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

    Future<void> changeRoute() async { 
      await Prefrences.instance.setThatUserIsNoLongerAFirstTimer();
      Navigator.pushReplacement(context, PageTransition(child: MenuPageView(), type: PageTransitionType.rightToLeftWithFade));
      }
    
    return Scaffold(
      body: Column(
        children: [

          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: percentWidth(77),
                    constraints: BoxConstraints(maxWidth: 300.w),
                    child: Image.asset(Paths.Intro_Pic_3, fit: BoxFit.contain)),
                  SizedBox(height: percentHeight(2.6)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: AutoSizeText("Completed your brilliant ideas with the help of Idealog today.",
                     style: AppFontWeight.light,
                    textAlign: TextAlign.center,
                    maxFontSize: AppFontSize.fontSize_24,
                    minFontSize: 21)
                  ),
                  SizedBox(height: percentHeight(3.9)),
                      
                  Container(
                    constraints: BoxConstraints(maxHeight: 50.h, maxWidth: 230.w, minWidth: 220.w),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: DarkBlue),
            
                    child: TextButton.icon(
                      onPressed: () async {

                        showSigningInAlertDialog(context: context);

                          if(await signInWithGoogle()){
                            // remove authenticating with google dialog.
                            Navigator.of(context).pop(); 

                            try{
                            // if google sign in was a success.
                            await downloadBackupFileIfAnyExistsThenWriteToDb(context);
                            } catch (e,s) {
                              debugPrint(e.toString() + s.toString());
                              await signOutFromGoogle();
                              // remove the dialog.
                              Navigator.of(context).pop();
                              anErrorOccuredFlushBar(context: context);
                              return;
                              }
                          //*************************After a successful sign in**************************//
                            changeRoute();
                          } else {
                          //*************************No internet connection**************************// 
                            // remove authenticating with google dialog.
                            Navigator.of(context).pop();
                            anErrorOccuredFlushBar(context: context);
                          }
            
                      
                      },
                      icon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: percentWidth(2)),
                        child: Icon(FontAwesomeIcons.google, color: Colors.white),
                      ),
                      label: Text("Continue with google", style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_18, color: Colors.white)),
                    )
                  ),
            
                  SizedBox(height: percentHeight(1.7)),
                  Container(
                    constraints: BoxConstraints(maxHeight: 50.h, maxWidth: 230.w, minWidth: 220.w),
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

      bottomNavigationBar: DotIndicatorWrapper(activePage: 3, height: percentHeight(9)),
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
        padding: EdgeInsets.only(top: percentHeight(3.2), right: percentWidth(6.4)),
        child: Container(
        constraints: BoxConstraints(maxHeight: 38.h, maxWidth: 75.w),
        decoration: BoxDecoration(border: Border.all(color: DarkBlue, width: 2), borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          onPressed: ()=> onSkipPressed(),
          child: AutoSizeText("Skip", 
          style: AppFontWeight.medium.copyWith(color: DarkBlue),
          maxFontSize: AppFontSize.fontSize_18,
          minFontSize: AppFontSize.fontSize_15))),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DotIndicator(isActive: activePage == 1),
        SizedBox(width: 8),
        DotIndicator(isActive: activePage == 2),
        SizedBox(width: 8),
        DotIndicator(isActive: activePage == 3)
      ],
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
      constraints: BoxConstraints(maxHeight: 16, maxWidth: 16),
      height: percentHeight(2),
      width: percentWidth(4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: (isActive) ?DarkBlue :DarkerLightGray),
    );
  }
}