import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';

class ReportDownloadSuccessScreen extends StatefulWidget {
  const ReportDownloadSuccessScreen({super.key});

  @override
  State<ReportDownloadSuccessScreen> createState() =>
      _ReportDownloadSuccessScreenState();
}

class _ReportDownloadSuccessScreenState
    extends State<ReportDownloadSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: BuildSvgIcon(
                assetImagePath: AppAssets.reportDownloadedIcon,
                iconHeight: 250,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Your report",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 17, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            Text(
              "Downloaded Successfully",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColorBlue),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
        child: BuildElevatedButtonWidget(
          width: screenWidth(context, dividedBy: 1.2),
          height: screenHeight(context, dividedBy: 18),
          txt: "CONTINUE",
          child: null,
          onTap: () {
            print("CONTINUE PRESSED");
            pop(context);
          },
        ),
      ),
    );
  }
}
