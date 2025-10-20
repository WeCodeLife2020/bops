import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../widget_theme/app_bar_theme.dart';
import '../widget_theme/text_theme.dart';

final ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    // secondary: AppColorDark.accentColor,
  ),
  scaffoldBackgroundColor: AppColors.lightModeScaffoldColor,
  textTheme: lightTextTheme,
  appBarTheme: lightAppBarTheme,
);
