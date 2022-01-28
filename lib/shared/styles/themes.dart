import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:planner/shared/styles/colors.dart';

ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: HexColor('333739'),
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      titleSpacing: 20,
      backgroundColor: HexColor('333739'),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Jannah',
        fontWeight: FontWeight.bold,
      ),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor('333739'),
          statusBarIconBrightness: Brightness.light),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey,
      elevation: 20,
      backgroundColor: HexColor('333739'),
    ),
    primarySwatch: Colors.pink,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3,
      ),
    ),
    fontFamily: 'Jannah');

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleSpacing: 20,
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'Jannah',
      fontWeight: FontWeight.bold,
    ),
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.pink.shade900,
        statusBarIconBrightness: Brightness.light,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20,
    backgroundColor: Colors.white,
  ),
  primarySwatch: Colors.pink,
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    subtitle1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      height: 1.3,
    ),
  ),
  fontFamily: 'Jannah',
);
