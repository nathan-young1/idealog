import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:provider/provider.dart';

class Syncronization extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NativeCodeCaller>.value(value: NativeCodeCaller.instance)
      ],
      child: Builder(
        builder: (context) {
          String? date = Provider.of<NativeCodeCaller>(context).lastBackupTime ?? '';
          return SafeArea(
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
                    image: ExactAssetImage(pathToDataSyncIllustration),
                    fit: BoxFit.cover)
                  ),
                  child: Stack(
                    children: [
                    Positioned(
                      top: 10,
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          IconButton(icon: Icon(Icons.arrow_back,color: Colors.black87),
                            iconSize: 35,
                            onPressed: ()=>Navigator.pop(context)),
                          SizedBox(width: 12),
                          Text('Data Backup',style: Poppins.copyWith(fontSize: 24))
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
                        child: Center(child: Text('Last backup at: $date',
                        style: Overpass.copyWith(fontSize: 18,color: Colors.white),)),
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
                    style: Overpass.copyWith(fontSize: 15,fontWeight: FontWeight.w300))
                  ],
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async =>
                          await IdeaManager.backupIdeasNow(Provider.of<List<Idea>>(context,listen: false)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Backup Now',style: Overpass.copyWith(fontSize: 20)),
                          Container(
                            width: 60,
                            child: Icon(FeatherIcons.uploadCloud,size: 30,color: Colors.teal))
                        ]),
                      ),
          
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('Auto Backup',style: Overpass.copyWith(fontSize: 20)),
                        Container(
                          width: 60,
                          child: Switch(value: Provider.of<Prefrences>(context).autoSyncEnabled,
                          onChanged: (bool enabledAutoSync) async =>
                            await Prefrences.instance.setAutoSync(enabledAutoSync)
                          ))
                      ]),
          
                      SizedBox(height: 10),
                      ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                      title: Text('Backup Account',style: Overpass.copyWith(fontSize: 20)),
                      subtitle: Text(Provider.of<GoogleUserData>(context).user_email ?? 'None',style: Overpass.copyWith(fontSize: 15)),
                      onTap: () async {
                        await signOutFromGoogle();
                        await signInWithGoogle();
                      })
                    ],
                  ),
                )
              ],),
            ),
          );
        }
      ),
    );
  }
}