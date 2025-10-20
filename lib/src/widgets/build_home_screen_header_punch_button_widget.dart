import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/utils.dart';
import 'build_svg_icon_with_background_widget.dart';

class BuildHomeScreenHeaderPunchButtonWidget extends StatefulWidget {
  const BuildHomeScreenHeaderPunchButtonWidget({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.selectedVehicleStatus,
    this.buttonColor,
  });

  final Function(String value) onTap;
  final String buttonText;
  final String selectedVehicleStatus;
  final Color? buttonColor;

  @override
  State<BuildHomeScreenHeaderPunchButtonWidget> createState() =>
      _BuildHomeScreenHeaderPunchButtonWidgetState();
}

class _BuildHomeScreenHeaderPunchButtonWidgetState
    extends State<BuildHomeScreenHeaderPunchButtonWidget> {
  changeToStatus(String status) {
    switch (status) {
      case "checkedin":
        return "Checked In";
      case "checkedout":
        return "Checked Out";
      case "parked":
        return "Parked";
      case "requested":
        return "Requested";
      case "Checked In":
        return "checkedin";
      case "Checked Out":
        return "checkedout";
      case "Parked":
        return "parked";
      case "Requested":
        return "requested";
      case "count":
        return "vehicle count";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 1,
        top: 15,
        left: 9,
      ),
      child: GestureDetector(
        onTap: () {
          widget.onTap(changeToStatus(widget.buttonText));
        },
        child: Container(
          // width: screenWidth(context,dividedBy: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: widget.selectedVehicleStatus == 'count'
                ? AppColors.punchButtonColor
                : changeToStatus(widget.selectedVehicleStatus) ==
                        widget.buttonText
                    ? AppColors.punchButtonColor
                    : AppColors.dropdownCardColor,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                widget.buttonText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.selectedVehicleStatus == 'count'
                        ? AppColors.whiteTextColor
                        : changeToStatus(widget.selectedVehicleStatus) ==
                                widget.buttonText
                            ? AppColors.whiteTextColor
                            : null),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
