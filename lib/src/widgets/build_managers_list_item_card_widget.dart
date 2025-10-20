import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_cached_network_image_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';

import 'build_svg_icon_with_background_widget.dart';

class BuildManagersListItemCardWidget extends StatefulWidget {
  final bool isSuspended;
  // final String imageUrl;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String buttonText;
  final Function buttonOnTap;
  final double? iconHeight;
  final Color buttonTextColor;
  final Color buttonBackgroundColor;
  final Function editButtonOnTap;

  const BuildManagersListItemCardWidget({
    super.key,
    required this.isSuspended,
    // required this.imageUrl,
    required this.name,
    required this.email,
    required this.address,
    required this.buttonText,
    required this.buttonOnTap,
    this.iconHeight = 15,
    required this.phoneNumber,
    required this.buttonTextColor,
    required this.buttonBackgroundColor,
    required this.editButtonOnTap,
  });

  @override
  State<BuildManagersListItemCardWidget> createState() =>
      _BuildManagersListItemCardWidgetState();
}

class _BuildManagersListItemCardWidgetState
    extends State<BuildManagersListItemCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: screenWidth(context),
        decoration: BoxDecoration(
            color: AppColors.managersScreenListItemContainerColor,
            borderRadius: BorderRadius.circular(10),
            border: widget.isSuspended
                ? Border.all(width: 0.5, color: AppColors.primaryColorRed)
                : Border.all(width: 0.5, color: Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BuildCachedNetworkImageWidget(
              //   height: screenWidth(context, dividedBy: 7),
              //   width: screenWidth(context, dividedBy: 7),
              //   boxFit: BoxFit.cover,
              //   boxShape: BoxShape.circle,
              //   imageUrl: widget.imageUrl,
              // ),
              // const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const SizedBox(width: 15),
                        Flexible(
                          child: Text(
                            widget.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        BuildSvgIcon(
                          assetImagePath: AppAssets.phoneIcon,
                          iconHeight: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.phoneNumber,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        BuildSvgIcon(
                          assetImagePath: AppAssets.mailIcon,
                          iconHeight: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.email,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        BuildSvgIcon(
                          assetImagePath: AppAssets.locationIcon,
                          iconHeight: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.address,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  !widget.isSuspended? InkWell(
                  onTap: (){
                    widget.editButtonOnTap();
                  },
                  child: BuildSvgIconWithBackgroundWidget(
                    assetImagePath: AppAssets.editIcon,
                    backgroundColor: AppColors.blue20,
                    iconSize: 10,
                  ),
                ):SizedBox(),
                const SizedBox(width: 10,height: 20,),
                BuildElevatedButtonWidget(
                  width: screenWidth(context, dividedBy: 3.3),
                  height: screenHeight(context, dividedBy: 22),
                  backgroundColor: widget.buttonBackgroundColor,
                  txt: widget.buttonText,
                  textStyle: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontSize: 10, color: widget.buttonTextColor),
                  child: null,
                  onTap: () {
                    widget.buttonOnTap();
                  },
                ),
              ],)

            ],
          ),
        ),
      ),
    );
  }
}
