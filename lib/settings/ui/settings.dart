import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/customWidget/profilePicWidget.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? _userProfilePic = Provider.of<GoogleUserData>(context).userPhotoUrl;
    var isDarkMode = Provider.of<Prefrences>(context).isDarkMode;
    var _listTileIconColor = (isDarkMode) ?LightPink :DarkBlue;
        return Container(
          child: Column(
            children: [
              SizedBox(height: 55),
              (_userProfilePic != null)
              ?ProfilePicture(photoUrl: _userProfilePic,height: 150,width: 150)
              :Container(
                height: 170,
                width: 170,
                child: Opacity(
                  opacity: 0.7,
                  child: Image.asset(Provider.of<Paths>(context).pathToLogo,
                  excludeFromSemantics: true,
                  fit: BoxFit.contain),
                )),
        
            SizedBox(height: 30),
              Text('Idealog v1.2',
                style: overpass.copyWith(fontSize: 25,color: Color.fromRGBO(112, 112, 112, 1))
                ),
                SizedBox(height: 60),
        
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    ListTile(leading: Icon(FeatherIcons.user,size: 30,color: _listTileIconColor),
                    title: Text('Manage Account',style: poppins.copyWith(fontSize: 20)),
                    onTap: ()=>Navigator.pushNamed(context, 'ManageAccount'),),
        
                    ListTile(leading: Icon(FeatherIcons.uploadCloud,size: 30,color: _listTileIconColor),
                    title: Text('Data Backup',style: poppins.copyWith(fontSize: 20)),
                    onTap: ()=> Navigator.pushNamed(context, 'Syncronization')),
        
                    ListTile(leading: Icon(PhosphorIcons.caret_double_up,size: 30,color: _listTileIconColor),
                    title: Text('Upgrade to premium',style: poppins.copyWith(fontSize: 20)),
                    onTap: ()=> Navigator.pushNamed(context,'UpgradeToPremium'))
                  ],
                ),
              )
          ]),
        );
  }
}