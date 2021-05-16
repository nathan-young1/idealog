import 'package:community_material_icon/community_material_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/strings.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 55),
          DottedBorder(
            color: LightGray,
            strokeWidth: 3,
            padding: EdgeInsets.only(bottom: 5),
            dashPattern: [40, 20], 
            borderType: BorderType.Oval,
            strokeCap: StrokeCap.square,
            child: Opacity(opacity: 0.65,
            child: Image.asset(pathToAppLogo,height: 170,width: 170,
            excludeFromSemantics: true,
            fit: BoxFit.contain)),
          ),

        SizedBox(height: 20),
          Text('Idealog v1.2',
            style: Overpass.copyWith(fontSize: 28,color: Color.fromRGBO(112, 112, 112, 1))
            ),
            SizedBox(height: 40),

          ListTile(leading: Icon(FeatherIcons.user,size: 35,color: Colors.teal),title: Text('Manage Account')),
          ListTile(leading: Icon(FeatherIcons.uploadCloud,size: 35,color: Colors.teal),title: Text('Data Syncronization')),
          ListTile(leading: Icon(PhosphorIcons.caret_double_up,size: 35,color: Colors.teal),title: Text('Upgrade to premium')),
          ListTile(leading: Icon(CommunityMaterialIcons.help,size: 35,color: Colors.teal),  title: Text('About Idealog'))
      ]),
    );
  }
}