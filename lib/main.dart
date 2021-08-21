import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/design/theme.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:idealog/settings/ui/accountSettings.dart';
import 'package:idealog/settings/ui/moreSettings.dart';
import 'package:idealog/settings/ui/upgradeToPremium.dart';
import 'package:idealog/splashScreen/splashScreen.dart';
import 'package:provider/provider.dart';
import 'Databases/idealog-db/idealog_Db.dart';
import 'Idea/ui/Others/CreateIdea.dart';
import 'Prefs&Data/GoogleUserData.dart';
import 'SearchBar/SearchNotifier.dart';
import 'application-menu/controllers/bottomNavController.dart';
import 'config.dart';
import 'core-models/ideaModel.dart';
import 'global/paths.dart';
import 'settings/ui/dataBackup.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  await InitializeAppConfig();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
                            ChangeNotifierProvider<SearchController>.value(value: SearchController.instance),
                            ChangeNotifierProvider<Premium>.value(value: Premium.instance),
                            ChangeNotifierProvider<Paths>.value(value: Paths.instance)
                          ],
                          child: Builder(
                            builder: (BuildContext context) => MaterialApp(
                              title: 'Idealog',
                              debugShowCheckedModeBanner: false,
                              themeMode: Provider.of<Prefrences>(context).isDarkMode
                              ? ThemeMode.dark
                              : ThemeMode.light,
                              // The light theme
                              theme: AppTheme.lightTheme,
                              // The Dark theme
                              darkTheme: AppTheme.darkTheme,
                              routes: {
                                homePage: (context) => SplashScreen(),
                                menuPageView: (context) => MenuPageView(),
                                addNewIdeaPage: (context) => NewIdea(),
                                manageAccountPage: (context) => MoreSettings(),
                                syncronizationPage: (context) => DataBackup(),
                                upgradeToPremiumPage: (context) => UpgradeToPremium(),
                                accountSettingsPage: (context) => AccountSettings()
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  );
      }
  }

