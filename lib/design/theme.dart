import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme {
  
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
                                iconTheme: IconThemeData(color: Colors.black87)
                                );

  static final ThemeData darkTheme = ThemeData(
                                scaffoldBackgroundColor: Color(0x00202020),
                                brightness: Brightness.dark,
                                accentColor: LightPink,
                                primaryColor: LightPink,
                                colorScheme: ColorScheme.dark()
                                );
}