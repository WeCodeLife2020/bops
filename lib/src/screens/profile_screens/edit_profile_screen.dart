import 'package:bops_mobile/src/bloc/profile_bloc.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:bops_mobile/src/widgets/build_textfield_with_heading_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ProfileBloc profileBloc = ProfileBloc();
  bool isUpdatingProfile = false;
  bool isLoadingProfileData = true;

  prefetchData() async {
    await profileBloc.getPhoneAndAddress(
        userId: ObjectFactory().appHive.getUserId());
  }

  @override
  void initState() {
    prefetchData();
    profileBloc.getPhoneAndAddressListener.listen((event) {
      print("GET PROFILE DATA RESPONSE: $event");
      setState(() {
        isLoadingProfileData = false;
        phoneController.text = event["userPhoneNumber"];
        addressController.text = event["userAddress"];
      });
    }, onError: (error) {
      setState(() {
        isLoadingProfileData = false;
      });
      AppToasts.showErrorToastTop(
          context, "Fetching profile data failed, Please try again");
    });
    profileBloc.updatePhoneAndAddressListener.listen((event) {
      print("UPDATE PROFILE DATA RESPONSE: $event");
      setState(() {
        isUpdatingProfile = false;
      });
      AppToasts.showSuccessToastTop(context, "Profile edited successfully!");
      pop(context);
    }, onError: (error) {
      setState(() {
        isUpdatingProfile = false;
      });
      AppToasts.showErrorToastTop(
          context, "Profile editing failed, Please try again");
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
        appBarTitle: "Edit Profile",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: (isLoadingProfileData)
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
                      const SizedBox(height: 20),
                      Text(
                        "Enter the details",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      BuildTextFieldWithHeadingWidget(
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
      bottomNavigationBar: (isLoadingProfileData)
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(
                  right: 20, left: 20, top: 20, bottom: 40),
              child: BuildElevatedButtonWidget(
                width: screenWidth(context, dividedBy: 1.2),
                height: screenHeight(context, dividedBy: 18),
                txt: "SUBMIT",
                child: isUpdatingProfile
                    ? const BuildLoadingWidget(
                        color: Colors.white,
                      )
                    : null,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    if (!isUpdatingProfile) {
                      setState(() {
                        isUpdatingProfile = true;
                      });
                      profileBloc.updatePhoneAndAddress(
                        userId: ObjectFactory().appHive.getUserId(),
                        address: addressController.text,
                        phoneNumber: phoneController.text,
                      );
                    }
                  }
                },
              ),
            ),
    );
  }
}
