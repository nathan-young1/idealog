import 'package:community_material_icon/community_material_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/strings.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoogleUserData _googleUserData = Provider.of<GoogleUserData>(context);
    bool isDarkMode = Provider.of<Prefrences>(context).isDarkMode;
    Color _listTileIconColor = (isDarkMode) ?LightPink :DarkBlue;
    return Container(
      child: Column(
        children: [
          SizedBox(height: 55),
          DottedBorder(
            color: LightGray,
            strokeWidth: 3,
            padding: EdgeInsets.only(bottom: 5),
            dashPattern: [10, 20], 
            borderType: BorderType.Oval,
            strokeCap: StrokeCap.square,
            child: Container(
              height: 170,
              width: 170,
              child: (_googleUserData.userIdentity != null)
              ? GoogleUserCircleAvatar(identity: _googleUserData.userIdentity!)
              : Opacity(
                opacity: 0.7,
                child: Image.asset(Provider.of<Prefrences>(context).appLogoPath,
                excludeFromSemantics: true,
                fit: BoxFit.contain),
              )),
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
                ListTile(leading: Icon(FeatherIcons.user,size: 30,color: _listTileIconColor),
                title: Text('Manage Account',style: Poppins.copyWith(fontSize: 20)),
                onTap: ()=>Navigator.pushNamed(context, 'ManageAccount'),),

                ListTile(leading: Icon(FeatherIcons.uploadCloud,size: 30,color: _listTileIconColor),
                title: Text('Data Syncronization',style: Poppins.copyWith(fontSize: 20)),
                onTap: ()=> Navigator.pushNamed(context, 'Syncronization')),

                ListTile(leading: Icon(PhosphorIcons.caret_double_up,size: 30,color: _listTileIconColor),
                title: Text('Upgrade to premium',style: Poppins.copyWith(fontSize: 20)),
                onTap: ()=> Navigator.pushNamed(context,'UpgradeToPremium')),

                ListTile(leading: Icon(CommunityMaterialIcons.help,size: 30,color: _listTileIconColor), 
                title: Text('About Idealog',style: Poppins.copyWith(fontSize: 20))),
              ],
            ),
          )
      ]),
    );
  }
}