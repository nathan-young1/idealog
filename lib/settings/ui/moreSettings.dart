import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/global/routes.dart';
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
                Text('More Settings',style: dosis.copyWith(fontSize: 28))
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
                    title: Text('Account settings',style: dosis.copyWith(fontSize: 20),),
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
                    child: Text('Check your account details, status of your premium subscription and amount of time left till expiration.'),
                  )
                ],
              ),
            ),

            SizedBox(height: 25),
            DottedLine(),
            SizedBox(height: 10),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.fingerprint,color: DarkBlue,size: 35),
                  title: Text('Fingerprint Lock',style: dosis.copyWith(fontSize: 20)),
                  trailing: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Switch(value: Provider.of<Prefrences>(context).fingerprintEnabled,
                       onChanged: (bool fingerprintEnabled) async =>
                        await Prefrences.instance.setFingerPrintAuth(fingerprintEnabled)
                      ))
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
                  child: Text('Enable/Disable the biometric authentication (fingerprint, face ID e.t.c) before accessing this application.'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}