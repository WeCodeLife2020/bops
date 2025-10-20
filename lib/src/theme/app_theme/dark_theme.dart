import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../widget_theme/text_theme.dart';

final ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkModeScaffoldColor,
  textTheme: darkTextTheme,
  // appBarTheme: darkAppBarTheme,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryColor,
    // secondary: AppColorDark.accentColor,
  ),
);
