import 'package:bops_mobile/src/bloc/vehicle_bloc.dart';
import 'package:bops_mobile/src/models/update_vehicle_status_request_model.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_custom_dropdown_widget.dart';
import 'package:bops_mobile/src/widgets/build_radio_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_textfield.dart';
import 'package:bops_mobile/src/widgets/build_vehicle_details_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../bloc/sms_bloc.dart';
import '../../models/send_message_request_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/constants.dart';
import '../../widgets/build_elevated_button_widget.dart';
import '../../widgets/build_loading_widget.dart';
import '../../widgets/build_svg_icon_button.dart';
import '../../widgets/build_textfield_with_heading_widget.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({
    super.key,
    this.index,
    required this.ticket,
  });

  final int? index;
  final VehicleDetailsFirebaseResponseModel ticket;

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  TextEditingController parkedLocationController = TextEditingController();
  TextEditingController editingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isUpdatingVehicleStatusInSheet = false;
  bool isUpdatingVehicleStatusInFirebase = false;
  String? status;
  String selectedPaymentMethod = "";
  VehicleBloc vehicleBloc = VehicleBloc();
  String? statusText;
  Color? statusTextColor;
  Color? statusContainerColor;
  Color? statusContainerShadowColor;
  String? updateStatus;
  String isEdit = "";
  bool isEditing = false;
  bool isCheckOut = false;
  bool isMessageSending = false;
  SmsBloc smsBloc = SmsBloc();

  updateVehicleStatus(
    String? status,
    String? statusForFirebase,
    String? parkedLocation,
  ) async {
    setState(() {
      isUpdatingVehicleStatusInSheet = true;
      isUpdatingVehicleStatusInFirebase = true;
    });
    await vehicleBloc.updateVehicleStatus(
      updateVehicleStatusRequestModel: UpdateVehicleStatusRequestModel(
        sheetId: widget.ticket.sheetId,
        action: "updateSpreadsheet",
        sheetIndex: "${widget.ticket.tokenNumber! + 1}",
        vehicleStatus: status != null ? status : widget.ticket.vehicleStatus,
        checkedoutTime: status == "Checked Out"
            ? DateFormat('hh:mm:ss dd-MM-yyyy ').format(DateTime.now())
            : null,
        parkedLocation: isEdit == "parkedLocationEdit"
            ? editingController.text
            : parkedLocation,
        checkoutBy: ObjectFactory().appHive.getName(),
        parkedBy: ObjectFactory().appHive.getName(),
        paymentMethod: selectedPaymentMethod,
        keyHoldLocation:
            isEdit == 'keyLocationEdit' ? editingController.text : null,
      ),
    );
    await vehicleBloc.updateTicket(
        vehicleDetailsFirebaseResponseModel:
            VehicleDetailsFirebaseResponseModel(
      documentId: widget.ticket.documentId,
      checkOutBy: ObjectFactory().appHive.getName(),
      parkedBy: ObjectFactory().appHive.getName(),
      parkedLocation: isEdit == "parkedLocationEdit"
          ? editingController.text
          : parkedLocation,
      vehicleStatus: statusForFirebase != null
          ? statusForFirebase
          : widget.ticket.vehicleStatus,
      keyHoldLocation:
          isEdit == 'keyLocationEdit' ? editingController.text : null,
      paymentMethod: selectedPaymentMethod,
    ));
  }

  List<String> generateStatusList(String currentStatus) {
    switch (currentStatus) {
      case "checkedin":
        return ["Checked In", "Parked", "Requested", "Checked Out"];
      case "parked":
        return ["Parked", "Requested", "Checked Out"];
      case "requested":
        return ["Requested", "Checked Out"];
      case "checkedout":
        return ["Checked Out"];
      default:
        return [];
    }
  }

  setButtonTheme() {
    if (widget.ticket.vehicleStatus == "requested") {
      setState(() {
        statusText = "Requested";
        statusTextColor = AppColors.primaryColorRed;
        statusContainerColor = AppColors.primaryColorRed.withOpacity(0.2);
        statusContainerShadowColor = AppColors.primaryColorRed.withOpacity(0.1);
      });
    } else if (widget.ticket.vehicleStatus == "parked") {
      setState(() {
        statusText = "Parked";
        statusTextColor = AppColors.primaryColorYellow;
        statusContainerColor = AppColors.primaryColorYellow.withOpacity(0.2);
        statusContainerShadowColor =
            AppColors.primaryColorYellow.withOpacity(0.1);
      });
    } else if (widget.ticket.vehicleStatus == "checkedin") {
      setState(() {
        statusText = "Checked In";
        statusTextColor = AppColors.primaryColorBlue;
        statusContainerColor = AppColors.primaryColorBlue.withOpacity(0.2);
        statusContainerShadowColor =
            AppColors.primaryColorBlue.withOpacity(0.1);
      });
    } else if (widget.ticket.vehicleStatus == "checkedout") {
      setState(() {
        statusText = "Checked Out";
        statusTextColor = AppColors.primaryColorGreen;
        statusContainerColor = AppColors.primaryColorGreen.withOpacity(0.2);
        statusContainerShadowColor =
            AppColors.primaryColorGreen.withOpacity(0.1);
      });
    }
  }

  sendTextMessage({
    required VehicleDetailsFirebaseResponseModel vehicleDetailsModel,
  }) async {
    setState(() {
      isMessageSending = true;
    });
    print("SENDING MESSAGE");
    await smsBloc.sendMessage(
      sendMessageRequestModel: SendMessageRequestModel(
        templateId: "676408f8d6fc052cd10221e2",
        shortUrl: "1",
        realTimeResponse: "1",
        recipients: [
          Recipient(
            mobiles: "91${vehicleDetailsModel.mobileNumber!}",
            var1: vehicleDetailsModel.valetCarNumber.toString(),
            var2: vehicleDetailsModel.tokenNumber.toString(),
            var3: "${Constants.SMS_URL}/${vehicleDetailsModel.documentId}",
          ),
        ],
      ),
    );
  }

  smsSendListener() {
    smsBloc.sendMessageListener.listen((event) {
      print("SEND MESSAGE RESPONSE: ${event.message}");
      setState(() {
        isMessageSending = false;
      });
      AppToasts.showSuccessToastTop(
          context, "Notification sent to the customer!");
    }).onError((error) {
      setState(() {
        isMessageSending = false;
      });
      AppToasts.showErrorToastTop(
          context, "Error sending notification to the customer!");
    });
  }

  List<String> statusList = [];

  @override
  void initState() {
    super.initState();
    setButtonTheme();
    smsSendListener();
    statusList = generateStatusList(widget.ticket.vehicleStatus!);
    vehicleBloc.updateTicketListener.listen((event) {
      // print("UPDATE STATUS IN FIREBASE RESPONSE: $event");
      setState(() {
        isUpdatingVehicleStatusInFirebase = false;
      });
      AppToasts.showSuccessToastTop(
          context, "Ticket status updated successfully");
      if (!isUpdatingVehicleStatusInFirebase &&
          !isUpdatingVehicleStatusInSheet) {
        pop(context);
      }
    }, onError: (error) {
      setState(() {
        isUpdatingVehicleStatusInFirebase = false;
      });
      AppToasts.showErrorToastTop(
          context, "Ticket status updation failed, Please try again!");
    });
    vehicleBloc.updateVehicleStatusListener.listen((event) {
      setState(() {
        isUpdatingVehicleStatusInSheet = false;
      });
      if (!isUpdatingVehicleStatusInFirebase &&
          !isUpdatingVehicleStatusInSheet) {
        pop(context);
      }
    }, onError: (error) {
      setState(() {
        isUpdatingVehicleStatusInSheet = false;
      });
    });

    // if(isCheckOut){
    //   setState(() {
    //     scrollController.animateTo(900,  duration: Duration(seconds: 1),
    //       curve: Curves.easeInOut,);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          pop(context);
        },
        appBarTitle: "Details View",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      // floatingActionButton:
      //     ObjectFactory().appHive.getAccountType() == "manager" ||
      //             ObjectFactory().appHive.getAccountType() == "driver"
      //         ? FloatingActionButton.extended(
      //             backgroundColor: AppColors.primaryColorBlue,
      //             onPressed: () async {
      //               await sendTextMessage(vehicleDetailsModel: widget.ticket);
      //             },
      //             label: !isMessageSending
      //                 ? Row(
      //                     children: [
      //                       Text(
      //                         "Resend SMS",
      //                         style: Theme.of(context).textTheme.headlineLarge,
      //                       ),
      //                       BuildSvgIconButton(
      //                         assetImagePath: AppAssets.smsResendIcon,
      //                         iconHeight: 30,
      //                         color: AppColors.whiteTextColor,
      //                         onTap: () async {
      //                           await sendTextMessage(
      //                               vehicleDetailsModel: widget.ticket);
      //                         },
      //                       )
      //                     ],
      //                   )
      //                 : BuildLoadingWidget(
      //                     color: AppColors.whiteTextColor,
      //                   ),
      //           )
      //         : SizedBox(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                BuildVehicleDetailsCardWidget(
                  resendSMSTap: () async {
                    await sendTextMessage(vehicleDetailsModel: widget.ticket);
                  },
                  tokenNumber: widget.ticket.tokenNumber.toString(),
                  vehicleStatus: widget.ticket.vehicleStatus!,
                  checkOutDate: widget.ticket.checkOut != null
                      ? DateFormat('dd-MM-yyyy')
                          .format(widget.ticket.checkOut!.toDate())
                      : null,
                  checkInDate: DateFormat('dd-MM-yyyy')
                      .format(widget.ticket.checkInTime!.toDate()),
                  valetCarNumber:
                      widget.ticket.valetCarNumber.toString() ?? "----",
                  registrationNumber: widget.ticket.registrationNumber!,
                  modelName: widget.ticket.modelName!,
                  mobileNumber: widget.ticket.mobileNumber!,
                  checkinTime: DateFormat('h:mm a')
                      .format(widget.ticket.checkInTime!.toDate()),
                  checkoutTime: widget.ticket.checkOut != null
                      ? DateFormat('h:mm a')
                          .format(widget.ticket.checkOut!.toDate())
                      : null,
                  parkedLocation: widget.ticket.parkedLocation,
                  checkInBy: widget.ticket.checkInBy != null
                      ? widget.ticket.checkInBy!
                      : "----",
                  checkoutBy: widget.ticket.checkOutBy,
                  parkedBy: widget.ticket.parkedBy,
                  keyPlaced: widget.ticket.keyHoldLocation != null
                      ? widget.ticket.keyHoldLocation!
                      : "----",
                  keyLocationOnTap: () {
                    if (isEdit == "" || isEdit != "keyLocationEdit") {
                      setState(() {
                        isEdit = "keyLocationEdit";
                        editingController.text = widget.ticket.keyHoldLocation!;
                        isEditing = true;
                      });
                      print(isEdit);
                      print(isEditing);
                    } else if (isEdit == "keyLocationEdit") {
                      setState(() {
                        isEdit = "";
                        editingController.clear();
                        isEditing = false;
                      });
                      print(isEdit);
                    }
                  },
                  parkedLocationOnTap: () {
                    if (isEdit == "" || isEdit != "parkedLocationEdit") {
                      setState(() {
                        isEdit = "parkedLocationEdit";
                        editingController.text = widget.ticket.parkedLocation!;
                        isEditing = true;
                      });
                      print(isEdit);
                      print(isEditing);
                    } else if (isEdit == "parkedLocationEdit") {
                      setState(() {
                        isEdit = "";
                        editingController.clear();
                        isEditing = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                ObjectFactory().appHive.getAccountType() == "manager" ||
                        ObjectFactory().appHive.getAccountType() == "driver"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildCustomDropdownWidget(
                              dropDownItems: statusList,
                              onChanged: (event) {
                                setState(() {
                                  print(event);
                                  status = event;
                                  updateStatus =
                                      event.toLowerCase().replaceAll(" ", "");
                                  if (event == "Checked Out") {
                                    scrollController.jumpTo(50);
                                  }
                                  print(status);
                                  print(widget.ticket.vehicleStatus);
                                });
                                print(
                                    "UPDATE STATUS IN DROPDOWN: $updateStatus");
                                // print("PRESSED: $event");
                              }),
                          const SizedBox(height: 30),
                          if (status == "Parked" &&
                              updateStatus != widget.ticket.vehicleStatus) ...[
                            Text(
                              "Parked Location",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            BuildTextField(
                                textEditingController: parkedLocationController,
                                borderRadius: 5,
                                minLines: 3,
                                maxLines: 3,
                                showBorder: false,
                                showAlwaysErrorBorder: false,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the parked location.';
                                  }
                                  return null;
                                }),
                          ],
                          if (status == "Checked Out") ...[
                            Text(
                              "Payment Method",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: BuildRadioButtonWidget(
                                firstValue: "Upi",
                                secondValue: "Cash",
                                firstHeading: "UPI PAYMENT",
                                secondHeading: "CASH PAYMENT",
                                selectedOptionCallBack: (value) {
                                  selectedPaymentMethod = value;
                                },
                              ),
                            )
                          ],
                          if (isEdit == "keyLocationEdit") ...[
                            BuildTextFieldWithHeadingWidget(
                                heading: "Key Hold Location",
                                controller: editingController,
                                contactHintText: "A88",
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the location.';
                                  }
                                  return null;
                                },
                                showErrorBorderAlways: false),
                            const SizedBox(height: 20),
                          ],
                          if (isEdit == "parkedLocationEdit") ...[
                            BuildTextFieldWithHeadingWidget(
                                heading: "Parked Location",
                                controller: editingController,
                                contactHintText: "A88",
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the location.';
                                  }
                                  return null;
                                },
                                showErrorBorderAlways: false),
                            const SizedBox(height: 20),
                          ]
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Container(
                          width: screenWidth(context),
                          height: screenHeight(context, dividedBy: 21),
                          decoration: BoxDecoration(
                            color: statusContainerColor,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: statusContainerShadowColor!,
                                offset: const Offset(0, 8),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              statusText!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: statusTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          ObjectFactory().appHive.getAccountType() == "admin" ||
                  status == null && !isEditing && updateStatus == null ||
                  widget.ticket.vehicleStatus == "checkedout"
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(
                      right: 20, left: 20, top: 20, bottom: 20),
                  child: BuildElevatedButtonWidget(
                      width: screenWidth(context, dividedBy: 1.2),
                      height: screenHeight(context, dividedBy: 18),
                      txt: "SUBMIT",
                      child: isUpdatingVehicleStatusInSheet ||
                              isUpdatingVehicleStatusInFirebase
                          ? const BuildLoadingWidget(
                              color: AppColors.primaryColorWhite)
                          : null,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? true) {
                          updateVehicleStatus(
                            status,
                            updateStatus,
                            status == "Parked"
                                ? parkedLocationController.text
                                : null,
                          );
                        }
                      }),
                ),
    );
  }
}
