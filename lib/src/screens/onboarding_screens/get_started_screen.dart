import 'package:bops_mobile/src/screens/details_screens/vehicle_details_screen.dart';
import 'package:bops_mobile/src/screens/onboarding_screens/login_screen.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_slider_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:happy_slider/happy_slider.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/get_started_image.png",),fit: BoxFit.cover)),
        // Background Image

        // Content Layer
        child: Padding(
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
              Spacer(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 40),
                      child: BuildSliderButtonWidget(
                        buttonHeight: 70,
                        innerColor: AppColors.primaryColorBlue,
                        onSlide: () {
                          pushAndReplacement(context, LoginScreen());
                        },
                        buttonText: "Let's Go",
                        fontSize: 14,
                        outerColor: AppColors.blue10,

                        suffixIcon: Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          color: AppColors.whiteTextColor,
                          size: 50,
                        ),
                      )
                      // HappySlider(
                      //   width: screenWidth(context, dividedBy: 1.2),
                      //   height: 65,
                      //   borderRadius: 50,
                      //   buttonColor: AppColors.primaryColorBlue,
                      //   backgroundColor: AppColors.whiteTextColor,
                      //   text: "",
                      //   buttonText: "Let's Go",
                      //   buttonTextStyle: TextStyle(color: AppColors.whiteTextColor),
                      //   defaultIconColor: AppColors.whiteTextColor,
                      //   sliderButton: Container(
                      //     height: 65,
                      //     decoration: BoxDecoration(
                      //       color: AppColors.primaryColorBlue,
                      //       borderRadius: BorderRadius.circular(50),
                      //     ),
                      //     child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           "Let's Go",
                      //           style: TextStyle(color: AppColors.whiteTextColor),
                      //         ),const SizedBox(width: 15,),
                      //         Icon(Icons.keyboard_double_arrow_right_rounded)
                      //       ],
                      //     ),
                      //   ),
                      //   onSlideComplete: () {
                      //     pushAndReplacement(context, LoginScreen());
                      //     //       return null;
                      //   },
                      )
                  // SliderButton(
                  //     alignLabel: Alignment.center,
                  //     backgroundColor: AppColors.primaryColorBlue,
                  //     buttonSize: 55,
                  //     height: 65,
                  //     width: screenWidth(context, dividedBy: 1.2),
                  //     action: () async {
                  //       print("DONE");
                  //       pushAndReplacement(context, LoginScreen());
                  //       return null;
                  //     },
                  //     label: Text(
                  //       "GET STARTED",
                  //       style: Theme.of(context).textTheme.labelMedium,
                  //     ),
                  //     icon: BuildSvgIcon(
                  //       assetImagePath: AppAssets.getStartedArrowIcon,
                  //       iconHeight: 35,
                  //     )
                  //     ),
                  ),
            ],
          ),
        ),

        // ),
      ),
    );
  }
}
