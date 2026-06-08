import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();
  static const appThemeColor = Color(0xffff7903);
  static const appThemeColorVariant1 = Color(0xffEAB632); //#
  static const backgroundColor = Color(0xffF7FCFE);
  static const blackBackgroundColor = Color(0xff2B2E32);
  static const white = Color(0xffffffff);
  static const whiteBorderColor = Color(0xffEFEFEF);
  static const greyBackgroundColor = Color(0xb33c3c43);
  static const darkGreyBackgroundColor = Color(0xff1E1E1E);
  static const primaryTextColor = Color(0xff1d1d1d);
  static const boldTextColor = Color(0xff1D1D1D);
  static const darkBlack = Color(0xff000000);
  static const black2 = Color(0xff2B2E32);
  static const black3 = Color(0xff424549);
  static const black4 = Color(0xffD0D1D1); //#D6A21F
  static const black5 = Color(0xffE7E8E8); //#E7E8E8
  static const yellowDark1 = Color(0xffD6A21F); //#FFEEEE
  static const errorBoxColor = Color(0xffFFEEEE); //##
  static const errorTextColor = Color(0xffFF383C); //#FF383C
  static const greyColor = Color(0xff727272); //#989898
  static const grey2Color = Color(0xff989898);
  static const grey3Color = Color(0xffB4B6B9);
  static const greenColor = Color(0xff48B022); //##0B6623
  static const darkGreenColor = Color(0xff0B6623); //#98FB9899
  static const amountPaidColor = Color(0xff0A7927); //#0A7927
  static const greenChipColor = Color(0xff98FB98);
  static const greenCheckColor = Color(0xff30C000);
  static const greenDiscountColor = Color(0xffC5FFC9);
  static const statusChipGreenColor = Color(0xffE9FFF2); //#FFF9EA
  static const yellowLight2 = Color(0xffFFF9EA);
  //#
  static const yellowPrimary = Color(0xffEAB632);
  //#FCFCFC
  static const white3 = Color(0xffFCFCFC);
  static const whiteVariant4 = Color(0xffFCFCFC);
  static const darkColor = Color(0xff1B1D21);
  static const logoutColor = Color(0xffE32E2E);
  static const redCrossColor = Color(0xffFA3D3D);
  //#
  static const ratingGradient1 = Color(0xffFFEEC2);
  //#
  static const ratingGradient2 = Color(0xffFFF9EA);
  static const chipBlueColor = Color(0xff3096EF);

  static const black = Color(0xff000000);

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: appThemeColor,
  );
}

class MyThemes {
  static final darkTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppTheme.backgroundColor,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppTheme.appThemeColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppTheme.backgroundColor,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppTheme.appThemeColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
  );
}
