import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BuildLoadingWidget extends StatefulWidget {
  final Color? color;
  const BuildLoadingWidget({
    super.key,
    this.color,
  });

  @override
  State<BuildLoadingWidget> createState() => _BuildLoadingWidgetState();
}

class _BuildLoadingWidgetState extends State<BuildLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          color: widget.color ?? AppColors.primaryColorBlue,
        ),
      ),
    );
  }
}
