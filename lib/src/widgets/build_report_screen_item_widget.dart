import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/app_assets.dart';
import 'build_report_screen_month_view_widget.dart';
import 'build_svg_icon.dart';

class BuildReportScreenItemWidget extends StatefulWidget {
  const BuildReportScreenItemWidget(
      {super.key,
      required this.sheetDetailsList,
      this.monthName,
      this.isWithMonthHeading = false,
        required this.onPress
      });
  final SheetDetailsFirebaseResponseModel sheetDetailsList;
  final String? monthName;
  final bool isWithMonthHeading;
  final Function onPress;
  @override
  State<BuildReportScreenItemWidget> createState() =>
      _BuildReportScreenItemWidgetState();
}

class _BuildReportScreenItemWidgetState
    extends State<BuildReportScreenItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          if (widget.isWithMonthHeading) ...[
            BuildReportScreenMonthViewWidget(monthName: widget.monthName!),
            SizedBox(height: 30,),
          ] else ...[
            SizedBox()
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Text(
                  widget.sheetDetailsList.sheetName,overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              // Spacer(),
              GestureDetector(
                  onTap: () {
                    // widget.editButtonTap();
                    widget.onPress();
                  },
                  child: Text(
                    'Download',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.primaryColorBlue),
                    overflow: TextOverflow.ellipsis,
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }
}
