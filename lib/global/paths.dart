import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/prefs.dart';

class Paths with ChangeNotifier{
/// singleton instance.
Paths._();
static final Paths instance = Paths._();

/// The preference class will use these method to notify this class of a theme change (Light or Dark).
void notifyClassOnThemeChanged()=> notifyListeners();

/// Path to the folder with pictures for different pages.
static const String _PathToAssetImageFolder = 'assets/images';
static const String _DataBackupPicFolderPath = '$_PathToAssetImageFolder/dataBackup';
static const String _IdeaPicFolderPath = '$_PathToAssetImageFolder/idea';
static const String _IntroPicFolderPath = '$_PathToAssetImageFolder/intro';
static const String _LogoPicFolderPath = '$_PathToAssetImageFolder/logo';
static const String _ProductivityPicFolderPath = '$_PathToAssetImageFolder/productivity';
static const String _SettingsPicFolderPath = '$_PathToAssetImageFolder/settings';
static const String _TaskPicFolderPath = '$_PathToAssetImageFolder/task';
static const String _SearchPicFolderPath = '$_PathToAssetImageFolder/search';

/// path to the logo
static const String _Logo_Light = '$_LogoPicFolderPath/Logo_Light.png';
static const String _Logo_Dark = '$_LogoPicFolderPath/Logo_Dark.png';

/// path to idea pictures
static const String _No_Idea_Light = '$_IdeaPicFolderPath/No_Idea_Light.png';
static const String _No_Idea_Dark = '$_IdeaPicFolderPath/No_Idea_Dark.png';

/// path to task pictures
static const String No_Tasks_Pic = '$_TaskPicFolderPath/No_Tasks_Dark.png';

/// path to productivity pictures
static const String _Favorite_Pic_Light = '$_ProductivityPicFolderPath/Favorite_Pic_Light.svg';
static const String _Favorite_Pic_Dark = '$_ProductivityPicFolderPath/Favorite_Pic_Dark.svg';

/// path to settings pictures
static const String _Setting_Pic =  '$_SettingsPicFolderPath/Setting_Pic.png';

/// path to data backup pictures
static const String _Data_Backup_Light = '$_DataBackupPicFolderPath/Data_Backup_Light.png';
static const String _Data_Backup_Dark = '$_DataBackupPicFolderPath/Data_Backup_Dark.png';

/// path to search not found pictures
static const String Search_Grey = '$_SearchPicFolderPath/search_not_found.png';

/// path to intro pictures
static const String Welcome_Intro_Pic = '$_IntroPicFolderPath/Welcome_Intro_Pic.png';
static const String Intro_Pic_2 = '$_IntroPicFolderPath/Intro_Pic_2.png';
static const String Intro_Pic_3 = '$_IntroPicFolderPath/Intro_Pic_3.png';

/// path to svg Icons
static const String more_settings_icon = '$_SettingsPicFolderPath/moreSettings.svg';



// ===================================Getters For the pictures============================= //
  // Checks The app current theme to determine the picture path to give.
  String get pathToLogo{
     if (Prefrences.instance.isDarkMode) return _Logo_Dark;
      return _Logo_Light;
  }

  String get pathToNoIdeaPic{
    if (Prefrences.instance.isDarkMode) return _No_Idea_Dark;
      return _No_Idea_Light;
  }

  String get pathToFavoritePic{
    if (Prefrences.instance.isDarkMode) return _Favorite_Pic_Dark;
      return _Favorite_Pic_Light;
  }

  String get pathToDataBackupPic{
    if (Prefrences.instance.isDarkMode) return _Data_Backup_Dark;
      return _Data_Backup_Light;
  }

  static String get pathToSettingsPic => _Setting_Pic;

}