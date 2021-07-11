import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/application-ui/splashScreen.dart';
import 'package:idealog/design/theme.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:idealog/settings/ui/manageAccount.dart';
import 'package:idealog/settings/ui/upgradeToPremium.dart';
import 'package:provider/provider.dart';
import 'Databases/idealog-db/idealog_Db.dart';
import 'Idea/ui/Others/CreateIdea.dart';
import 'Prefs&Data/GoogleUserData.dart';
import 'SearchBar/SearchNotifier.dart';
import 'auth/ui/authUi.dart';
import 'bottomNav/notifier.dart';
import 'core-models/ideaModel.dart';
import 'settings/ui/syncronization.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  await IdealogDb.instance.initialize();

  await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize()
      ]);

  runApp(Idealog());
  }



class Idealog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
                  return LayoutBuilder(
                    builder: (_, constraints) {
                      ScreenUtil.init(constraints);
                      return ScreenUtilInit(
                        builder: () => MultiProvider(
                          providers: [
                            StreamProvider<List<Idea>>.value(value: IdealogDb.instance.readFromDb,initialData: [],catchError: (_,__)=>[]),
                            ChangeNotifierProvider<GoogleUserData>.value(value: GoogleUserData.instance),
                            ChangeNotifierProvider<Prefrences>.value(value: Prefrences.instance),
                            ChangeNotifierProvider<BottomNavController>.value(value: BottomNavController.instance),
                            ChangeNotifierProvider<SearchController>.value(value: SearchController.instance)
                          ],
                          child: Builder(
                            builder: (BuildContext context) => MaterialApp(
                              title: 'Idealog',
                              debugShowCheckedModeBanner: false,
                              themeMode: Provider.of<Prefrences>(context).isDarkMode
                              ? ThemeMode.dark
                              : ThemeMode.light,
                              // The light theme
                              theme: CustomTheme.lightTheme,
                              // The Dark theme
                              darkTheme: CustomTheme.darkTheme,
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
                        ),
                      );
                    }
                  );
      }
  }

