import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildHomescreenBottomSheetWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function onValetCarNumberSearch;
  final Function onRegistrationNumberSearch;

  const BuildHomescreenBottomSheetWidget({
    super.key,
    required this.searchController,
    required this.onValetCarNumberSearch,
    required this.onRegistrationNumberSearch,
  });

  @override
  State<BuildHomescreenBottomSheetWidget> createState() =>
      _BuildHomescreenBottomSheetWidgetState();
}

class _BuildHomescreenBottomSheetWidgetState
    extends State<BuildHomescreenBottomSheetWidget> {
  String _selectedOption = 'valetCarNumber';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.only(bottom: keyboardHeight),
      constraints: BoxConstraints(
        maxHeight: 300 + keyboardHeight, // Adjust based on keyboard height
      ),
      color: AppColors.lightModeScaffoldColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Select Search Method',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<String>(
                            activeColor: AppColors.primaryColorBlue,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return states.contains(WidgetState.selected)
                                    ? AppColors
                                        .primaryColorBlue // Selected color
                                    : Colors.grey; // Unselected color
                              },
                            ),
                            value: 'valetCarNumber',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value!;
                                widget.searchController.clear();
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOption = 'valetCarNumber';
                                widget.searchController.clear();
                              });
                            },
                            child: Text(
                              'Valet Card Number',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<String>(
                            value: 'registration',
                            activeColor: AppColors.primaryColorBlue,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return states.contains(WidgetState.selected)
                                    ? AppColors
                                        .primaryColorBlue // Selected color
                                    : Colors.grey; // Unselected color
                              },
                            ),
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value!;
                                widget.searchController.clear();
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOption = 'registration';
                                widget.searchController.clear();
                              });
                            },
                            child: Text(
                              'Registration Number',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BuildTextField(
                    textEditingController: widget.searchController,
                    showBorder: true,
                    textCapitalization: TextCapitalization.characters,
                    showAlwaysErrorBorder: false,
                    hintText: _selectedOption == 'valetCarNumber'
                        ? 'Valet Card Number'
                        : 'Registration Number',
                    maxLines: 1,
                    validation: (value) {
                      if (value!.isEmpty) {
                        return _selectedOption == "valetCarNumber"
                            ? "Please enter a valid valet card number"
                            : "Please enter a valid registration number";
                      } else if (value.contains(' ') ||
                          !RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                        return "Only uppercase letters and numbers are allowed!";
                      }

                      return null; // Return null if validation passes
                    },
                    keyboardType: _selectedOption == "valetCarNumber"
                        ? TextInputType.number
                        : TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                    ],
                  ),
                  const SizedBox(height: 25),
                  BuildElevatedButtonWidget(
                    width: screenWidth(context, dividedBy: 2),
                    height: screenHeight(context, dividedBy: 18),
                    txt: "SEARCH",
                    child: null,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        _selectedOption == "valetCarNumber"
                            ? widget.onValetCarNumberSearch()
                            : widget.onRegistrationNumberSearch();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
