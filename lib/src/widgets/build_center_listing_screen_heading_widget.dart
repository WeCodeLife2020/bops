import 'package:bops_mobile/src/utils/font_family.dart';
import 'package:bops_mobile/src/widgets/build_custom_divider_widget.dart';
import 'package:flutter/material.dart';

class BuildCenterListingScreenHeadingWidget extends StatefulWidget {
  const BuildCenterListingScreenHeadingWidget({super.key});

  @override
  State<BuildCenterListingScreenHeadingWidget> createState() =>
      _BuildCenterListingScreenHeadingWidgetState();
}

class _BuildCenterListingScreenHeadingWidgetState
    extends State<BuildCenterListingScreenHeadingWidget> {
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
                "Sl No",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12, fontFamily: FontFamily.poppins),
              ),
              const Spacer(),
              Text(
                "Center Name",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12, fontFamily: FontFamily.poppins),
              ),
              const Spacer(),
              Text(
                "Actions",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12, fontFamily: FontFamily.poppins),
              )
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
