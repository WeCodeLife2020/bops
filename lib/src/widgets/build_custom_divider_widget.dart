import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class BuildCustomDividerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double? paddingLeft;
  final double? paddingRight;
  final Color? color;

  const BuildCustomDividerWidget({
    super.key,
    this.height,
    this.color,
    this.width,
    this.paddingRight,
    this.paddingLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: paddingRight ?? 0,
        left: paddingLeft ?? 0,
      ),
      child: Container(
        width: width ?? screenWidth(context),
        height: height ?? 0.5, 
        color: color ??
            AppColors.dividerColor
      ),
    );
  }
}
