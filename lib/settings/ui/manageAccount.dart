import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ManageAccount extends StatelessWidget {
  bool value = false;
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
                IconButton(icon: Icon(Icons.arrow_back,color: Colors.black87),
                iconSize: 35,
                onPressed: ()=>Navigator.pop(context)),
                SizedBox(width: 10),
                Text('Manage Account',style: Poppins.copyWith(fontSize: 28))
              ],
            ),

            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.alarm_rounded,color: Colors.black87,size: 35),
              title: Text('Subscription status',style: Poppins.copyWith(fontSize: 20),),
              trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_ios,size: 22,color: Colors.black87))
            ),

            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.fingerprint,color: Colors.black87,size: 35),
              title: Text('Fingerprint Lock',style: Poppins.copyWith(fontSize: 20)),
              trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Switch(value: value, onChanged: (_) async {
                    
                    LocalAuthentication androidAuth = new LocalAuthentication();
                    bool phoneCanCheckBiometric = await androidAuth.canCheckBiometrics;
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    if(_ && phoneCanCheckBiometric){
                      try{
                      bool userIsAuthenticated = await androidAuth.authenticate(localizedReason: 'Authenicate yourself to proceed',
                      stickyAuth: true,
                      biometricOnly: true,
                      androidAuthStrings: AndroidAuthMessages(
                      signInTitle: 'Idealog Authentication',
                      biometricHint: ''
                    )
                      );
                      if(userIsAuthenticated){
                      pref.setBool('BiometricIsEnabled', true);
                      value = true;
                      }
                      else{
                      _=false;
                      }
                      }on PlatformException catch (e){
                        // alert error occured
                        _=false;
                      }
                    }else{
                      _=false;
                      pref.setBool('BiometricIsEnabled', false);
                    }

                  }))
            ),
          ],
        ),
      ),
    );
  }
}