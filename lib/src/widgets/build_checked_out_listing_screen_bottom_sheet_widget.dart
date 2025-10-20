import 'package:bops_mobile/src/widgets/build_payment_count_view_bottom_sheet_heading_widget.dart';
import 'package:bops_mobile/src/widgets/build_payment_count_view_bottom_sheet_item_widget.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class BuildCheckedOutListingScreenBottomSheetWidget extends StatefulWidget {
  const BuildCheckedOutListingScreenBottomSheetWidget({super.key,required this.upiCount,required this.cashCount});
final int upiCount;
final int cashCount;
  @override
  State<BuildCheckedOutListingScreenBottomSheetWidget> createState() =>
      _BuildCheckedOutListingScreenBottomSheetWidgetState();
}

class _BuildCheckedOutListingScreenBottomSheetWidgetState
    extends State<BuildCheckedOutListingScreenBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.only(bottom: keyboardHeight),
      decoration: BoxDecoration(
        color: AppColors.lightModeScaffoldColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: 260 + keyboardHeight, // Adjust based on keyboard height
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 50),
              BuildPaymentCountViewBottomSheetHeadingWidget(),
              // const BuildCenterListingScreenHeadingWidget(),
              const SizedBox(height: 15),
              BuildPaymentCountViewBottomSheetItemWidget(
                  isEvenItem: false, paymentMethod: "UPI Payment", count: widget.upiCount),
              BuildPaymentCountViewBottomSheetItemWidget(
                  isEvenItem: true, paymentMethod: "Cash Payment", count: widget.cashCount),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
