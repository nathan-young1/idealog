import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';


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
                  child: Switch(value: true, onChanged: (_){}))
            ),

            SizedBox(height: 20),
            ListTile(
              title: Text('Log out',style: Poppins.copyWith(fontSize: 20)),
              trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.login,color: LightPink,size: 35))
            ),
          ],
        ),
      ),
    );
  }
}