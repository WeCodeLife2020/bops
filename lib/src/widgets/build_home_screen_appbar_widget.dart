import 'dart:ui';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_cached_network_image_widget.dart';
import 'package:bops_mobile/src/widgets/build_custom_dropdown_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_button.dart';
import 'package:flutter/material.dart';

class BuildHomeScreenAppbarWidget extends StatelessWidget {
  final String imageUrl;
  final bool isSuspended;
  final double iconHeight;
  final double appBarHeight;
  final List<String> centersList;
  final Function drawerIconTap;
  final Function notificationIconTap;
  final Function dropDownSelectionAction;
  final Function refreshButtonTapAction;

  const BuildHomeScreenAppbarWidget({
    super.key,
    required this.imageUrl,
    required this.isSuspended,
    required this.iconHeight,
    required this.centersList,
    required this.drawerIconTap,
    required this.notificationIconTap,
    required this.dropDownSelectionAction,
    required this.appBarHeight,
    required this.refreshButtonTapAction,
  });

  @override
  Widget build(BuildContext context) {
    bool isExpanded = appBarHeight == screenHeight(context, dividedBy: 5);

    return Container(
      height: appBarHeight,
      width: screenWidth(context),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.appBarTopColor,
            AppColors.appBarBottomColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isExpanded ? const SizedBox(height: 10) : const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildSvgIconButton(
                  assetImagePath: AppAssets.drawerIcon,
                  iconHeight: 30,
                  onTap: () {
                    drawerIconTap();
                  },
                ),
                ObjectFactory().appHive.getAccountType() == 'manager' ||
                        ObjectFactory().appHive.getAccountType() == 'driver'
                    ? BuildSvgIconButton(
                        assetImagePath: AppAssets.notificationUnreadIcon,
                        iconHeight: 40,
                        onTap: () {
                          notificationIconTap();
                        },
                      )
                    : SizedBox(),
              ],
            ),
            const SizedBox(height: 10),
            isSuspended
                ? const SizedBox.shrink()
                : AnimatedOpacity(
                    opacity: isExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: isExpanded
                        ? ObjectFactory().appHive.getAccountType() == "user"
                            ? SizedBox(
                                height: screenHeight(context, dividedBy: 24))
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.dropdownCardColor,
                                          borderRadius:
                                              BorderRadius.circular(35)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, top: 2, bottom: 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BuildCachedNetworkImageWidget(
                                              height: 42,
                                              width: 42,
                                              boxFit: BoxFit.cover,
                                              boxShape: BoxShape.circle,
                                              imageUrl: imageUrl,
                                            ),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              height: 45,
                                              width: screenWidth(context,
                                                  dividedBy: 2.1),
                                              child: ObjectFactory()
                                                              .appHive
                                                              .getAccountType() ==
                                                          "manager" ||
                                                      ObjectFactory()
                                                              .appHive
                                                              .getAccountType() ==
                                                          "driver"
                                                  ? Center(
                                                      child: Text(
                                                          ObjectFactory()
                                                              .appHive
                                                              .getCenterName()),
                                                    )
                                                  : BuildCustomDropdownWidget(
                                                      downArrowSize: 20,
                                                      upArrowSize: 20,
                                                      headerItemStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelSmall!
                                                              .copyWith(
                                                                  fontSize: 12),
                                                      hintStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelSmall!
                                                              .copyWith(
                                                                  fontSize: 12),
                                                      listItemStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelSmall!
                                                              .copyWith(
                                                                  fontSize: 12),
                                                      dropDownItems:
                                                          centersList,
                                                      onChanged: (event) async {
                                                        await dropDownSelectionAction(
                                                            event);
                                                      },
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    BuildSvgIconButton(
                                        assetImagePath:
                                            AppAssets.refreshPageIcon,
                                        iconHeight: 40,
                                        onTap: () {
                                          refreshButtonTapAction();
                                        }),
                                    // const SizedBox(width: 8),
                                    // BuildSvgIconButton(
                                    //     assetImagePath:
                                    //         AppAssets.refreshPageIcon,
                                    //     iconHeight: 35,
                                    //     onTap: () {
                                    //       refreshButtonTapAction();
                                    //     }),
                                  ],
                                ),
                              )
                        : const SizedBox.shrink(), // Hide when not expanded
                  ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'count',
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //       // Spacer(),
            //       Text(
            //         '23',
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
