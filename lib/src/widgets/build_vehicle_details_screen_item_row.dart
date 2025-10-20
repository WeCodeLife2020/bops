import 'package:bops_mobile/src/utils/font_family.dart';
import 'package:bops_mobile/src/widgets/build_custom_divider_widget.dart';
import 'package:flutter/material.dart';

import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import 'build_svg_icon_with_background_widget.dart';

class BuildVehicleDetailsScreenItemRow extends StatefulWidget {
  final bool isDividerRequired;
  final String firstText;
  final String secondText;
  final double? secondFontSize;
  final bool isEditable;
  final Function?onTap;
  final Color? secondTextColor;

  const BuildVehicleDetailsScreenItemRow({
    super.key,
    required this.isDividerRequired,
    required this.firstText,
    required this.secondText,
    this.secondFontSize,
    this.isEditable = false,
    this.onTap,
    this.secondTextColor,
  });

  @override
  State<BuildVehicleDetailsScreenItemRow> createState() =>
      _BuildVehicleDetailsScreenItemRowState();
}

class _BuildVehicleDetailsScreenItemRowState
    extends State<BuildVehicleDetailsScreenItemRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                widget.firstText,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontFamily: FontFamily.gothamBook),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:  EdgeInsets.only(left: widget.isEditable? 18:0),
                child: Text(
                  widget.secondText,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: widget.secondFontSize ?? 12,color:widget.secondTextColor ),
                ),
              ),
            ),
            if (widget.isEditable) ...[
              InkWell(
                onTap: (){
                  widget.onTap!();
                },
                child: BuildSvgIconWithBackgroundWidget(
                    assetImagePath: AppAssets.editIcon,
                    backgroundColor: AppColors.blue20,
                    iconSize: 8,
                  ),
              ),
              // ),
            ]
          ],
        ),
        const SizedBox(height: 10),
        if (widget.isDividerRequired)
          const BuildCustomDividerWidget(paddingLeft: 10, paddingRight: 10),
        if (widget.isDividerRequired) const SizedBox(height: 10),
      ],
    );
  }
}
