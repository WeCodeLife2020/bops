import 'package:bops_mobile/src/widgets/build_textfield.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';
import '../utils/font_family.dart';
import 'package:flutter/material.dart';

class BuildTextFieldWithHeadingWidget extends StatefulWidget {
  final bool? showCounterText;
  final int? maxLength;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final String heading;
  final bool? enable;
  final bool? showBorder;
  final TextEditingController controller;
  final String contactHintText;
  final Widget? suffixWidget;
  final Widget? prefixIcon;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Function(String?) validation;
  final double? distance;
  final Color? hintColor;
  final Color? fillColor;
  final bool showErrorBorderAlways;
  final List<TextInputFormatter>? inputFormatters;
  final double? textSize;

  final Function(String)? onFieldSubmitted;

  const BuildTextFieldWithHeadingWidget({
    super.key,
    required this.heading,
    this.fillColor,
    this.hintColor,
    this.maxLines,
    required this.controller,
    required this.contactHintText,
    this.textInputType,
    this.suffixWidget,
    this.textInputAction,
    required this.validation,
    this.enable,
    this.showBorder,
    this.distance,
    required this.showErrorBorderAlways,
    this.textCapitalization,
    this.showCounterText,
    this.maxLength,
    this.prefixIcon,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.textSize,
  });

  @override
  State<BuildTextFieldWithHeadingWidget> createState() =>
      _BuildTextFieldWithHeadingWidgetState();
}

class _BuildTextFieldWithHeadingWidgetState
    extends State<BuildTextFieldWithHeadingWidget> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " ${widget.heading}",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: widget.distance ?? 10),
        BuildTextField(
          textInputAction: widget.textInputAction,
          showCounterText: widget.showCounterText,
           onFieldSubmitted: widget.onFieldSubmitted,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          showAlwaysErrorBorder: widget.showErrorBorderAlways,
          enable: widget.enable,
          maxLines: widget.maxLines ?? 1,
          filled: true,
          validation: widget.validation,
          suffixWidget: widget.suffixWidget,
          prefixIcon: widget.prefixIcon,
          keyboardType: widget.textInputType,
          textEditingController: widget.controller,
          showBorder: widget.showBorder ?? false,
          hintText: widget.contactHintText,
          textSize: widget.textSize,
          
        ),
      ],
    );
  }
}
