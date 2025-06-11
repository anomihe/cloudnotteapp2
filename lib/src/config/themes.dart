import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const blueShades = [
  // [0] Color(0xFF4562C8), // rgba(69, 98, 200, 1) App blue
  Color(0xFF165DC2), // [0] rgba(22, 93, 194, 1) new app blue
  Color(
      0xFF2F66EE), // [1] rgba(47, 102, 238, 1) light blue texts / cards borders
  Color(0xFF172B47), // [2] rgba(23, 43, 71, 1) app text / call icons color
  Color(
      0xFFEAF5FF), // [3] rgba(234, 245, 255, 1) live call icons card / chat text fields
  Color(0xD9D9D9FF), // [4] rgba(217, 217, 217, 1) get started card border
  Color(
      0xFFF5F8FF), // [5] class schedules card / chats dividers // find schools card
  Color(0xFFE4ECFF), // [6] rgba(228, 236, 255, 1) class schedules card border
  Color(
      0xFFDFDFE6), // [7] rgba(223, 223, 230, 1) class sheduled non check circle color
  Color(0xFF171731), // [8] rgba(23, 23, 49, 1) chat text / +others card color
  Color(0x660C67FF), // [9] rgba(12, 103, 255, 0.4) chat day box
  Color(0xFFBDDBF4), // [10] rgba(189, 219, 244, 1) chat namecard box
  Color(0xFFE5F3FF), // [11] rgba(229, 243, 255, 1) received chat box color
  Color(0xFF0C67FF), // [12] rgba(12, 103, 255, 1) sent chat containers
  Color(0xFFAAAAB6), // [13] rgba(170, 170, 182, 1)
  Color(0xFF060912), // [14] rgba(6, 9, 18, 1) dark call action buttons color
  Color(
      0xFF111827), // [15] rgba(17, 24, 39, 1) dark call action button row background
  Color(0xFFC4C4C4), // [16] rgba(196, 196, 196, 1)
  Color(0xFFF5F8FF), // [17] rgba(245, 248, 255, 1)
  Color(0xFFE7EEFF), // [18] rgba(231, 238, 255, 1) light border color
  Color(0xFF7A8EE4), // [19] rgba(122, 142, 228, 1)
  Color(0xFF91A6D8), // [20] rgba(145, 166, 216, 1)
  Color(0xFF1B263D), // [21] rgba(27, 38, 61, 1) dark border color
];

const greenShades = [
  Color(0xFF5CC397), // [0] rgba(92, 195, 151, 1)
  Color(0xFFCBD87E), // [1] rgba(203, 216, 126, 1)
  Color(0xFFF4F6F6), // [2] rgba(244, 246, 246, 1)
  Color(0xFF9FE0C0)
];

const goldenShades = [
  Color(0xFFF9CD62), // [0] rgba(249, 205, 98, 1)
  Color(0xFFB2BC73), // [1] rgba(178, 188, 115, 1)
];

const redShades = [
  Color(0xFFEC5951), // [0] rgba(236, 89, 81, 1) red boxes and circles
  Color(0xFFBF1E2D), // [1] rgba(191, 30, 45, 1) button color
  Color(0xFFFF6D02), // [2] rgba(255, 109, 2, 1) orangeRed color boxes
  Color(0xCCFFFFFF), // [3] rgba(255, 255, 255, 0.8) video call nameCard boxes
  Color(0xFFEF4B3F), // [4] rgba(239, 75, 63, 1) red text color
  Color(0xFFFFDDE0), // [5] rgba(255, 221, 224, 1) live chat name card
  Color(0x99BF1E2D), // [6] rgba(191, 30, 45, 0.6) chat day header
  Color(0xFFF8F8F8), // [7] rgba(248, 248, 248, 1) received message box
  Color(0xFFF8D3DA), // [8] rgba(248, 211, 218, 1)
  Color(0xFFED80A0), // [9] rgba(237, 128, 160, 1)
  Color(0xFFF6ECFB), // [10] rgba(246, 236, 251, 1)
  Color(0xFFD387D3), // [11] rgba(211, 135, 211, 1)
  Color(0xFFDF3444), // [12] rgba(223, 52, 68, 1)
  Color(0xFFEF4031), // [13] rgba(239, 64, 49, 1)
];

const purpleShades = [
  Color(0xFF684CF0), // [0] rgba(104, 76, 240, 1)
];

const darkShades = [
  Colors.black, // [0]
  Color(0x80000000), // [1] rgba(0, 0, 0, 0.5)
];

const recordingColor = [
  Color(0xFFF9C8C4), // [0]
  Color(0xFFFDEDEE) // [1]
];

