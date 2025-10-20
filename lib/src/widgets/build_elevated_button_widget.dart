import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BuildElevatedButtonWidget extends StatefulWidget {
  final double? elevation;
  final TextStyle? textStyle;
  final String? txt;
  final Function? onTap;
  final Color? backgroundColor;
  final double? borderRadiusBottomLeft;
  final double? borderRadiusBottomRight;
  final double? borderRadiusTopLeft;
  final double? borderRadiusTopRight;
  final double? width;
  final double? height;
  final double? borderThickness;
  final Color? borderColor;
  final Widget? child;

  const BuildElevatedButtonWidget({
    super.key,
    this.elevation,
    this.textStyle,
    this.txt,
    this.onTap,
    this.backgroundColor,
    this.borderRadiusBottomLeft,
    this.borderRadiusBottomRight,
    this.borderRadiusTopLeft,
    this.borderRadiusTopRight,
    this.width,
    this.height,
    this.borderThickness,
    this.borderColor,
    this.child,
  });

  @override
  State<BuildElevatedButtonWidget> createState() =>
      _BuildElevatedButtonWidgetState();
}

class _BuildElevatedButtonWidgetState extends State<BuildElevatedButtonWidget> {
  bool onClicked = false; // State to track if the button is pressed

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            onClicked = true;
          });

          // Trigger the tap callback if provided
          if (widget.onTap != null) {
            widget.onTap!();
          }

          // Revert animation after a short delay
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              onClicked = false;
            });
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: widget.elevation ?? 0,
          backgroundColor: widget.backgroundColor ?? AppColors.primaryColorBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.borderRadiusBottomLeft ?? 25),
              bottomRight:
                  Radius.circular(widget.borderRadiusBottomRight ?? 25),
              topLeft: Radius.circular(widget.borderRadiusTopLeft ?? 25),
              topRight: Radius.circular(widget.borderRadiusTopRight ?? 25),
            ),
            side: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderThickness ?? 0,
            ),
          ),
        ),
        child: Center(
          child: widget.child ??
              Text(
                widget.txt!,
                style:
                    widget.textStyle ?? Theme.of(context).textTheme.labelMedium,
              ),
        ),
      ).animate(target: onClicked ? 1 : 0).scaleXY(
            begin: 1,
            end: 0.94,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 100),
          ),
    );
  }
}
