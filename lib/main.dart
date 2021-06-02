import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/application-ui/splashScreen.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/settings/ui/manageAccount.dart';
import 'package:idealog/settings/ui/upgradeToPremium.dart';
import 'package:provider/provider.dart';
import 'Databases/idealog-db/idealog_Db_Moor.dart';
import 'Prefs&Data/GoogleUserData.dart';
import 'auth/ui/authUi.dart';
import 'core-models/ideasModel.dart';
import 'design/colors.dart';
import 'idea/listPage/ui/newIdea.dart';
import 'settings/ui/syncronization.dart';

void main() => runApp(Idealog());

class Idealog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: Prefrences.instance.initialize(),
      builder: (context, builder) {
        if (builder.connectionState == ConnectionState.done) {
            return LayoutBuilder(
              builder: (_, constraints) {
                ScreenUtil.init(constraints);
                return ScreenUtilInit(
                  builder: () => MultiProvider(
                    providers: [
                      StreamProvider<List<IdeaModel>>.value(value: IdealogDb.instance.watchIdeasInDb,initialData: [],catchError: (_,__)=>[]),
                      ChangeNotifierProvider<GoogleUserData>.value(value: GoogleUserData.instance),
                      ChangeNotifierProvider<Prefrences>.value(value: Prefrences.instance)
                    ],
                    child: MaterialApp(
                      title: 'Idealog',
                      debugShowCheckedModeBanner: false,
                      theme: !Prefrences.instance.isDarkMode 
                      ?ThemeData(
                        brightness: Brightness.light,
                        scrollbarTheme: ScrollbarThemeData(
                        radius: Radius.circular(10),
                        thickness: MaterialStateProperty.all(5),
                        thumbColor: MaterialStateProperty.all(AddToExistingLight),
                        mainAxisMargin: 10,
                      ),
                      accentColor: DarkBlue,
                      primaryColor: DarkBlue
                      )
                      :ThemeData(
                        brightness: Brightness.dark,
                        accentColor: LightPink,
                        primaryColor: LightPink
                      ),
                      routes: {
                        homePage: (context) => SplashScreen(),
                        authenticationPage: (context) => Login(),
                        menuPageView: (context) => MenuPageView(),
                        addNewIdeaPage: (context) => NewIdea(),
                        manageAccountPage: (context) => ManageAccount(),
                        syncronizationPage: (context) => Syncronization(),
                        upgradeToPremiumPage: (context) => UpgradeToPremium()
                      },
                    ),
                  ),
                );
              }
            );
        } else {
          return Container(
            color: Colors.white
          );
        }
      }
    );
  }
}