const freeAiColors = [
  Color(0xFFDDDBDB),
  Color(0xFFE8F9EF),
  Color(0xFF41A663),
  Color(0xFFFDEDEE),
  Color(0xFFBF1E2D),
];

const whiteShades = [
  Color(0xFFFFFFFF), // [0]
  Color(
      0xFFF1F1F1), // [1] rgba(241, 241, 241, 1) text fields / homework answer cards
  Color(0xFFF4F9FF), // [2] rgba(244, 249, 255, 1) chat text fields
  Color(0xFF9E9E9E), // [3] rgba(158, 158, 158, 1) profile card
  Color(0x80000000), // [4] rgba(0, 0, 0, 0.5)
  Color(0xFFF3F3F3), // [5] rgba(243, 243, 243, 1) profile card
  Color(0xFF9E9E9E), // [6] rgba(158, 158, 158, 1) profile card
  Color(0xFFF8F8F8), // [7] rgba(248, 248, 248, 1)
  Color(0xFFE9ECF1), // [8] rgba(233, 236, 239, 1)
  Color(0xE6F1F1F1), // [9] rgba(241, 241, 241, 0.9)
];

TextStyle setTextTheme({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? letterSpacing,
  double? lineHeight,
  TextDecoration? decoration,
  Color? decorationColor,
  TextStyle? textStyle,
}) {
  return GoogleFonts.dmSans(
    fontSize: fontSize ?? 15.sp,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color ?? (ThemeProvider().isDarkMode ? Colors.white : Colors.black),
    letterSpacing: letterSpacing,
    height: lineHeight,
    decoration: decoration,
    decorationColor: decorationColor,
    textStyle: textStyle,
  );
}

// shorter way of styling app text
// 15.w400.color(whiteShades[3]).letterSpacing(0.2).lineHeight(1.2).textTheme()
//
// class TextStyleBuilder {
//  double? _fontSize;
//   FontWeight? _fontWeight;
//   Color? _color;
//   double? _letterSpacing;
//   double? _lineHeight;
//   TextDecoration? _decoration;
//   TextStyle? _textStyle;

//   TextStyleBuilder size(double fontSize) {
//     _fontSize = fontSize.sp;
//     return this;
//   }

//   TextStyleBuilder weight(FontWeight fontWeight) {
//     _fontWeight = fontWeight;
//     return this;
//   }

//   TextStyleBuilder color(Color color) {
//     _color = color;
//     return this;
//   }

//   TextStyleBuilder letterSpacing(double letterSpacing) {
//     _letterSpacing = letterSpacing;
//     return this;
//   }

//   TextStyleBuilder lineHeight(double lineHeight) {
//     _lineHeight = lineHeight;
//     return this;
//   }

//   TextStyleBuilder decoration(TextDecoration decoration) {
//     _decoration = decoration;
//     return this;
//   }

//   TextStyleBuilder textStyle(TextStyle textStyle) {
//     _textStyle = textStyle;
//     return this;
//   }
// }

// TextStyle build() {
//     return GoogleFonts.dmSans(
//       fontSize: _fontSize ?? 15.sp,
//       fontWeight: _fontWeight ?? FontWeight.w600,
//       color: _color ?? Colors.black,
//       letterSpacing: _letterSpacing,
//       height: _lineHeight,
//       decoration: _decoration,
//     );
//   }

// extension TextStyleExtensions on double {
//   TextStyleBuilder get w100 => TextStyleBuilder().size(this).weight(FontWeight.w100);
//   TextStyleBuilder get w200 => TextStyleBuilder().size(this).weight(FontWeight.w200);
//   TextStyleBuilder get w300 => TextStyleBuilder().size(this).weight(FontWeight.w300);
//   TextStyleBuilder get w400 => TextStyleBuilder().size(this).weight(FontWeight.w400);
//   TextStyleBuilder get w500 => TextStyleBuilder().size(this).weight(FontWeight.w500);
//   TextStyleBuilder get w600 => TextStyleBuilder().size(this).weight(FontWeight.w600);
//   TextStyleBuilder get w700 => TextStyleBuilder().size(this).weight(FontWeight.w700);
//   TextStyleBuilder get w800 => TextStyleBuilder().size(this).weight(FontWeight.w800);
//   TextStyleBuilder get w900 => TextStyleBuilder().size(this).weight(FontWeight.w900);
// }

// extension TextStyleBuilderExtensions on TextStyleBuilder {
//   TextStyleBuilder color(Color color) => this..color(color);
//   TextStyleBuilder letterSpacing(double letterSpacing) => this..letterSpacing(letterSpacing);
//   TextStyleBuilder lineHeight(double lineHeight) => this..lineHeight(lineHeight);
//   TextStyleBuilder decoration(TextDecoration decoration) => this..decoration(decoration);
// }
