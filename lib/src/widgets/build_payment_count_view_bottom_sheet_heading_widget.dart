import 'package:flutter/material.dart';

import '../utils/font_family.dart';
import 'build_custom_divider_widget.dart';

class BuildPaymentCountViewBottomSheetHeadingWidget extends StatelessWidget {
  const BuildPaymentCountViewBottomSheetHeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BuildCustomDividerWidget(
            height: 1, paddingLeft: 10, paddingRight: 10),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Payment Methods",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12, fontFamily: FontFamily.poppins),
              ),
              const Spacer(),
              Text(
                "Count",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12, fontFamily: FontFamily.poppins),
              ),
              // const Spacer(),
              // Text(
              //   "Actions",
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodySmall!
              //       .copyWith(fontSize: 12, fontFamily: FontFamily.poppins),
              // )
            ],
          ),
        ),
        const SizedBox(height: 10),
        const BuildCustomDividerWidget(
            height: 1, paddingLeft: 10, paddingRight: 10),
      ],
    );
  }
}
