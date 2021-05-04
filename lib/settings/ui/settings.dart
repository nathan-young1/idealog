import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/nativeCode/bridge.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          DottedBorder(
            color: LightGray,
            strokeWidth: 3,
            padding: EdgeInsets.all(10),
            dashPattern: [40, 20], 
            borderType: BorderType.Oval,
            strokeCap: StrokeCap.square,
            child: Opacity(opacity: 0.65,
            child: Image.asset(pathToAppLogo,height: 210,width: 200)),
          ),
        
          Text('Idealog v1.2',
            style: Overpass.copyWith(fontSize: 28,color: Color.fromRGBO(112, 112, 112, 1))
            ),
            SizedBox(height: 10),

          ListTile(title: Text('Manage Account')),
          ListTile(title: Text('Data Syncronization'),onTap: () async {
            await signInWithGoogle();
            await NativeCodeCaller.startAutoSync();
          },),
          ListTile(title: Text('Stop Data Syncronization'),onTap: () async => await NativeCodeCaller.stopAutoSync()),
          ListTile(title: Text('Upgrade to premium')),
          ListTile(title: Text('About Idealog')),
          ListTile(title: Text('Log out'))
      ]),
    );
  }
}