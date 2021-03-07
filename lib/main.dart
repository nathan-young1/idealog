import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:idealog/Schedule/addSchedule/ui/addSchedule.dart';
import 'package:idealog/Schedule/checkSchedule/checkSchedule.dart';
import 'package:idealog/application-ui/splashScreen.dart';
import 'package:idealog/idea/newIdea/ui/newIdea.dart';

import 'auth/ui/authUi.dart';

void main() => runApp(Idealog());

class Idealog extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
       builder: (_, constraints) {
        ScreenUtil.init(constraints);
        return ScreenUtilInit(
          builder: () => MaterialApp(
            title: 'Idealog',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.grey,
            ),
            routes: {
              '/': (context) => SplashScreen(),
              'AuthPage': (context) => Login(),
              'AddNewIdea': (context) => NewIdea(),
              'AddSchedule': (context) => AddSchedule(),
              'CheckSchedule': (context) => CheckSchedule()
            },
          ),
        );
      }
    );
  }
}

