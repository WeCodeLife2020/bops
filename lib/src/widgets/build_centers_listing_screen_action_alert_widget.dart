import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_circular_progress_indicator_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:flutter/material.dart';

class BuildCentersListingScreenActionAlertWidget extends StatefulWidget {
  final bool isLoading;
  final String firstButtonText;
  final String secondButtonText;
  final Function onFirstButtonTap;
  final Function onSecondButtonTap;
  const BuildCentersListingScreenActionAlertWidget({
    super.key,
    required this.isLoading,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.onFirstButtonTap,
    required this.onSecondButtonTap,
  });

  @override
  State<BuildCentersListingScreenActionAlertWidget> createState() =>
      _BuildCentersListingScreenActionAlertWidgetState();
}

class _BuildCentersListingScreenActionAlertWidgetState
    extends State<BuildCentersListingScreenActionAlertWidget> {
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
              const SizedBox(height: 20),
              Text(
                  textAlign: TextAlign.center,
                  "Are you sure you want to delete this center?",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 14)),
              const SizedBox(height: 20),
              widget.isLoading
                  ? const BuildCircularProgressIndicatorWidget()
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
                          backgroundColor:
                              AppColors.primaryColorRed.withOpacity(0.3),
                          width: screenWidth(context, dividedBy: 3.2),
                          height: screenHeight(context, dividedBy: 20),
                          txt: widget.secondButtonText,
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: AppColors.primaryColorRed,
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
