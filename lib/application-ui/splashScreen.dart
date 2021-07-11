import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/routes.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:idealog/auth/code/authHandler.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;
  Future<dynamic> changeRoute() =>Navigator.pushReplacementNamed(context,menuPageView);

  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
            if(true){
      await signInWithGoogle();
      print(GoogleUserData.instance.user_email);
        final authHeaders = await GoogleUserData.instance.googleSignInAccount!.authHeaders;
        final authenticateClient = GoogleAuthClient(authHeaders);
        final driveApi = drive.DriveApi(authenticateClient);
        
        
      
          String filePath = (await getTemporaryDirectory()).path + "/idealog.json";
          File name = new File(filePath);
          name.writeAsString((await IdealogDb.instance.allIdeasForJson).toString());
          var jj = jsonDecode(jsonEncode(await name.readAsString()));
          await name.delete();

        // final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream();
        // var media = new drive.Media(mediaStream, 2);

        // var driveFile = new drive.File();
        // driveFile.name = "hello_world.txt";
        // driveFile.parents = ["appDataFolder"];
        // final result = await driveApi.files.create(driveFile, uploadMedia: media);
        

        // List ids = (await driveApi.files.list(spaces: 'appDataFolder')).files!.map((e) => e.id).toList();
        // for (var i in ids){
        //   await driveApi.files.delete(i!);
        // }

        print((await driveApi.files.list(spaces: 'appDataFolder')).files!.map((e) => e.id).toList());

        // final downloaded = await driveApi.files.get(result.id!,downloadOptions: drive.DownloadOptions.fullMedia);
        // (downloaded as drive.Media).stream.listen((event) {print("before update $event");});

        // final Stream<List<int>> PPmediaStream = Future.value([70, 105, 87]).asStream();
        // var PPmedia = new drive.Media(PPmediaStream, 2);

        // var PdriveFile = new drive.File();
        // PdriveFile.name = "hello_world.txt";
        // final Pdrive = await driveApi.files.update(PdriveFile, result.id!, uploadMedia: PPmedia);
        // print('second id is ${Pdrive.id!} while the first is ${result.id!}');
        // final Pdownloaded = await driveApi.files.get(result.id!,downloadOptions: drive.DownloadOptions.fullMedia);
        // (Pdownloaded as drive.Media).stream.listen((event) {print("after update $event ha ha");});

    }
        AnalyticDB.instance.clearObsoluteData();
        timer = Timer(Duration(milliseconds: 800),() async {
        if(Prefrences.instance.fingerprintEnabled){
          // fingerprint authentication is enabled
            bool userIsAuthenticated = await authenticateWithBiometrics(calledFromLogin: true);
            if(userIsAuthenticated)
              changeRoute();
        }else{
          // fingerprint authentication is not enabled
        changeRoute();
        }

        });
      });
    }

    @override
      void dispose() {
        timer!.cancel();
        super.dispose();
      }   
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 50.h),
        child: Column(
          children: [
            Expanded(
              child: Center(
              child: GestureDetector(
                // create a login with fingerprint screen so that they can touch the center to authenticate again after 5 seconds
              // onTap: ()=> auth(useBiometric),
              child: Image.asset(Provider.of<Prefrences>(context).appLogoPath,height: 240.h,width: 230.w))
              ),
            ),
            Text('Idealog v1.2',
              style: Overpass.copyWith(fontSize: 28,color: Color.fromRGBO(112, 112, 112, 1))
              )
          ],
        ),
      ),);
  }
}