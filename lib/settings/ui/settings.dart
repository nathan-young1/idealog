import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(backgroundColor: Colors.amber),
          ListTile(title: Text('Manage Accout')),
          ListTile(title: Text('Data Syncronization')),
          ListTile(title: Text('Upgrade to premium')),
          ListTile(title: Text('About Idealog')),
          ListTile(title: Text('Log out'))
      ]),
    );
  }
}