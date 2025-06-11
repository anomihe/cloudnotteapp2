import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeMode => _isDarkMode ? darkTheme : lightTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    log('ThemeProvider: toggleTheme: $_isDarkMode');
    localStore.put('isDarkMode', _isDarkMode);
    notifyListeners();
    // var box = Hive.box('localStorage');
    // box.put('isDarkMode', _isDarkMode);
  }

  void _loadTheme() async {
    // var box = Hive.box('localStorage');
    _isDarkMode = localStore.get('isDarkMode', defaultValue: isDarkMode);
    log('ThemeProvider: _loadTheme: $_isDarkMode');
    notifyListeners();
  }
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.dmSans(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: darkShades[0],
    ),
    headlineMedium: GoogleFonts.dmSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: darkShades[0],
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: darkShades[0],
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: darkShades[0],
    ),
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: darkShades[0],
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(redShades[1]),
    trackColor: WidgetStateProperty.all(blueShades[3]),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: whiteShades[0],
    titleTextStyle: setTextTheme(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: darkShades[0],
    ),
    contentTextStyle: GoogleFonts.dmSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: darkShades[0],
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: blueShades[0],
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  // scaffoldBackgroundColor: blueShades[14],
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.dmSans(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: whiteShades[0],
    ),
    headlineMedium: GoogleFonts.dmSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: whiteShades[0],
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: whiteShades[0],
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: whiteShades[0],
    ),
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: whiteShades[0],
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: darkShades[0],
    titleTextStyle: GoogleFonts.dmSans(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: whiteShades[0],
    ),
    contentTextStyle: setTextTheme(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: whiteShades[0],
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(redShades[1]),
    trackColor: WidgetStateProperty.all(blueShades[3]),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: blueShades[0],
  ),
);
