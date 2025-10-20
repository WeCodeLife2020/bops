import 'package:bops_mobile/src/bloc/sheet_bloc.dart';
import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_textfield_with_heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../bloc/center_bloc.dart';
import '../../bloc/vehicle_bloc.dart';
import '../../widgets/build_loading_widget.dart';

class AddCenterScreen extends StatefulWidget {
  const AddCenterScreen(
      {super.key, this.isEdit = false, this.centerName, this.centerId});
  final bool isEdit;
  final String? centerName;
  final String? centerId;
  @override
  State<AddCenterScreen> createState() => _AddCenterScreenState();
}

class _AddCenterScreenState extends State<AddCenterScreen> {
  TextEditingController centerNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? sheetId;
  CenterBloc centerBloc = CenterBloc();
  VehicleBloc vehicleBloc = VehicleBloc();
  SheetBloc sheetBloc = SheetBloc();
  editCenterName() {
    if (formKey.currentState!.validate() && !isLoading) {
      setState(() {
        isLoading = true;
      });
      centerBloc.updateCenterName(
          centerId: widget.centerId,
          centerName: centerNameController.text.trim());
    }
  }

  createSheet(String spreadsheetName) {
    if (formKey.currentState!.validate() && !isLoading) {
      setState(() {
        isLoading = true;
      });
      vehicleBloc.createSheet(spreadsheetName: spreadsheetName);
    }
  }

  addSheetDetailsToFirebase(
    String centerId,
  ) {
    sheetBloc.addSheetDetailsToFirebase(
        sheetDetailsFirebaseResponseModel: SheetDetailsFirebaseResponseModel(
            centerId: centerId,
            centerName: centerNameController.text,
            sheetId: sheetId!,
            sheetName:
                "${centerNameController.text} ${DateFormat.yMMMd().format(DateTime.now())}"));
  }

  addCenter(
    String? sheetId,
  ) {
    centerBloc.addCenter(
      centerResponseModel: CenterResponseModel(
        centerName: centerNameController.text.trim(),
        sheetId: sheetId,
        tokenNumber: 0,
        isDelete: false,
        valetCarNumber: 0,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      centerNameController.text = widget.centerName!;
      centerBloc.updateCenterNameListener.listen((event) {
        setState(() {
          isLoading = false;
        });
        AppToasts.showSuccessToastTop(
            context, "Center name updated successfully!");
        // pushAndReplacement(context, CentersListingScreen());
        Navigator.pop(context, false);
      }, onError: (error) {
        setState(() {
          isLoading = false;
        });
        AppToasts.showErrorToastTop(context, error);
      });
    } else {
      vehicleBloc.createSheetListener.listen((event) {
        ObjectFactory().appHive.putSheetId(sheetId: event.data.sheetId);

        ObjectFactory().appHive.putSheetCreatedDate(
            createdDate: DateFormat.yMMMd().format(DateTime.now()));
        sheetId = event.data.sheetId;
        addCenter(event.data.sheetId);
        centerBloc.addCenterListener.listen((event) {
          setState(() {
            isLoading = false;
          });
          addSheetDetailsToFirebase(event);
          AppToasts.showSuccessToastTop(context, "Center added successfully!");
          // pushAndReplacement(context, CentersListingScreen());
          Navigator.pop(context, true);
        }, onError: (error) {
          AppToasts.showErrorToastTop(context, error);
        });
      }, onError: (error) {
        setState(() {
          isLoading = false;
        });
        AppToasts.showErrorToastTop(context, error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          Navigator.pop(context, false);
        },
        appBarTitle: "Add Center",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Enter the center name",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              BuildTextFieldWithHeadingWidget(
                heading: "Center",
                controller: centerNameController,
                contactHintText: "Center Name",
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the center name!';
                  }
                },
                showErrorBorderAlways: false,
                textInputType: TextInputType.text,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
        child: BuildElevatedButtonWidget(
          width: screenWidth(context, dividedBy: 1.2),
          height: screenHeight(context, dividedBy: 18),
          txt: "ADD",
          child: isLoading
              ? const BuildLoadingWidget(
                  color: AppColors.primaryColorWhite,
                )
              : null,
          onTap: () {
            widget.isEdit
                ? editCenterName()
                : createSheet(
                    "${centerNameController.text} ${DateFormat.yMMMd().format(DateTime.now())}");
          },
        ),
      ),
    );
  }
}
