import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:happy_slider/happy_slider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class BuildSliderButtonWidget extends StatelessWidget {
  final String buttonText;
  final Function onSlide;
  final double? buttonWidth;
  final double? buttonHeight;
  final Widget? suffixIcon;
  final Color? innerColor;
 final Color? textColor;
 final Color? outerColor;
 final double? fontSize;
  const BuildSliderButtonWidget({
    super.key,
    required this.onSlide,
    required this.buttonText,
    this.buttonHeight,
    this.buttonWidth,
    this.suffixIcon,
    this.innerColor,
    this.textColor,
    this.outerColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      height: buttonHeight ?? 65,
      borderRadius: 50,
      text: buttonText,
      onSubmit: () {
        onSlide();
      },
      innerColor: innerColor,
submittedIcon: Icon(Icons.check_rounded,color: AppColors.primaryColorBlue,),
      outerColor: outerColor??AppColors.whiteTextColor,
      sliderButtonIcon: suffixIcon,
      sliderButtonIconPadding: 5,
      enabled: true,
      reversed: false,
      child: Text(buttonText,style: TextStyle(color:  textColor,fontSize: fontSize),),

    );
    //   HappySlider(
    //   width: buttonWidth?? screenWidth(context, dividedBy: 1.2),
    //   height: buttonHeight ?? 65,
    //   borderRadius: 50,
    //   buttonColor: AppColors.primaryColorBlue,
    //   backgroundColor: AppColors.whiteTextColor,
    //   text: "",
    //   buttonText: "",
    //   buttonTextStyle: TextStyle(color: AppColors.whiteTextColor),
    //   defaultIconColor: AppColors.whiteTextColor,
    //   sliderButton: Container(
    //     height: buttonHeight ?? 65,
    //     decoration: BoxDecoration(
    //       color: AppColors.primaryColorBlue,
    //       borderRadius: BorderRadius.circular(50),
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         suffixIcon ?? SizedBox(),
    //         SizedBox(
    //           width: suffixIcon != null ? 15 : 0,
    //         ),
    //         Text(
    //           buttonText,
    //           style: TextStyle(color: AppColors.whiteTextColor),
    //         ),
    //         const SizedBox(
    //           width: 15,
    //         ),
    //         suffixIcon != null? const SizedBox(): Icon(Icons.keyboard_double_arrow_right_rounded)
    //       ],
    //     ),
    //   ),
    //   onSlideComplete: () {
    //     onSlide();
    //     //       return null;
    //   },
    // );
  }
}
