import 'package:bops_mobile/src/bloc/center_bloc.dart';
import 'package:bops_mobile/src/bloc/driver_bloc.dart';
import 'package:bops_mobile/src/models/driver_response_model.dart';
import 'package:flutter/material.dart';

import '../../models/center_response_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_toasts.dart';
import '../../utils/utils.dart';
import '../../widgets/build_curved_appbar_widget.dart';
import '../../widgets/build_custom_dropdown_widget.dart';
import '../../widgets/build_elevated_button_widget.dart';
import '../../widgets/build_loading_widget.dart';
import '../../widgets/build_lottie_loading_widget.dart';
import '../../widgets/build_svg_icon.dart';
import '../../widgets/build_textfield_with_heading_widget.dart';

class AddDriversScreen extends StatefulWidget {
  const AddDriversScreen({super.key, this.isEdit = false, this.driverDetails});
  final bool isEdit;
  final DriverResponseModel? driverDetails;
  @override
  State<AddDriversScreen> createState() => _AddDriversScreenState();
}

class _AddDriversScreenState extends State<AddDriversScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<String> centersList = [""];
  late List<CenterResponseModel> centers;
  CenterBloc centerBloc = CenterBloc();
  DriverBloc driverBloc = DriverBloc();
  bool isFetchingCenters = false;
  bool isAddingDriver = false;
  bool isUpdateDriverDetails=false;
  String? selectedCenter;
  String? selectedCenterId;
  Map<String, String> centerIdMap = {};
  final formKey = GlobalKey<FormState>();

  fetchCenters() {
    setState(() {
      isFetchingCenters = true;
    });
    centerBloc.getCenters();
  }

  addDriver() {
    setState(() {
      isAddingDriver = true;
    });
    driverBloc.addDriver(
        driverResponseModel: DriverResponseModel(
      isSuspended: false,
      driverAddress: addressController.text.trim(),
      driverCenter: selectedCenter,
      driverCenterId: selectedCenterId,
      driverEmail: emailController.text.trim(),
      driverName: nameController.text.trim(),
      driverPhoneNumber: phoneController.text.trim(),
    ));
  }

  updateDriverDetails() {
    driverBloc.updateDriverDetails(
      driverResponseModel: DriverResponseModel(
        driverId: widget.driverDetails!.driverId,
        driverPhoneNumber: phoneController.text,
        driverName: nameController.text,
        driverEmail: emailController.text,
        driverAddress: addressController.text,
        driverCenter: selectedCenter,
        driverCenterId: selectedCenterId,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCenters();
    if(widget.driverDetails!=null){
      nameController.text=widget.driverDetails!.driverName!;
      emailController.text=widget.driverDetails!.driverEmail!;
    }
    if (widget.isEdit) {
      setState(() {
        nameController.text = widget.driverDetails!.driverName!;
        phoneController.text = widget.driverDetails!.driverPhoneNumber!;
        emailController.text = widget.driverDetails!.driverEmail!;
        addressController.text = widget.driverDetails!.driverAddress!;
        selectedCenterId=widget.driverDetails!.driverCenterId!;
        selectedCenter=widget.driverDetails!.driverCenter!;
      });
     driverBloc.updateDriverDetailsListener.listen((event){
       setState(() {
         isUpdateDriverDetails = false;
       });
       AppToasts.showSuccessToastTop(context, "Driver details update successfully!");
       Navigator.pop(context, true);
     },onError: (error){
       setState(() {
         isUpdateDriverDetails = false;
       });
       AppToasts.showErrorToastTop(context, "Driver details update failed!");
     }
     );

    }
    centerBloc.getCentersListener.listen((event) {
      setState(() {
        centers = event;
        centersList = centers.map((center) => center.centerName!).toList();
        centerIdMap = {
          for (var center in centers) center.centerName!: center.centerId!,
        };

        selectedCenter = widget.isEdit?widget.driverDetails?.driverCenter:centersList[0];
        selectedCenterId = centerIdMap[widget.isEdit?widget.driverDetails?.driverCenter:centersList[0]];
        print(selectedCenter);
        isFetchingCenters = false;
      });
    });

    driverBloc.addDriverListener.listen((event) {
      setState(() {
        isAddingDriver = false;
      });
      AppToasts.showSuccessToastTop(context, "Driver added successfully!");
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          pop(context);
        },
        appBarTitle: "Add Drivers",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: isFetchingCenters
          ? const BuildLottieLoadingWidget()
          : Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildCustomDropdownWidget(
                        dropDownItems: centersList,
                        initialItem: selectedCenter,
                        onChanged: (event) {
                          setState(() {
                            selectedCenter = event;
                            if (event != null) {
                              // Retrieve the centerId using the selected centerName
                              selectedCenterId = centerIdMap[
                                  event]; // Store the corresponding centerId
                              selectedCenter = event;
                              print("SELECTED CENTER NAME: $event");
                              print("SELECTED CENTER ID: $selectedCenterId");
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Enter the details",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      BuildTextFieldWithHeadingWidget(
                        heading: "Name",
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        contactHintText: "John",
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name!';
                          }
                        },
                        showErrorBorderAlways: false,
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      BuildTextFieldWithHeadingWidget(
                        heading: "Phone",
                        controller: phoneController,
                        textInputAction: TextInputAction.next,
                        contactHintText: "XXXX-XXX-XXX",
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number!';
                          }
                        },
                        showErrorBorderAlways: false,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: BuildSvgIcon(
                            assetImagePath: AppAssets.indiaCountryCodeIcon,
                            iconHeight: 25,
                          ),
                        ),
                        textInputType: TextInputType.phone,
                        maxLength: 10,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      BuildTextFieldWithHeadingWidget(
                        heading: "Email",
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.none,
                        contactHintText: "example@gmail.com",
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email!';
                          }
                        },
                        showErrorBorderAlways: false,
                        textInputType: TextInputType.emailAddress,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      BuildTextFieldWithHeadingWidget(
                        heading: "Address",
                        controller: addressController,
                        contactHintText: "Address",
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the address!';
                          }
                        },
                        showErrorBorderAlways: false,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 60,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: isFetchingCenters
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(
                  right: 20, left: 20, top: 20, bottom: 40),
              child: BuildElevatedButtonWidget(
                width: screenWidth(context, dividedBy: 1.2),
                height: screenHeight(context, dividedBy: 18),
                txt: "ADD",
                child: isAddingDriver
                    ? const BuildLoadingWidget(
                        color: AppColors.primaryColorWhite)
                    : null,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (!isAddingDriver||!isUpdateDriverDetails) {
                     widget.isEdit?await updateDriverDetails(): await addDriver();
                    }
                  }
                },
              ),
            ),
    );
  }
}
