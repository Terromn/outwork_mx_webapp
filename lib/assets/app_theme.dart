import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color_palette.dart';

final String? _teFont = GoogleFonts.mPlusRounded1c().fontFamily;

class TeAppThemeData {
  static const double contentMargin = 32;

  static final ThemeData darkTheme = ThemeData(
    primaryColorDark: TeAppColorPalette.green,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: TeAppColorPalette.green,
    ),
    // APPBAR //
    appBarTheme: AppBarTheme(
      backgroundColor: TeAppColorPalette.green,
      foregroundColor: TeAppColorPalette.black,
      elevation: 12,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: TeAppColorPalette.black,
        fontSize: 26,
        fontFamily: _teFont,
        fontWeight: FontWeight.bold,
      ),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: TeAppColorPalette.black,
      titleTextStyle: TextStyle(
        color: TeAppColorPalette.white,
        fontSize: 26,
        fontFamily: _teFont,
        fontWeight: FontWeight.bold,
      ),  
      contentTextStyle: TextStyle(
        color: TeAppColorPalette.white,
        fontSize: 18,
        fontFamily: _teFont,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center
      
    ),

    // BOTTOM NAV BAR //
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: TeAppColorPalette.green,
      selectedItemColor: TeAppColorPalette.black,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(size: 42),
      unselectedIconTheme: IconThemeData(size: 32),
      elevation: 12,
    ),

    // ElEVATED BUTTON //
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: TeAppColorPalette.black,
        )),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
        backgroundColor:
            MaterialStateProperty.all<Color>(TeAppColorPalette.green),
        alignment: Alignment.center,
        elevation: MaterialStateProperty.all(12),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    ),

    // SNACK BAR //
    snackBarTheme: const SnackBarThemeData(
      backgroundColor:
          TeAppColorPalette.green, // Set the desired background color
      contentTextStyle: TextStyle(
          color: TeAppColorPalette.black), // Set the desired text color
    ),

    // TEXT BUTTON //
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          TeAppColorPalette.black,
        ),
      ),
    ),

    // CARD //
    cardTheme: CardTheme(
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: TeAppColorPalette.white,
    ),

    // TEXTFIELD //
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: TeAppColorPalette.white),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: TeAppColorPalette.green, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    ),

    // TIME PICKER //
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: TeAppColorPalette.black,
      dialHandColor: TeAppColorPalette.green,
      dayPeriodColor: TeAppColorPalette.green,

      dialBackgroundColor: TeAppColorPalette.blackLight,
      hourMinuteColor: TeAppColorPalette.blackLight,
      dayPeriodTextColor: TeAppColorPalette.black,
      hourMinuteTextColor: TeAppColorPalette.green,
      // You can customize other properties as well
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: TeAppColorPalette.black,
      headerBackgroundColor: TeAppColorPalette.blackLight,
      headerForegroundColor: TeAppColorPalette.white,
      todayBorder: const BorderSide(color: TeAppColorPalette.green),
      dividerColor: TeAppColorPalette.green,
      todayBackgroundColor: MaterialStateProperty.all<Color>(
        TeAppColorPalette.black,
      ),
      dayOverlayColor: MaterialStateProperty.all<Color>(
        TeAppColorPalette.green,
      ),
      todayForegroundColor: MaterialStateProperty.all<Color>(
        TeAppColorPalette.green,
      ),
      rangeSelectionOverlayColor: MaterialStateProperty.all<Color>(
        TeAppColorPalette.green,
      ),
      rangePickerBackgroundColor: TeAppColorPalette.green,
      dayBackgroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return TeAppColorPalette.green;
        } else {
          return TeAppColorPalette.black;
        }
      }),
      dayForegroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return TeAppColorPalette.black;
        } else {
          return TeAppColorPalette.white;
        }
      }),
      surfaceTintColor: TeAppColorPalette.green,
      rangePickerHeaderForegroundColor: TeAppColorPalette.white,
    ),

    splashColor: TeAppColorPalette.green,
    scaffoldBackgroundColor: TeAppColorPalette.blackLight,

    // GENERAL //
    brightness: Brightness.dark,
    primaryColor: TeAppColorPalette.black,
    fontFamily: _teFont,
    textTheme: TextTheme(
      displayLarge: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: TeAppColorPalette.white),
      displayMedium:
          const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      bodyLarge: const TextStyle(
          fontSize: 20.0,
          color: TeAppColorPalette.white,
          fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.grey[300]),
    ),
  );
}
