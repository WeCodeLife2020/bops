import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_button.dart';
import 'package:flutter/material.dart';

class BuildSvgIconButtonWithBackgroundWidget extends StatefulWidget {
  final String assetImagePath;
  final Color? iconColor;
  final Color? backgroundColor;
  final Function onTap;
  final BoxShape? boxShape;
  final double? iconSize;
  const BuildSvgIconButtonWithBackgroundWidget({
    super.key,
    required this.assetImagePath,
    this.iconColor,
    this.backgroundColor,
    required this.onTap,
    this.boxShape,
    this.iconSize,
  });

  @override
  State<BuildSvgIconButtonWithBackgroundWidget> createState() =>
      _BuildSvgIconButtonWithBackgroundWidgetState();
}

class _BuildSvgIconButtonWithBackgroundWidgetState
    extends State<BuildSvgIconButtonWithBackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: widget.boxShape ?? BoxShape.circle,
          color: widget.backgroundColor ?? AppColors.dropdownCardColor),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: BuildSvgIconButton(
            assetImagePath: widget.assetImagePath,
            color: widget.iconColor,
            iconHeight: widget.iconSize ?? 25,
            onTap: () {
              widget.onTap();
            }),
      ),
    );
  }
}
