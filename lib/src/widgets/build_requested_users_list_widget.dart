import 'package:bops_mobile/src/models/driver_response_model.dart';
import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/screens/driver_screens/add_drivers_screen.dart';
import 'package:bops_mobile/src/screens/manager_screens/add_managers_screen.dart';
import 'package:bops_mobile/src/widgets/build_popup_menu_button_widget.dart';
import 'package:flutter/material.dart';

import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';
import 'build_svg_icon.dart';

class BuildRequestedUsersListWidget extends StatefulWidget {
  final String name;
  final String email;
  final String accountType;
  final String popupFirstTitle;
  final String popupSecondTitle;
  final Function(int value) popupOnPress;
  const BuildRequestedUsersListWidget({
    super.key,
    required this.name,
    required this.email,
    required this.accountType,
    required this.popupFirstTitle,
    required this.popupSecondTitle,
    required this.popupOnPress,
  });

  @override
  State<BuildRequestedUsersListWidget> createState() =>
      _BuildRequestedUsersListWidgetState();
}

class _BuildRequestedUsersListWidgetState
    extends State<BuildRequestedUsersListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: screenWidth(context),
        decoration: BoxDecoration(
          color: AppColors.managersScreenListItemContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Text(
                            widget.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    // (widget.phoneNumber.isEmpty || widget.phoneNumber == "")
                    //     ? const SizedBox.shrink()
                    //     : Row(
                    //   children: [
                    //     BuildSvgIcon(
                    //       assetImagePath: AppAssets.phoneIcon,
                    //       iconHeight: 15,
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Flexible(
                    //       child: Text(
                    //         widget.phoneNumber,
                    //         style: Theme.of(context).textTheme.bodySmall,
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // (widget.phoneNumber.isEmpty || widget.phoneNumber == "")
                    //     ? const SizedBox.shrink()
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 15),
                    // (widget.address.isEmpty || widget.address == "")
                    //     ? const SizedBox.shrink()
                    //     : Row(
                    //   children: [
                    //     BuildSvgIcon(
                    //       assetImagePath: AppAssets.locationIcon,
                    //       iconHeight: 15,
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Flexible(
                    //       child: Text(
                    //         widget.address,
                    //         style: Theme.of(context).textTheme.bodySmall,
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              // const SizedBox(width: 8),

              BuildPopupMenuButtonWidget(
                title: widget.popupFirstTitle,
                onPress: (value) {
                  widget.popupOnPress(value);
                  // value == 1
                  //     ? push(
                  //         context,
                  //         AddManagersScreen(
                  //           managerDetails: ManagerResponseModel(
                  //             managerEmail: widget.email,
                  //             managerName: widget.name,
                  //           ),
                  //         ))
                  //     : push(
                  //         context,
                  //         AddDriversScreen(
                  //           driverDetails: DriverResponseModel(
                  //               driverEmail: widget.email,
                  //               driverName: widget.name),
                  //         ));
                },
                secondTitle: widget.popupSecondTitle,
              ),
              // Text(widget.accountType),
              // ],)
            ],
          ),
        ),
      ),
    );
  }
}
