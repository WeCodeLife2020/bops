import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildSvgIconButton extends StatelessWidget {
  final String assetImagePath;
  final VoidCallback onTap;
  final double? iconWidth;
  final double? iconHeight;
  final Color? color;
  const BuildSvgIconButton(
      {Key? key,
      required this.assetImagePath,
      this.color,
      required this.onTap,
      this.iconWidth,
      this.iconHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: IconButton(
        icon: SvgPicture.asset(
          color: color,
          assetImagePath,
          width: iconWidth ?? 20,
          height: iconHeight ?? 20,
        ),
        onPressed: onTap,
      ),
    );
  }
}
