import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';

class BuildSvgIconWithBackgroundWidget extends StatefulWidget {
  final String assetImagePath;
  final Color? iconColor;
  final Color? backgroundColor;

  final BoxShape? boxShape;
  final double? iconSize;
  const BuildSvgIconWithBackgroundWidget({
    super.key,
    required this.assetImagePath,
    this.iconColor,
    this.backgroundColor,
    this.boxShape,
    this.iconSize,
  });

  @override
  State<BuildSvgIconWithBackgroundWidget> createState() =>
      _BuildSvgIconWithBackgroundWidgetState();
}

class _BuildSvgIconWithBackgroundWidgetState
    extends State<BuildSvgIconWithBackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: widget.boxShape ?? BoxShape.circle,
          color: widget.backgroundColor ?? AppColors.dropdownCardColor),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BuildSvgIcon(
          assetImagePath: widget.assetImagePath,
          color: widget.iconColor,
          iconHeight: widget.iconSize ?? 25,
        ),
      ),
    );
  }
}
