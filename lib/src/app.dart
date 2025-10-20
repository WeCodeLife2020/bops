import 'package:bops_mobile/src/screens/check_out_vehicle_screens/check_out_vehicle_listing_screen.dart';
import 'package:bops_mobile/src/screens/home_screens/home_screen.dart';
import 'package:bops_mobile/src/screens/onboarding_screens/get_started_screen.dart';
import 'package:bops_mobile/src/screens/profile_screens/requested_users_listing_screen.dart';
import 'package:bops_mobile/src/theme/app_theme/app_theme_data.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget selectedWidget = GetStartedScreen();
  bool isLoggedIn = false;

  @override
  void initState() {
    initialization();
    super.initState();
  }

  void initialization() async {
    print("PAUSING TO CHECK LOGIN STATUS");
    print("LOGIN STATUS:${ObjectFactory().appHive.getIsLoggedIn()} ");
    isLoggedIn = ObjectFactory().appHive.getIsLoggedIn();
    isLoggedIn
        ? setState(() {

            selectedWidget = HomeScreen();
          })
        : setState(() {
            selectedWidget = GetStartedScreen();
          });
    print("RESUMING AFTER FETCHING LOGIN STATUS");
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valet Parking',

      darkTheme: AppThemeData.darkTheme,
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.darkTheme,
      themeMode: ThemeMode.dark,
      home: selectedWidget,
    );
  }
}
