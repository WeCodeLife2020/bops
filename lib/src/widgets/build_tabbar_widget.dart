import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BuildTabbarWidget extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Function onFirstTap;
  final Function onSecondTap;
  final int activePageIndex;
  final String fistButtonText;
  final String secondButtonText;

  const BuildTabbarWidget({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.onFirstTap,
    required this.onSecondTap,
    required this.activePageIndex,
    required this.fistButtonText,
    required this.secondButtonText,
  });

  @override
  State<BuildTabbarWidget> createState() => _BuildTabbarWidgetState();
}

class _BuildTabbarWidgetState extends State<BuildTabbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0XFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              onTap: () => widget.onFirstTap(), // Fixed here
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (widget.activePageIndex == 0)
                    ? BoxDecoration(
                        color: AppColors.blue20,
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                      )
                    : null,
                child: Text(
                  widget.fistButtonText,
                  style: (widget.activePageIndex == 0)
                      ? const TextStyle(color: AppColors.primaryColorBlue)
                      : const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              onTap: () => widget.onSecondTap(), // Fixed here
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (widget.activePageIndex == 1)
                    ? BoxDecoration(
                        color: AppColors.blue20,
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                      )
                    : null,
                child: Text(
                  widget.secondButtonText,
                  style: (widget.activePageIndex == 1)
                      ? const TextStyle(color: AppColors.primaryColorBlue)
                      : const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
