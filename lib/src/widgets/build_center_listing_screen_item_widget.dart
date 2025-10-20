import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';

class BuildCenterListingScreenItemWidget extends StatefulWidget {
  final bool isEvenItem;
  final String serialName;
  final String centerName;
  final Function editButtonTap;
  final Function deleteButtonTap;

  const BuildCenterListingScreenItemWidget({
    super.key,
    required this.isEvenItem,
    required this.serialName,
    required this.centerName,
    required this.editButtonTap,
    required this.deleteButtonTap,
  });

  @override
  State<BuildCenterListingScreenItemWidget> createState() =>
      _BuildCenterListingScreenItemWidgetState();
}

class _BuildCenterListingScreenItemWidgetState
    extends State<BuildCenterListingScreenItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      decoration: BoxDecoration(
        color: widget.isEvenItem
            ? AppColors.dividerColor
            : AppColors.lightModeScaffoldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(widget.serialName),
            const Spacer(),
            Text(widget.centerName),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.editButtonTap();
                  },
                  child: BuildSvgIcon(
                    assetImagePath: AppAssets.editIcon,
                    iconHeight: 18,
                  ),
                ),
                const SizedBox(width: 10),
                BuildSvgIcon(
                  assetImagePath: AppAssets.verticalDividerIcon,
                  iconHeight: 18,
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    widget.deleteButtonTap();
                  },
                  child: BuildSvgIcon(
                    assetImagePath: AppAssets.deleteIcon,
                    iconHeight: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
