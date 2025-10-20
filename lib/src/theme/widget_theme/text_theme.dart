import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../utils/font_family.dart';

TextTheme lightTextTheme = TextTheme(
  /// for elevated button text
  labelMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: FontFamily.poppins,
    color: AppColors.buttonTextColorDefault,
  ),

  /// for dropdown text and detail view card text
  labelSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.gothamBook,
    color: AppColors.dropDownTextColor,
  ),

  /// for appbar title
  headlineLarge: TextStyle(
    color: AppColors.appBarTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.poppins,
  ),

  /// for medium healines throughout the app
  headlineMedium: TextStyle(
    color: AppColors.mediumHeadingColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: FontFamily.gothamBold,
  ),

  /// for headings above textfields
  /// used for heading in report download successful screen
  /// 
  headlineSmall: TextStyle(
    color: AppColors.mediumHeadingColor,
    fontSize: 12,
    fontFamily: FontFamily.gothamBook,
    fontWeight: FontWeight.w300,
  ),

  /// for large body texts, used in managers list name title
  bodyLarge: TextStyle(
    color: AppColors.mediumHeadingColor,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamily.gothamBold,
  ),

  /// for medium text sizes, used in tabbar texts
  bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: FontFamily.poppins),

  /// for grey small sized text, used in management screen item cards
  bodySmall: TextStyle(
      color: AppColors.greySmallSizedTextColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      fontFamily: FontFamily.gothamBook),

  /// for textfield hint text
  displaySmall: TextStyle(
    color: AppColors.textFieldHintTextColor,
    fontSize: 14,
    fontFamily: FontFamily.gothamBook,
    fontWeight: FontWeight.w400,
  ),
);

TextTheme darkTextTheme = TextTheme(
  /// for elevated button text
  labelMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: FontFamily.poppins,
    color: AppColors.buttonTextColorDefault,
  ),

  /// for dropdown text color
  labelSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.gothamBook,
    color: AppColors.dropDownTextColor,
  ),

  /// for appbar title
  headlineLarge: TextStyle(
    color: AppColors.appBarTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.poppins,
  ),

  /// for headings above textfields
  headlineSmall: TextStyle(
    color: AppColors.mediumHeadingColor,
    fontSize: 12,
    fontFamily: FontFamily.gothamBook,
    fontWeight: FontWeight.w300,
  ),

  /// for medium healines throughout the app
  headlineMedium: TextStyle(
    color: AppColors.mediumHeadingColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: FontFamily.gothamBold,
  ),

  /// for large body texts, used in managers list name title
  bodyLarge: TextStyle(
    color: AppColors.mediumHeadingColor,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamily.gothamBold,
  ),

  /// for medium text sizes, used in tabbar texts
  bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: FontFamily.poppins),

  /// for grey small sized text, used in management screen item cards
  bodySmall: TextStyle(
      color: AppColors.greySmallSizedTextColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      fontFamily: FontFamily.gothamBook),

  /// for textfield hint text
  displaySmall: TextStyle(
    color: AppColors.textFieldHintTextColor,
    fontSize: 14,
    fontFamily: FontFamily.gothamBook,
    fontWeight: FontWeight.w400,
  ),
);
