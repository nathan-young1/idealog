import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskSearcher.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/customWidget/profilePicWidget.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/global/routes.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  Settings({required this.searchFieldController});
  /// use this to clear the search field before changing app theme to avoid flutter painter error
  final TextEditingController searchFieldController;

  @override
  Widget build(BuildContext context) {
    String? _userProfilePic = Provider.of<GoogleUserData>(context).userPhotoUrl;
    var isDarkMode = Provider.of<Prefrences>(context).isDarkMode;
    var _listTileIconColor = (isDarkMode) ?LightPink :DarkBlue;
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 55),
        
                (_userProfilePic != null)
                  ?ProfilePicture(photoUrl: _userProfilePic,height: 180,width: 180)
                  :DottedBorder(
                    color: DarkGray,
                    strokeWidth: 3,
                    padding: EdgeInsets.only(bottom: 5),
                    dashPattern: [10, 20], 
                    borderType: BorderType.Oval,
                    strokeCap: StrokeCap.square,
                    
                    child: Container(
                      height: 170,
                      width: 170,
                      child: Image.asset(Provider.of<Paths>(context).pathToLogo,
                      excludeFromSemantics: true,
                      fit: BoxFit.contain)),
                  ),
          
              SizedBox(height: 30),
                Text('Idealog v1.2',
                  style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.medium, color: Color.fromRGBO(112, 112, 112, 1))
                  ),
                  SizedBox(height: 70),
          
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8), 
                  child: Column(
                    children: [
                      ListTile(leading: SvgPicture.asset(Paths.more_settings_icon,height: 28, width: 28, color: _listTileIconColor),
                      // Icon(PhosphorIcons.faders_horizontal_bold,size: 30,color: _listTileIconColor),
                      title: Text('More Settings',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
                      onTap: ()=>Navigator.pushNamed(context, moreSettingsPage),),
          
                      ListTile(leading: Icon(FeatherIcons.uploadCloud,size: 30,color: _listTileIconColor),
                      title: Text('Data Backup',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
                      onTap: ()=> Navigator.pushNamed(context, backupPage)),
          
                      ListTile(leading: Icon(PhosphorIcons.caret_double_up,size: 30,color: _listTileIconColor),
                      title: Text('Upgrade to premium',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
                      onTap: ()=> Navigator.pushNamed(context, upgradeToPremiumPage)),
        
                      ListTile(leading: Icon(FeatherIcons.moon, size: 30, color: _listTileIconColor),
                      title: Text('Dark Mode',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
                      trailing: Switch(value: Provider.of<Prefrences>(context).isDarkMode,
                      onChanged: (bool isDarkMode) async { 
                        /// clear the searchFieldController first to avoid text painter error on change app theme.
                        clearSearch(searchFieldController, context);
                        await Prefrences.instance.setDarkMode(isDarkMode);
                        })),
                    ],
                  ),
                )
            ]),
          ),
        );
  }
}