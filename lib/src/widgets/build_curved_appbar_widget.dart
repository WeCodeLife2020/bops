import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_button.dart';
import 'package:flutter/material.dart';

class BuildCurvedAppbarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final double appBarHeight;
  final double borderRadius;
  final double iconHeight;
  final VoidCallback backButtonOnTap;
  final bool centerTitle;
  final String appBarTitle;
  final TextStyle? appBarTextStyle;
  final List<Widget>? actions; // Optional parameter

  const BuildCurvedAppbarWidget({
    super.key,
    required this.backButtonOnTap,
    required this.appBarTitle,
    this.appBarHeight = 56.0,
    this.borderRadius = 35.0,
    this.iconHeight = 28.0,
    this.centerTitle = true,
    this.appBarTextStyle,
    this.actions, // Include actions in the constructor
  });

  @override
  State<BuildCurvedAppbarWidget> createState() =>
      _BuildCurvedAppbarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

class _BuildCurvedAppbarWidgetState extends State<BuildCurvedAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.appBarTopColor,
            AppColors.appBarBottomColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(widget.borderRadius),
        ),
      ),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: SizedBox(
          height: 20,
          width: 20,
          child: BuildSvgIconButton(
            assetImagePath: AppAssets.backButtonArrowIcon,
            iconHeight: widget.iconHeight,
            onTap: widget.backButtonOnTap,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: widget.centerTitle,
        toolbarHeight: widget.appBarHeight,
        title: Text(
          widget.appBarTitle,
          style: widget.appBarTextStyle ??
              Theme.of(context).textTheme.headlineLarge,
        ),
        actions: widget.actions ?? [], // Use the optional actions
      ),
    );
  }
}
