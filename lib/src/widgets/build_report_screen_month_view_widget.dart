import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/utils.dart';

class BuildReportScreenMonthViewWidget extends StatefulWidget {
  const BuildReportScreenMonthViewWidget({super.key, required this.monthName});
  final String monthName;
  @override
  State<BuildReportScreenMonthViewWidget> createState() =>
      _BuildReportScreenMonthViewWidgetState();
}

class _BuildReportScreenMonthViewWidgetState
    extends State<BuildReportScreenMonthViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.dividerColor,
        // : AppColors.lightModeScaffoldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          widget.monthName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
