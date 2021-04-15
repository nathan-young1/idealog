import 'package:flutter/material.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:idealog/nativeCode/bridge.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(backgroundColor: Colors.amber),
          ListTile(title: Text('Manage Accout')),
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