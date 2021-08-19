import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';


class ManageAccount extends StatelessWidget {
  
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
                Text('Manage Account',style: poppins.copyWith(fontSize: 28))
              ],
            ),

            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.alarm_rounded,color: Colors.black87,size: 35),
              title: Text('Subscription status',style: poppins.copyWith(fontSize: 20),),
              trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_ios,size: 22,color: Colors.black87))
            ),

            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.fingerprint,color: Colors.black87,size: 35),
              title: Text('Fingerprint Lock',style: poppins.copyWith(fontSize: 20)),
              trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Switch(value: Provider.of<Prefrences>(context).fingerprintEnabled,
                   onChanged: (bool fingerprintEnabled) async =>
                    await Prefrences.instance.setFingerPrintAuth(fingerprintEnabled)
                  ))
            )
          ],
        ),
      ),
    );
  }
}