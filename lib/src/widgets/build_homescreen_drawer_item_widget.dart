import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_with_background_widget.dart';
import 'package:flutter/material.dart';

class BuildHomescreenDrawerItemWidget extends StatefulWidget {
  final String buttonText;
  final String assetImagePath;
  final Function onTap;

  const BuildHomescreenDrawerItemWidget({
    super.key,
    required this.buttonText,
    required this.assetImagePath,
    required this.onTap,
  });

  @override
  State<BuildHomescreenDrawerItemWidget> createState() =>
      _BuildHomescreenDrawerItemWidgetState();
}

class _BuildHomescreenDrawerItemWidgetState
    extends State<BuildHomescreenDrawerItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Container(
          width: screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: AppColors.dropdownCardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              children: [
                BuildSvgIconWithBackgroundWidget(
                  assetImagePath: widget.assetImagePath,
                  backgroundColor: AppColors.blue20,
                  iconSize: 25,
                ),
                const SizedBox(width: 15),
                Text(
                  widget.buttonText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
