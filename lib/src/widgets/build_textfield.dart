import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';
import '../utils/font_family.dart';

class BuildTextField extends StatelessWidget {
  final TextCapitalization? textCapitalization;
  final bool? showCounterText;
  final double? borderRadius;
  final String? labelText;
  final String? hintText;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? cursorColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? errorBorderColor;
  final Color? fillColor;
  final double? cursorHeight;
  final double? hintTextSize;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? label;
  final Function(String? value)? validation;
  final bool showAlwaysErrorBorder;
  final bool? filled;
  final bool? isDense;
  final bool showBorder;
  final bool? readOnly;
  final bool? obscureText;
  final bool? enable;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController textEditingController;
  final Function? onTap;
  final FocusNode? focusNode;
  final Widget? suffixWidget;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final double? textSize;

  const BuildTextField({
    Key? key,
    this.labelText,
    this.borderRadius,
    this.hintText,
    this.suffixWidget,
    this.focusNode,
    this.labelColor,
    this.hintColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.cursorHeight,
    this.maxLines,
    this.cursorColor,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.fillColor,
    this.validation,
    this.onTap,
    this.filled,
    this.keyboardType,
    this.label,
    required this.textEditingController,
    this.isDense,
    this.hintTextSize,
    this.minLines,
    required this.showBorder,
    this.inputFormatters,
    this.maxLength,
    this.obscureText,
    required this.showAlwaysErrorBorder,
    this.showCounterText,
    this.textCapitalization,
    this.textInputAction,
    this.enable,
    this.onFieldSubmitted,
    this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: AppColors.lightModeScaffoldColor,
          selectionHandleColor: AppColors.darkModeScaffoldColor,
        ),
      ),
      child: TextFormField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        textInputAction:textInputAction?? TextInputAction.done,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      
        enabled: enable,
        focusNode: focusNode,
        onTap: () {
          if (readOnly == true) {
            onTap?.call();
          }
        },
        obscureText: obscureText ?? false,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize:textSize?? 14,
              color: AppColors.textfieldTextColor,
              fontWeight: FontWeight.w400,
              fontFamily: FontFamily.gothamBook,
            ),
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        controller: textEditingController,
        validator: (value) => validation?.call(value),
        keyboardType: keyboardType,
        maxLines: maxLines,
        minLines: minLines,
        readOnly: readOnly ?? false,
        
        cursorHeight: cursorHeight,
        cursorColor: cursorColor ?? AppColors.darkModeScaffoldColor,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          counterStyle: const TextStyle(height: double.minPositive),
          counterText: showCounterText == true ? null : "",
          errorStyle: TextStyle(
            color: errorBorderColor ?? Colors.red,
            fontWeight: FontWeight.w300,
            fontFamily: FontFamily.poppins,
            fontSize: 11,
          ),
          floatingLabelStyle: TextStyle(
            color: labelColor ?? Colors.black,
            fontFamily: FontFamily.gothamBook,
            fontWeight: FontWeight.w400,
          ),
          isDense: isDense,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffix: suffixWidget,
          filled: filled ?? true,
          fillColor: fillColor ?? AppColors.textfieldColor,
          labelText: labelText,
          label: label,
          labelStyle: TextStyle(
            color: labelColor,
            fontFamily: FontFamily.poppins,
            fontWeight: FontWeight.w400,
          ),
         
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.displaySmall,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            borderSide: BorderSide(
              color: showAlwaysErrorBorder
                  ? (errorBorderColor ?? Colors.red)
                  : Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            borderSide: BorderSide(
              color: showAlwaysErrorBorder
                  ? (errorBorderColor ?? Colors.red)
                  : Colors.transparent,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            borderSide: BorderSide(
              color: showAlwaysErrorBorder
                  ? (errorBorderColor ?? Colors.red)
                  : Colors.transparent,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            borderSide: BorderSide(
              color: showAlwaysErrorBorder
                  ? (errorBorderColor ?? Colors.red)
                  : Colors.transparent,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
         onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
