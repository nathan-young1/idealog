import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/customWidget/alertDialog/premiumDialog.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:provider/provider.dart';


class MoreSettings extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 12),
                IconButton(icon: Icon(Icons.arrow_back),
                iconSize: 35,
                onPressed: ()=>Navigator.pop(context)),
                SizedBox(width: 10),
                Text('More Settings',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_28))
              ],
            ),

            Container(
              child: Image.asset(
              Paths.pathToSettingsPic,
              height: 200,
              width: 250,
              fit: BoxFit.contain)
            ),

            SizedBox(height: 20),
            GestureDetector(
              onTap: ()=> Navigator.pushNamed(context, accountSettingsPage),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.alarm_rounded,color: Colors.teal[800],size: 35),
                    title: Text('Account settings',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
                    trailing: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: LightGray,
                          ),
                          child: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.black87)))
                  ),
            
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
                    child: Text('Check your account details, status of your premium subscription and amount of time left till expiration.', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_15)),
                  )
                ],
              ),
            ),

            SizedBox(height: 25),
            DottedLine(dashColor: (Prefrences.instance.isDarkMode) ?Colors.white70 :Colors.black87),
            SizedBox(height: 10),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.fingerprint,color: DarkBlue,size: 35),
                  title: Text('Fingerprint Lock',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
                  trailing: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Switch(value: Provider.of<Prefrences>(context).fingerprintEnabled,
                       onChanged: (bool fingerprintEnabled) async {
                         // show purchase premium dialog if the user is not a premium user.
                          if(!Premium.instance.isPremiumUser){
                            bool? userWantsToUpgradeToPremium = await showPremiumDialog(context: context);
                            if(userWantsToUpgradeToPremium == null) return;

                            if(userWantsToUpgradeToPremium){
                              Navigator.of(context).pushNamed(upgradeToPremiumPage);
                              return;
                            } else return;
                            
                          }

                         try{await Prefrences.instance.setFingerPrintAuth(fingerprintEnabled);}
                         on Exception {phoneCannotCheckBiometricFlushBar(context: context);}
                       }
                      ))
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
                  child: Text('Enable/Disable the biometric authentication (fingerprint, face ID e.t.c) before accessing this application.', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_15)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}