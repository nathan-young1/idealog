import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/application-ui/splashScreen.dart';
import 'auth/ui/authUi.dart';
import 'idea/ui/newIdea.dart';

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
            debugShowCheckedModeBanner: false,
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
              colorScheme: ColorScheme(primary: Colors.blueGrey, primaryVariant: Colors.blueGrey, secondary: Colors.blueGrey, secondaryVariant: Colors.blueGrey, surface: Colors.blueGrey, background: Colors.blueGrey, error: Colors.blueGrey, onPrimary: Colors.blueGrey, onSecondary: Colors.blueGrey, onSurface: Colors.blueGrey, onBackground: Colors.blueGrey, onError: Colors.blueGrey, brightness: Brightness.dark),
              primarySwatch: Colors.blueGrey,
              brightness: Brightness.dark
            ),
            routes: {
              '/': (context) => SplashScreen(),
              'AuthPage': (context) => Login(),
              'MenuPageView': (context) => MenuPageView(),
              'AddNewIdea': (context) => NewIdea(),
            },
          ),
        );
      }
    );
  }
}

