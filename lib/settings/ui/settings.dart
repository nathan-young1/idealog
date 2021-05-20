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

        SizedBox(height: 30),
          Text('Idealog v1.2',
            style: Overpass.copyWith(fontSize: 25,color: Color.fromRGBO(112, 112, 112, 1))
            ),
            SizedBox(height: 60),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                ListTile(leading: Icon(FeatherIcons.user,size: 30,color: LightPink),
                title: Text('Manage Account',style: Poppins.copyWith(fontSize: 20,color: Colors.black)),
                trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_ios,size: 22,color: Colors.black),
                ),
                onTap: ()=>Navigator.pushNamed(context, 'ManageAccount'),),

                ListTile(leading: Icon(FeatherIcons.uploadCloud,size: 30,color: LightPink),
                title: Text('Data Syncronization',style: Poppins.copyWith(fontSize: 20,color: Colors.black)),
                trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_ios,size: 22,color: Colors.black)),
                onTap: ()=> Navigator.pushNamed(context, 'Syncronization')),

                ListTile(leading: Icon(PhosphorIcons.caret_double_up,size: 30,color: LightPink),
                title: Text('Upgrade to premium',style: Poppins.copyWith(fontSize: 20,color: Colors.black)),
                trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_ios,size: 22,color: Colors.black))),

                ListTile(leading: Icon(CommunityMaterialIcons.help,size: 30,color: LightPink), 
                title: Text('About Idealog',style: Poppins.copyWith(fontSize: 20,color: Colors.black)),
                trailing: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_ios,size: 22,color: Colors.black))),
              ],
            ),
          )
      ]),
    );
  }
}