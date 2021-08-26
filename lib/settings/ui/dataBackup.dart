import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/customWidget/alertDialog/syncNowDialog.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:provider/provider.dart';

class DataBackup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    // this is so it can get the updated last sync time when this page is opened.
    NativeCodeCaller.instance.notifyListeners();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NativeCodeCaller>.value(value: NativeCodeCaller.instance)
      ],
      child: Builder(
        builder: (context) {
          
          return Consumer2<NativeCodeCaller,Paths>(
            builder: (context, nativeCodeCaller, paths,_)=>
            SafeArea(
              child: Scaffold(
                body: Column(
                children: [
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                      image: DecorationImage(
                      colorFilter: ColorFilter.mode(LightGray.withOpacity(0.4), BlendMode.dstATop),
                      image: ExactAssetImage(paths.pathToDataBackupPic),
                      fit: BoxFit.cover)
                    ),
                    child: Stack(
                      children: [
                      Positioned(
                        top: 10,
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            IconButton(icon: Icon(Icons.arrow_back),
                              iconSize: 35,
                              onPressed: ()=>Navigator.pop(context)),
                            SizedBox(width: 12),
                            Text('Data Backup', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_28))
                          ],
                        ),
                      ),
            
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Black242424.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          ),
                          child: Center(child: Text('Last backup at: ${nativeCodeCaller.lastBackupTime ?? ""}',
                          style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_20, color: Colors.white))),
                        ),
                      )
                    ],),
                  ),
            
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline,color: Colors.teal.withOpacity(0.5),size: 30),
                      SizedBox(width: 10),
                      Text('Your data will be backed up every 24 hours.',
                      style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.small))
                    ],
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async { 
                            /// if this operation was not a success.
                            if(!(await IdeaManager.backupIdeasNow(context: context))){
                              // remove sync now dialog.
                              await Future.delayed(Duration(seconds: 2), ()=> Navigator.pop(context));
                              phoneCannotCheckBiometricFlushBar(context: context);
                            } else await Future.delayed(Duration(seconds: 2), ()=> Navigator.pop(context));
                            
                            },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text('Backup Now',style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_23)),
                            Container(
                              width: 60,
                              child: Icon(FeatherIcons.uploadCloud,size: 30,color: Colors.teal))
                          ]),
                        ),
            
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Auto Backup',style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_23)),
                          Container(
                            width: 60,
                            child: Switch(value: Provider.of<Prefrences>(context).autoSyncEnabled,
                            onChanged: (bool enabledAutoSync) async =>
                              await Prefrences.instance.setAutoSync(enabledAutoSync, context: context) 
                            ))
                        ]),
                      ],
                    ),
                  )
                ],),
              ),
            ),
          );
        }
      ),
    );
  }
}