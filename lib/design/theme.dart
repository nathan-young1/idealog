import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';
import 'colors.dart';

class AppTheme{
  
  static final ThemeData lightTheme = ThemeData(
                                brightness: Brightness.light,
                                scrollbarTheme: ScrollbarThemeData(
                                radius: Radius.circular(10),
                                thickness: MaterialStateProperty.all(5),
                                thumbColor: MaterialStateProperty.all(LightBlue),
                                mainAxisMargin: 10,
                                ),
                                scaffoldBackgroundColor: Colors.white,
                                colorScheme: ColorScheme.light(primary: DarkBlue, secondary: DarkBlue, secondaryVariant: DarkBlue, primaryVariant: DarkBlue),
                                iconTheme: IconThemeData(color: Colors.black87),
                                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: DarkBlue),
                                bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedLabelStyle: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small, color: DarkBlue), backgroundColor: DarkBlue),
                                cardTheme: CardTheme(color: Colors.white),
                                accentColor: DarkBlue,
                                toggleableActiveColor: DarkBlue,
                                textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black, selectionColor: LightBlue, selectionHandleColor: LightBlue),
                                splashColor: LightGray,
                                indicatorColor: LightBlue,
                                inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(fontSize: 15), fillColor: LightGray),
                                );

  static final ThemeData darkTheme = ThemeData(
                                scaffoldBackgroundColor: Black242424,
                                brightness: Brightness.dark,
                                accentColor: LightPink,
                                primaryColor: LightPink,
                                colorScheme: ColorScheme.dark(primary: DarkRed, secondary: DarkRed, secondaryVariant: DarkRed, primaryVariant: DarkRed),
                                iconTheme: IconThemeData(color: Colors.white),
                                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: LightPink),
                                bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedLabelStyle: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small, color: DarkRed), backgroundColor: DarkRed),
                                cardTheme: CardTheme(color: LightDark),
                                toggleableActiveColor: DarkRed,
                                textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white, selectionColor: Colors.black, selectionHandleColor: Colors.black),
                                splashColor: LightGray,
                                indicatorColor: DarkRed,
                                inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(fontSize: 15, color: Colors.white), fillColor: DarkGray),
                                );
}