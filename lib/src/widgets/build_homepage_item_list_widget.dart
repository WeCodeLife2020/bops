import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_custom_divider_widget.dart';
import 'package:flutter/material.dart';

class BuildHomepageItemListWidget extends StatefulWidget {
  final String tokenNumber;
  final String registrationNumber;
  final String modelName;
  final String phoneNumber;
  final String inTime;
  final String outTime;
  final String status;
  final Function onTap;
  final double? verticalPadding;
  final String requestedTime;

  const BuildHomepageItemListWidget({
    super.key,
    required this.tokenNumber,
    required this.registrationNumber,
    required this.modelName,
    required this.phoneNumber,
    required this.inTime,
    required this.outTime,
    required this.requestedTime,
    required this.status,
    required this.onTap,
    this.verticalPadding,
  });

  @override
  State<BuildHomepageItemListWidget> createState() =>
      _BuildHomepageItemListWidgetState();
}

class _BuildHomepageItemListWidgetState
    extends State<BuildHomepageItemListWidget> {
  String? statusText;
  Color? statusTextColor;
  Color? statusContainerColor;
  Color? statusContainerShadowColor;

  @override
  void initState() {
    // print(" this is ${widget.verticalPadding}");
    setButtonTheme();
    super.initState();
  }

  setButtonTheme() {
    if (widget.status == "requested") {
      setState(() {
        statusText = "Requested";
        statusTextColor = AppColors.primaryColorRed;
        statusContainerColor = AppColors.primaryColorRed.withOpacity(0.2);
        statusContainerShadowColor = AppColors.primaryColorRed.withOpacity(0.1);
      });
    } else if (widget.status == "parked") {
      setState(() {
        statusText = "Parked";
        statusTextColor = AppColors.primaryColorYellow;
        statusContainerColor = AppColors.primaryColorYellow.withOpacity(0.2);
        statusContainerShadowColor =
            AppColors.primaryColorYellow.withOpacity(0.1);
      });
    } else if (widget.status == "checkedin") {
      setState(() {
        statusText = "Checked In";
        statusTextColor = AppColors.primaryColorBlue;
        statusContainerColor = AppColors.primaryColorBlue.withOpacity(0.2);
        statusContainerShadowColor =
            AppColors.primaryColorBlue.withOpacity(0.1);
      });
    } else if (widget.status == "checkedout") {
      setState(() {
        statusText = "Checked Out";
        statusTextColor = AppColors.primaryColorGreen;
        statusContainerColor = AppColors.primaryColorGreen.withOpacity(0.2);
        statusContainerShadowColor =
            AppColors.primaryColorGreen.withOpacity(0.1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: widget.verticalPadding ?? 4),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.managersScreenListItemContainerColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                offset: const Offset(0, 8),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Token Number: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            Text(
                              widget.tokenNumber.toString().padLeft(4, '0'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          widget.registrationNumber,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColorBlue,
                                  ),
                        ),
                        Text(
                          widget.modelName,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12),
                        ),
                        Row(
                          children: [
                            Text(
                              "Mobile Number:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            Text(
                              widget.phoneNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth(context, dividedBy: 3.6),
                          decoration: BoxDecoration(
                            color: AppColors.dividerColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              widget.status == "requested"
                                  ? "REQ: ${widget.requestedTime}"
                                  : "IN: ${widget.inTime}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        widget.outTime == ""
                            ? const SizedBox.shrink()
                            : const SizedBox(height: 15),
                        widget.outTime == ""
                            ? const SizedBox.shrink()
                            : Container(
                                width: screenWidth(context, dividedBy: 3.8),
                                decoration: BoxDecoration(
                                  color: AppColors.dividerColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "OUT: ${widget.outTime}",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const BuildCustomDividerWidget(
                  paddingLeft: 20, paddingRight: 20, height: 1),
              Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 20, bottom: 20),
                child: Container(
                  width: screenWidth(context, dividedBy: 1.2),
                  height: screenHeight(context, dividedBy: 21),
                  decoration: BoxDecoration(
                    color: statusContainerColor,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: statusContainerShadowColor!,
                        offset: const Offset(0, 8),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      statusText!,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: statusTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
