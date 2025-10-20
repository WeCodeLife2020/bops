import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class BuildRadioButtonWidget extends StatefulWidget {
  BuildRadioButtonWidget(
      {super.key,
     required this.selectedOptionCallBack,
      required this.firstValue,
      required this.secondValue,
      required this.firstHeading,
      required this.secondHeading});
  final Function(String value) selectedOptionCallBack;
  final String firstValue;
  final String secondValue;
  final String firstHeading;
  final String secondHeading;
  @override
  State<BuildRadioButtonWidget> createState() => _BuildRadioButtonWidgetState();
}

class _BuildRadioButtonWidgetState extends State<BuildRadioButtonWidget> {
  String? selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
     selectedValue=widget.firstValue;
    });
    widget.selectedOptionCallBack(widget.firstValue);
  }
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(

          children: [
            Radio<String>(
              activeColor: AppColors.primaryColorBlue,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.primaryColorBlue // Selected color
                      : Colors.grey; // Unselected color
                },
              ),
              value: widget.firstValue,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
                widget.selectedOptionCallBack(value!);
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {

                  selectedValue = widget.firstValue;
                });
                widget.selectedOptionCallBack(widget.firstValue);
              },
              child: Text(
                widget.firstHeading,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
        // const Spacer(),
        SizedBox(width: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio<String>(
              value: widget.secondValue,
              activeColor: AppColors.primaryColorBlue,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.primaryColorBlue // Selected color
                      : Colors.grey; // Unselected color
                },
              ),
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
                widget.selectedOptionCallBack(value!);
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedValue = widget.secondValue;
                });
                widget.selectedOptionCallBack(widget.secondValue);
              },
              child: Text(
                widget.secondHeading,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
