import 'dart:async';

import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_button.dart';
import 'package:bops_mobile/src/widgets/build_vehicle_details_screen_item_row.dart';
import 'package:flutter/material.dart';

class BuildVehicleDetailsCardWidget extends StatefulWidget {
  final String tokenNumber;
  final String registrationNumber;
  final String modelName;
  final String mobileNumber;
  final String checkinTime;
  final String? checkoutTime;
  final String? parkedLocation;
  final String checkInBy;
  final String? parkedBy;
  final String? checkoutBy;
  final String keyPlaced;
  final Function keyLocationOnTap;
  final Function parkedLocationOnTap;
  final String valetCarNumber;
  final String vehicleStatus;
  final String checkInDate;
  final Function resendSMSTap;
  final String? checkOutDate;

  const BuildVehicleDetailsCardWidget({
    super.key,
    required this.tokenNumber,
    required this.registrationNumber,
    required this.modelName,
    required this.mobileNumber,
    required this.checkinTime,
    this.checkoutTime,
    this.parkedLocation,
    required this.checkInBy,
    this.parkedBy,
    this.checkoutBy,
    required this.keyPlaced,
    required this.keyLocationOnTap,
    required this.parkedLocationOnTap,
    required this.valetCarNumber,
    required this.vehicleStatus,
    required this.checkInDate,
    required this.resendSMSTap,
    this.checkOutDate,
  });

  @override
  State<BuildVehicleDetailsCardWidget> createState() =>
      _BuildVehicleDetailsCardWidgetState();
}

class _BuildVehicleDetailsCardWidgetState
    extends State<BuildVehicleDetailsCardWidget> {
  Timer? _timer;
  bool isResendActive = true;
  int waitingTime = 30;

  startTimer() async {
    setState(() {
      isResendActive = false;
    });
    _timer = Timer?.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (waitingTime == 0) {
          timer.cancel();
          setState(() {
            isResendActive = true;
            waitingTime = 30;
          });
        } else {
          setState(() {
            waitingTime--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      decoration: BoxDecoration(
        color: AppColors.managersScreenListItemContainerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            offset: const Offset(0, 8),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Vehicle Details",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  widget.vehicleStatus != "checkedout"
                      ? TextButton.icon(
                          onPressed: () {
                            if (isResendActive) {
                              startTimer();
                              widget.resendSMSTap();
                            }
                          },
                          label: SizedBox(
                            width: 85,
                            child: Text(
                              isResendActive
                                  ? "Resend SMS"
                                  : waitingTime.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.primaryColorBlue),
                            ),
                          ),
                          icon: BuildSvgIconButton(
                            assetImagePath: AppAssets.smsResendIcon,
                            iconHeight: 30,
                            color: AppColors.primaryColorBlue,
                            onTap: () async {
                              if (isResendActive) {
                                startTimer();
                                widget.resendSMSTap();
                              }
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            // const SizedBox(height: 10),
            // Text(
            //   "Effortlessly find and reserve parking spots with our convenient car parking app",
            //   style: Theme.of(context).textTheme.labelSmall,
            // ),
            const SizedBox(height: 20),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Token Number",
              secondText: widget.tokenNumber.toString().padLeft(4, '0'),
              // .toString().padLeft(4, '0'),
              isDividerRequired: true,
              secondFontSize: 20,
              secondTextColor: AppColors.blue70,
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Valet card Number",
              secondText: widget.valetCarNumber.toString().padLeft(4, '0'),
              isDividerRequired: true,
              secondFontSize: 20,
              secondTextColor: AppColors.blue70,
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Date",
              secondText: widget.checkInDate,
              isDividerRequired: true,
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Registration Number",
              secondText: widget.registrationNumber,
              isDividerRequired: true,
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Model Name",
              secondText: widget.modelName,
              isDividerRequired: true,
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Mobile Number",
              secondText: widget.mobileNumber,
              isDividerRequired: true,
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Key Placed On",
              secondText: widget.keyPlaced,
              isDividerRequired: true,
              isEditable: widget.vehicleStatus != "checkedout" ? true : false,
              onTap: () {
                widget.keyLocationOnTap();
              },
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "CheckIn by",
              secondText: widget.checkInBy,
              isDividerRequired: true,
            ),
            BuildVehicleDetailsScreenItemRow(
              firstText: "Checkin Time",
              secondText: widget.checkinTime,
              isDividerRequired: true,
            ),
            if (widget.parkedBy != null) ...[
              BuildVehicleDetailsScreenItemRow(
                firstText: "Parked by",
                secondText: widget.parkedBy ?? "----",
                isDividerRequired: true,
              ),
            ],
            if (widget.parkedLocation != null) ...[
              BuildVehicleDetailsScreenItemRow(
                firstText: "Parked Location",
                secondText: widget.parkedLocation ?? "----",
                isDividerRequired: true,
                isEditable: widget.vehicleStatus != "checkedout" ? true : false,
                onTap: () {
                  widget.parkedLocationOnTap();
                },
              ),
            ],

            if (widget.checkoutTime != null) ...[
              BuildVehicleDetailsScreenItemRow(
                firstText: "Checkout by",
                secondText: widget.checkoutBy ?? "----",
                isDividerRequired: true,
              ),
              BuildVehicleDetailsScreenItemRow(
                  isDividerRequired: true,
                  firstText: "Checkout Date",
                  secondText: widget.checkOutDate ?? ""),
              BuildVehicleDetailsScreenItemRow(
                firstText: "Checkout Time",
                secondText: widget.checkoutTime ?? "----",
                isDividerRequired: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
