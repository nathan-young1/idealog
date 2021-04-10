import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/application-ui/splashScreen.dart';
import 'package:idealog/sqlite-db/sqlite.dart';
import 'package:provider/provider.dart';
import 'auth/ui/authUi.dart';
import 'core-models/ideasModel.dart';
import 'idea/ui/newIdea.dart';

void main() => runApp(Idealog());

class Idealog extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Sqlite.initialize();
    return LayoutBuilder(
       builder: (_, constraints) {
        ScreenUtil.init(constraints);
        return ScreenUtilInit(
          builder: () => MultiProvider(
            providers: [
              StreamProvider<List<Idea>>.value(value:Sqlite.dbStream,initialData: [])
            ],
            child: MaterialApp(
              title: 'Idealog',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
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
          ),
        );
      }
    );
  }
}

