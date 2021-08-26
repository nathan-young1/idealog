import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/textStyles.dart';
import 'colors.dart';

class AppTheme with ChangeNotifier{
  AppTheme._();
  static final instance = AppTheme._();

  static Color StaticDarkBlueOrDarkRedDependingOnTheme = (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue;

  Color get DarkBlueOrDarkRedDependingOnTheme => (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue;
  Color get DarkBlueOrLightPinkDependingOnTheme => (Prefrences.instance.isDarkMode) ?LightPink :DarkBlue;

  @override
  notifyListeners()=> StaticDarkBlueOrDarkRedDependingOnTheme = (Prefrences.instance.isDarkMode) ?DarkRed :DarkBlue;
  
  static final ThemeData lightTheme = ThemeData(
                                brightness: Brightness.light,
                                scrollbarTheme: ScrollbarThemeData(
                                radius: Radius.circular(10),
                                thickness: MaterialStateProperty.all(5),
                                thumbColor: MaterialStateProperty.all(LightBlue),
                                mainAxisMargin: 10,
                                ),
                                scaffoldBackgroundColor: Colors.white,
                                colorScheme: ColorScheme.light(),
                                iconTheme: IconThemeData(color: Colors.black87),
                                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: DarkBlue),
                                bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedLabelStyle: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small, color: DarkBlue))
                                );

  static final ThemeData darkTheme = ThemeData(
                                scaffoldBackgroundColor: Black242424,
                                brightness: Brightness.dark,
                                accentColor: LightPink,
                                primaryColor: LightPink,
                                colorScheme: ColorScheme.dark(),
                                iconTheme: IconThemeData(color: Colors.white),
                                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: LightPink),
                                bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedLabelStyle: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small, color: DarkRed))
                                );
}