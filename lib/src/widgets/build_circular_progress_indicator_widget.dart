import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BuildCircularProgressIndicatorWidget extends StatelessWidget {
  final Color? color;
  const BuildCircularProgressIndicatorWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryColorBlue,
      ),
    );
  }
}
