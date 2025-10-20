import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/utils.dart';

class BuildPaymentCountViewBottomSheetItemWidget extends StatefulWidget {
  const BuildPaymentCountViewBottomSheetItemWidget({super.key,required this.isEvenItem,required this.paymentMethod,required this.count});
final bool isEvenItem;
final String paymentMethod;
final int count;
  @override
  State<BuildPaymentCountViewBottomSheetItemWidget> createState() => _BuildPaymentCountViewBottomSheetItemWidgetState();
}

class _BuildPaymentCountViewBottomSheetItemWidgetState extends State<BuildPaymentCountViewBottomSheetItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      decoration: BoxDecoration(
        color: widget.isEvenItem
            ? AppColors.blue40
            : AppColors.lightModeScaffoldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12,top: 12,bottom: 12,right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(widget.paymentMethod),
            // const Spacer(),
            Text(widget.count.toString()),

          ],
        ),
      ),
    );
  }
}
