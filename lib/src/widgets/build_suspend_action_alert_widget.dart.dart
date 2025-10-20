import 'package:bops_mobile/src/widgets/build_cached_network_image_widget.dart';
import 'package:bops_mobile/src/widgets/build_circular_progress_indicator_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';

import '../utils/app_colors.dart';
import '../utils/utils.dart';
import '../widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';

import '../utils/font_family.dart';

class BuildSuspendActionAlertWidget extends StatefulWidget {
  final bool isSuspend;
  // final String imageUrl;
  final String titleName;
  final String firstButtonText;
  final String secondButtonText;
  final Function onFirstButtonTap;
  final Function onSecondButtonTap;
  final bool isLoading;

  const BuildSuspendActionAlertWidget({
    super.key,
    // required this.imageUrl,
    required this.onFirstButtonTap,
    required this.onSecondButtonTap,
    required this.titleName,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.isLoading,
    required this.isSuspend,
  });

  @override
  State<BuildSuspendActionAlertWidget> createState() =>
      _BuildSuspendActionAlertWidgetState();
}

class _BuildSuspendActionAlertWidgetState
    extends State<BuildSuspendActionAlertWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.lightModeScaffoldColor,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: screenWidth(context, dividedBy: 1.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
       
              Text(
                  textAlign: TextAlign.center,
                  widget.isSuspend
                      ? "Are you sure you want to suspend ${widget.titleName}"
                      : "Are you sure you want to unsuspend ${widget.titleName}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 14)),
              const SizedBox(height: 20),
              widget.isLoading
                  ? const BuildCircularProgressIndicatorWidget(
                      color: AppColors.primaryColorBlue,
                    )
                  : Row(
                      children: [
                        BuildElevatedButtonWidget(
                          backgroundColor: AppColors.lightModeScaffoldColor,
                          width: screenWidth(context, dividedBy: 3.2),
                          height: screenHeight(context, dividedBy: 20),
                          borderColor: AppColors.darkModeScaffoldColor,
                          txt: widget.firstButtonText,
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                          onTap: () {
                            widget.onFirstButtonTap();
                          },
                        ),
                        const Spacer(),
                        BuildElevatedButtonWidget(
                          backgroundColor: widget.isSuspend
                              ? AppColors.primaryColorRed.withOpacity(0.3)
                              : AppColors.primaryColorGreen.withOpacity(0.3),
                          width: screenWidth(context, dividedBy: 3.2),
                          height: screenHeight(context, dividedBy: 20),
                          txt: widget.secondButtonText,
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: widget.isSuspend
                                      ? AppColors.primaryColorRed
                                      : AppColors.primaryColorGreen,
                                  fontWeight: FontWeight.w600),
                          onTap: () {
                            widget.onSecondButtonTap();
                          },
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
