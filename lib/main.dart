import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/application-ui/splashScreen.dart';
import 'package:idealog/auth/code/authHandler.dart';
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

void main() => runApp(Idealog());

class Idealog extends StatefulWidget {

  @override
  _IdealogState createState() => _IdealogState();
}

class _IdealogState extends State<Idealog> {

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      
      await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize()
      ]);

    if(true){
      await signInWithGoogle();
      print(GoogleUserData.instance.user_email);
        final authHeaders = await GoogleUserData.instance.googleSignInAccount!.authHeaders;
        final authenticateClient = GoogleAuthClient(authHeaders);
        final driveApi = drive.DriveApi(authenticateClient);

        final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream();
        var media = new drive.Media(mediaStream, 2);

        var driveFile = new drive.File();
        driveFile.name = "hello_world.txt";
        driveFile.parents = ["appDataFolder"];
        final result = await driveApi.files.create(driveFile, uploadMedia: media);
        
        // create first the update for other
        print("Upload result: ${result.name} ${result.id!}");

        final downloaded = await driveApi.files.get(result.id!,downloadOptions: drive.DownloadOptions.fullMedia);
        (downloaded as drive.Media).stream.listen((event) {print("before update $event");});

        final Stream<List<int>> PPmediaStream = Future.value([70, 105, 87]).asStream();
        var PPmedia = new drive.Media(PPmediaStream, 2);

        var PdriveFile = new drive.File();
        PdriveFile.name = "hello_world.txt";
        final Pdrive = await driveApi.files.update(PdriveFile, result.id!, uploadMedia: PPmedia);
        print('second id is ${Pdrive.id!} while the first is ${result.id!}');
        final Pdownloaded = await driveApi.files.get(result.id!,downloadOptions: drive.DownloadOptions.fullMedia);
        (Pdownloaded as drive.Media).stream.listen((event) {print("after update $event ha ha");});

    }

      });
  }

  @override
  Widget build(BuildContext context) {
    
            return FutureBuilder(
              future: IdealogDb.instance.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
                return Container();
              }
            );
      }
  }

