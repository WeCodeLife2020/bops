import 'package:bops_mobile/src/screens/details_screens/vehicle_details_screen.dart';
import 'package:bops_mobile/src/screens/onboarding_screens/login_screen.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/get_started_image.png',
            fit: BoxFit.cover,
          ),
          // Content Layer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight(context, dividedBy: 4)),
                Text(
                  "Get Started, Login to",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Blue Ocean",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryColorBlue,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Effortlessly find and reserve parking spots with our convenient bops app ",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 40),
              child: SliderButton(
                  alignLabel: Alignment.center,
                  backgroundColor: AppColors.primaryColorBlue,
                  buttonSize: 55,
                  height: 65,
                  width: screenWidth(context, dividedBy: 1.2),
                  action: () async {
                    print("DONE");
                    pushAndReplacement(context, LoginScreen());
                    return null;
                  },
                  label: Text(
                    "GET STARTED",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  icon: BuildSvgIcon(
                    assetImagePath: AppAssets.getStartedArrowIcon,
                    iconHeight: 35,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
