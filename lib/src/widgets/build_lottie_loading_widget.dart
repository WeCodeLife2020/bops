import 'package:bops_mobile/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuildLottieLoadingWidget extends StatefulWidget {
  final double? lottieHeight;
  final double? lottieWidth;
  const BuildLottieLoadingWidget({
    super.key,
    this.lottieHeight,
    this.lottieWidth,
  });

  @override
  State<BuildLottieLoadingWidget> createState() =>
      _BuildLottieLoadingWidgetState();
}

class _BuildLottieLoadingWidgetState extends State<BuildLottieLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      'assets/lottie/loading.json',
      height: widget.lottieHeight ?? screenHeight(context, dividedBy: 6),
      width: widget.lottieWidth ?? screenHeight(context, dividedBy: 6),
    ));
  }
}
