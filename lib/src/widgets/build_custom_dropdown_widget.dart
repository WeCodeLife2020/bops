import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BuildCustomDropdownWidget extends StatefulWidget {
  final List<String> dropDownItems;
  final Function onChanged;
  final double? upArrowSize;
  final double? downArrowSize;
  final TextStyle? listItemStyle;
  final TextStyle? headerItemStyle;
  final TextStyle? hintStyle;
  final String? initialItem;

  const BuildCustomDropdownWidget({
    super.key,
    required this.dropDownItems,
    required this.onChanged,
    this.upArrowSize,
    this.downArrowSize,
    this.listItemStyle,
    this.headerItemStyle,
    this.hintStyle,
    this.initialItem,
  });

  @override
  State<BuildCustomDropdownWidget> createState() =>
      _BuildCustomDropdownWidgetState();
}

class _BuildCustomDropdownWidgetState extends State<BuildCustomDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      decoration: CustomDropdownDecoration(
        closedFillColor: AppColors.dropdownCardColor,
        expandedFillColor: AppColors.dropdownCardColor,
        closedSuffixIcon: Icon(
          Icons.keyboard_arrow_down,
          size: widget.downArrowSize ?? 30,
          color: AppColors.darkModeScaffoldColor,
        ),
        expandedSuffixIcon: Icon(
          Icons.keyboard_arrow_up,
          size: widget.upArrowSize ?? 30,
          color: AppColors.darkModeScaffoldColor,
        ),
        closedBorderRadius: BorderRadius.circular(30),
        expandedBorderRadius: BorderRadius.circular(30),
        listItemStyle:
            widget.listItemStyle ?? Theme.of(context).textTheme.labelSmall,
        hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.labelSmall,
        headerStyle:
            widget.headerItemStyle ?? Theme.of(context).textTheme.labelSmall,
        listItemDecoration: ListItemDecoration(
          selectedColor: AppColors.iconsColorGrey.withOpacity(0.5),
          highlightColor: AppColors.iconsColorGrey.withOpacity(0.5),
        ),
      ),
      canCloseOutsideBounds: true,

      // hideSelectedFieldWhenExpanded: true,
      closedHeaderPadding: const EdgeInsets.all(12),
      items: widget.dropDownItems,
      initialItem: widget.initialItem?? widget.dropDownItems[0],
      excludeSelected: true,
      onChanged: (value) {
        print('SELECTED: $value');
        widget.onChanged(value);
      },
    );
  }
}
