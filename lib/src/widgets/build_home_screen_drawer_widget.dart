import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/font_family.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_cached_network_image_widget.dart';
import 'package:bops_mobile/src/widgets/build_homescreen_drawer_item_widget.dart';
import 'package:bops_mobile/src/widgets/build_slider_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_button_with_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:happy_slider/happy_slider.dart';

class BuildHomeScreenDrawerWidget extends StatefulWidget {
  final Color backgroundColor;
  final Color headerColor;
  final Function backButtonTap;
  final Function firstButtonTap;
  final Function secondButtonTap;
  final Function thirdButtonTap;
  final Function fourthButtonTap;
  final Function fifthButtonTap;
  final Function sixthButtonTap;
  final Function seventhButtonTap;
  final Function eighthButtonTap;
  final Function sliderAction;

  const BuildHomeScreenDrawerWidget({
    super.key,
    required this.backgroundColor,
    required this.headerColor,
    required this.backButtonTap,
    required this.firstButtonTap,
    required this.secondButtonTap,
    required this.thirdButtonTap,
    required this.sliderAction,
    required this.fourthButtonTap,
    required this.fifthButtonTap,
    required this.sixthButtonTap,
    required this.seventhButtonTap,
    required this.eighthButtonTap,
  });

  @override
  State<BuildHomeScreenDrawerWidget> createState() =>
      _BuildHomeScreenDrawerWidgetState();
}

class _BuildHomeScreenDrawerWidgetState
    extends State<BuildHomeScreenDrawerWidget> {
  bool isAdmin = false;
  bool isCenterDelete = false;
  bool isSuspended = false;
  bool isManager = false;
  bool isDriver = false;

  getIsAdmin() {
    setState(() {
      isAdmin =
          ObjectFactory().appHive.getAccountType() == 'admin' ? true : false;
    });
  }

  getIsManager() {
    isManager =
        ObjectFactory().appHive.getAccountType() == "manager" ? true : false;
  }

  getIsSuspended() {
    setState(() {
      isSuspended = ObjectFactory().appHive.getIsSuspended();
    });
  }

  getIsCenterDeleted() {
    setState(() {
      isCenterDelete = ObjectFactory().appHive.getIsDeleted();
    });
    print(isCenterDelete);
  }

  getIsDriver() {
    isDriver =
        ObjectFactory().appHive.getAccountType() == "driver" ? true : false;
  }

  @override
  void initState() {
    getIsAdmin();
    getIsSuspended();
    getIsManager();
    getIsDriver();
    getIsCenterDeleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.lightModeScaffoldColor,
      child: SizedBox(
        height: screenHeight(context, dividedBy: 1.2),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.lightModeScaffoldColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColorBlue),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: BuildCachedNetworkImageWidget(
                            height: 60,
                            width: 60,
                            boxFit: BoxFit.cover,
                            boxShape: BoxShape.circle,
                            imageUrl: ObjectFactory().appHive.getProfilePic(),
                          ),
                        ),
                      ),
                      BuildSvgIconButtonWithBackgroundWidget(
                        assetImagePath: AppAssets.backButtonArrowIcon,
                        iconColor: AppColors.primaryColorBlue,
                        onTap: () {
                          widget.backButtonTap();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ObjectFactory().appHive.getName(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontFamily: FontFamily.poppins),
                  )
                ],
              ),
            ),
            Column(
              children: [
                isAdmin || isManager && !isCenterDelete && !isSuspended
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Reports",
                        assetImagePath: AppAssets.reportIcon,
                        onTap: () {
                          widget.firstButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                isAdmin
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Managers",
                        assetImagePath: AppAssets.managerIcon,
                        onTap: () {
                          widget.secondButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                isAdmin
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Centers",
                        assetImagePath: AppAssets.centerIcon,
                        onTap: () {
                          widget.thirdButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                isAdmin
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Drivers",
                        assetImagePath: AppAssets.driverIcon,
                        onTap: () {
                          widget.fourthButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                isAdmin
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Users",
                        assetImagePath: AppAssets.usersIcon,
                        onTap: () {
                          widget.fifthButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                isAdmin
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Requested Users",
                        assetImagePath: AppAssets.requestedUsersIcon,
                        onTap: () {
                          widget.sixthButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                !isSuspended && isAdmin
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Edit Profile",
                        assetImagePath: AppAssets.editProfileIcon,
                        onTap: () {
                          widget.seventhButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                isAdmin || isManager || isDriver
                    ? BuildHomescreenDrawerItemWidget(
                        buttonText: "Checked Out Vehicle",
                        assetImagePath: AppAssets.checkOutIcon,
                        onTap: () {
                          widget.eighthButtonTap();
                        },
                      )
                    : const SizedBox.shrink(),
                isAdmin
                    ? SizedBox(
                        height: 50,
                        // height: screenHeight(context, dividedBy:15),
                      )
                    : !isSuspended || !isCenterDelete
                        ? SizedBox(
                            height: screenHeight(context, dividedBy: 2),
                          )
                        : SizedBox(
                            height: screenHeight(context, dividedBy: 2),
                          ),
                Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 40),
                    child: BuildSliderButtonWidget(
                      onSlide: () {
                        debugPrint("slider working");
                        widget.sliderAction();
                      },
                      buttonWidth: screenWidth(context, dividedBy: 1),
                      buttonHeight: 65,
                      innerColor: AppColors.primaryColorBlue,
                      outerColor: AppColors.blue10,
                      textColor: AppColors.primaryColorBlue,
                      buttonText: "LogOut",
                      suffixIcon: Row(
                        children: [
                          BuildSvgIcon(
                            assetImagePath: AppAssets.logoutIcon,
                            iconHeight: 40,
                            color: AppColors.whiteTextColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                            color: AppColors.whiteTextColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    )

                    // HappySlider(
                    //   width: 300,
                    //   height: 55,
                    //   text: "LOG OUT",
                    //   buttonColor: AppColors.blue30,
                    //   buttonContentAlignment: MainAxisAlignment.center,
                    //   sliderWidth: 100,
                    //   borderColor: AppColors.greySmallSizedTextColor,
                    //   borderRadius: 50,
                    //   borderWidth: 1,
                    //   buttonIcon: BuildSvgIcon(
                    //     assetImagePath: AppAssets.logoutIcon,
                    //     iconHeight: 40,
                    //   ),
                    //   // sliderButton: Container(
                    //   //   color: Colors.red,
                    //   //   height: 50,
                    //   //   width: 100,
                    //   // ),
                    //   showDefaultIcon: false,
                    //
                    //   onSlideComplete: () {
                    //     widget.sliderAction();
                    //     debugPrint("slide complete");
                    //     //         return null;
                    //   },
                    // )

                    //   SliderButton(
                    //       alignLabel: Alignment.center,
                    //       backgroundColor: AppColors.dropdownCardColor,
                    //       buttonSize: 45,
                    //       height: 55,
                    //       action: () async {
                    //         widget.sliderAction();
                    //         return null;
                    //       },
                    //       label: Text(
                    //         "LOG OUT",
                    //         style: Theme.of(context).textTheme.labelMedium,
                    //       ),
                    //       icon: BuildSvgIcon(
                    //         assetImagePath: AppAssets.logoutIcon,
                    //         iconHeight: 45,
                    //       )),
                    ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
