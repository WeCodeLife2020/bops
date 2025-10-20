import 'package:bops_mobile/src/bloc/center_bloc.dart';
import 'package:bops_mobile/src/bloc/managers_bloc.dart';
import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_custom_dropdown_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:bops_mobile/src/widgets/build_textfield_with_heading_widget.dart';
import 'package:flutter/material.dart';

class AddManagersScreen extends StatefulWidget {
  const AddManagersScreen({super.key,this.isEdit = false,this.managerDetails});
  final bool isEdit;
  final ManagerResponseModel? managerDetails;
  @override
  State<AddManagersScreen> createState() => _AddManagersScreenState();
}

class _AddManagersScreenState extends State<AddManagersScreen> {
  ManagersBloc managersBloc = ManagersBloc();
  CenterBloc centerBloc = CenterBloc();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late List<CenterResponseModel> centers;
  final formKey = GlobalKey<FormState>();
  bool isAddingManager = false;
  bool isFetchingCenters = false;
  bool isUpdateManagerDetails=false;
  String? selectedCenter;
  String? selectedCenterId;
  List<String> centersList = [""];
  Map<String, String> centerIdMap = {};

  fetchCenters() {
    setState(() {
      isFetchingCenters = true;
    });
    centerBloc.getCenters();
  }
  addManager(){
    setState(() {
      isAddingManager = true;
    });
    managersBloc.addManager(
        managerResponseModel: ManagerResponseModel(
          isSuspended: false,
          managerCenter: selectedCenter,
          managerCenterId: selectedCenterId,
          managerEmail: emailController.text,
          managerName: nameController.text,
          managerPhoneNumber: phoneController.text,
          managerAddress: addressController.text,
        ));

  }
updateManagerDetails(){
    setState(() {
      isUpdateManagerDetails=true;
    });
    managersBloc.updateManagerDetails(managerResponseModel: ManagerResponseModel(
      managerAddress: addressController.text,
      managerName: nameController.text,
      managerPhoneNumber: phoneController.text,
      managerEmail: emailController.text,
      managerCenter: selectedCenter,
      managerCenterId: selectedCenterId,
      managerId: widget.managerDetails!.managerId!,
    ));
}
  @override
  void initState() {
    fetchCenters();
    if(widget.managerDetails!=null){
      nameController.text=widget.managerDetails!.managerName!;
      emailController.text=widget.managerDetails!.managerEmail!;
    }
    if(widget.isEdit){
      setState(() {
        nameController.text=widget.managerDetails!.managerName!;
        phoneController.text=widget.managerDetails!.managerPhoneNumber!;
        emailController.text=widget.managerDetails!.managerEmail!;
        addressController.text=widget.managerDetails!.managerAddress!;
        selectedCenter=widget.managerDetails!.managerCenter;
        selectedCenterId=widget.managerDetails!.managerCenterId!;
      });
      managersBloc.updateManagerDetailsListener.listen((event){
        setState(() {
          isUpdateManagerDetails = false;
        });
        AppToasts.showSuccessToastTop(context, "Manager details update successfully!");
        Navigator.pop(context, true);
      },onError: (error){
        setState(() {
          isUpdateManagerDetails=false;
          AppToasts.showErrorToastTop(context, "Manager details update failed!");
        });
      });
    }
    centerBloc.getCentersListener.listen((event) {
      setState(() {
        centers = event;
        centersList = centers.map((center) => center.centerName!).toList();
        centerIdMap = {
          for (var center in centers) center.centerName!: center.centerId!,
        };

        selectedCenter = widget.isEdit?widget.managerDetails?.managerCenter: centersList[0];
        selectedCenterId = centerIdMap[widget.isEdit?widget.managerDetails?.managerCenter:centersList[0]];
        isFetchingCenters = false;
      });
    });
    managersBloc.addManagerListener.listen((event) {
      // print("ADD MANAGER RESPONSE: $event");
      setState(() {
        isAddingManager = false;
      });
      AppToasts.showSuccessToastTop(context, "Manager added successfully!");
      Navigator.pop(context, true);
    }).onError((error) {
      setState(() {
        isAddingManager = false;
      });
      AppToasts.showErrorToastTop(
          context, "A manager with the same credentials already exists!");
      //A manager with this email already exists.
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          pop(context);
        },
        appBarTitle: "Add Managers",
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
                        textInputAction: TextInputAction.next,
                        heading: "Name",
                        controller: nameController,
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
                        textInputAction: TextInputAction.next,
                        heading: "Phone",
                        controller: phoneController,
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
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
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
                child: isAddingManager||isUpdateManagerDetails
                    ? const BuildLoadingWidget(
                        color: AppColors.primaryColorWhite)
                    : null,
                onTap: ()async {
                  if (formKey.currentState!.validate()) {
                    if (!isAddingManager||!isUpdateManagerDetails) {
                       widget.isEdit?await updateManagerDetails(): await addManager();
                    }
                  }
                },
              ),
            ),
    );
  }
}
