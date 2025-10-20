import 'dart:async';

import 'package:bops_mobile/src/bloc/center_bloc.dart';
import 'package:bops_mobile/src/bloc/sheet_bloc.dart';
import 'package:bops_mobile/src/bloc/sms_bloc.dart';
import 'package:bops_mobile/src/models/add_vehicle_request_model.dart';
import 'package:bops_mobile/src/models/send_message_request_model.dart';
import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/screens/scanning_screens/scan_vehicle_registration_number_screen.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/constants.dart';
import 'package:bops_mobile/src/utils/font_family.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:bops_mobile/src/widgets/build_textfield_with_heading_widget.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../bloc/vehicle_bloc.dart';
import '../../widgets/build_loading_widget.dart';

class AddVehicleDetailsScreen extends StatefulWidget {
  const AddVehicleDetailsScreen({super.key});

  @override
  State<AddVehicleDetailsScreen> createState() =>
      _AddVehicleDetailsScreenState();
}

class _AddVehicleDetailsScreenState extends State<AddVehicleDetailsScreen> {
  TextEditingController registrationController = TextEditingController();
  TextEditingController modelNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController keyHoldLocationController = TextEditingController();
  SmsBloc smsBloc = SmsBloc();
  VehicleBloc vehicleBloc = VehicleBloc();
  CenterBloc centerBloc = CenterBloc();
  SheetBloc sheetBloc = SheetBloc();
  String selectedPaymentMethod = "";
  String? sheetId;
  String? documentId;
  String? url;
  bool isMessageSending = false;
  List<CameraDescription> cameras = [];
  VehicleDetailsFirebaseResponseModel vehicleDetailsFirebaseResponseModel =
      VehicleDetailsFirebaseResponseModel();
  final formKey = GlobalKey<FormState>();
  bool isSheetCreatedDateCheck = false;
  bool isUploadingDataToSheet = false;
  bool isUploadingDataToFirebase = false;
  bool isUpdatingTokenNumber = false;
  bool isFetchingTokenNumber = false;
  bool isPrefetchingCarDetails = false;
  int valetCarNumber = 0;
  int tokenNumber = 0;
  late StreamSubscription<DocumentSnapshot> _subscription;

  // int tokenNumber = 0;

  // fetchTokenNumber() {
  //   setState(() {
  //     isFetchingTokenNumber = true;
  //   });
  //   centerBloc.getTokenNumber(centerId: ObjectFactory().appHive.getCenterId());
  // }

  initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }

  /// get sheet id for if not have sheet id in app hive
  getSheetId() {
    centerBloc.getSheetId(centerId: ObjectFactory().appHive.getCenterId());
  }

  ///after create sheet
  updateCenterSheetId(String sheetId) {
    centerBloc.updateCenterSheetId(
        centerId: ObjectFactory().appHive.getCenterId(), sheetId: sheetId);
  }

  /// add sheet data to firebase
  addSheetDataToFirebase(String sheetId, String sheetName) async {
    await sheetBloc.addSheetDetailsToFirebase(
        sheetDetailsFirebaseResponseModel: SheetDetailsFirebaseResponseModel(
      centerId: ObjectFactory().appHive.getCenterId(),
      centerName: ObjectFactory().appHive.getCenterName(),
      sheetId: sheetId,
      sheetName: sheetName,
    ));
  }

  /// create sheet if not have sheet for today
  createSheet() {
    vehicleBloc.createSheet(
        spreadsheetName:
            "${ObjectFactory().appHive.getCenterName()} ${DateFormat.yMMMd().format(DateTime.now())}");
  }

  ///get sheet create date for check have today vehicle sheet
  getSheetCreatedDateFromFirebase() {
    centerBloc.getSheetCreatedDate(
        centerId: ObjectFactory().appHive.getCenterId());
  }

  ///check create data and today date are same other wise create new sheet
  checkSheetCreatedDate() async {
    setState(() {
      isSheetCreatedDateCheck = true;
    });
    final createdDate = ObjectFactory().appHive.getSheetCreatedDate();
    print("ObjectFactory().appHive.getSheetCreatedDate()");
    print(ObjectFactory().appHive.getSheetCreatedDate());
    print(DateFormat.yMMMd().format(DateTime.now()));

    ///check manager is  using app first

    print(ObjectFactory().appHive.getSheetId());
    print(createdDate);
    if (createdDate != " ") {
      /// check sheet created date and today date is same
      if (createdDate == DateFormat.yMMMd().format(DateTime.now())) {
        print("sheet already created");
        setState(() {
          isSheetCreatedDateCheck = false;
        });
        sheetId = ObjectFactory().appHive.getSheetId();
      } else {
        print("sheet not created");

        await getSheetCreatedDateFromFirebase();
      }
    } else {
      print("sheet not created");

      await getSheetCreatedDateFromFirebase();
    }
    // print(ObjectFactory().appHive.getSheetId());
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

  addVehicle() async {
    setState(() {
      isUploadingDataToSheet = true;
      isUploadingDataToFirebase = true;
      isUpdatingTokenNumber = true;
    });

    await vehicleBloc.addVehicleDetailsToFirebase(
      // tokenNumber: tokenNumber,
      // valetCarNumber: valetCarNumber,
      vehicleDetailsFirebaseResponseModel: VehicleDetailsFirebaseResponseModel(
        centerId: ObjectFactory().appHive.getCenterId(),
        centerName: ObjectFactory().appHive.getCenterName(),
        managerId: ObjectFactory().appHive.getManagerId(),
        managerUserId: ObjectFactory().appHive.getUserId(),
        managerName: ObjectFactory().appHive.getName(),
        vehicleStatus: "checkedin",
        mobileNumber: phoneNumberController.text,
        modelName: modelNameController.text,
        registrationNumber: registrationController.text,
        sheetId: ObjectFactory().appHive.getSheetId(),
        driverId: ObjectFactory().appHive.getDriverId(),
        checkInBy: ObjectFactory().appHive.getName(),
        keyHoldLocation: keyHoldLocationController.text.isEmpty
            ? ObjectFactory().appHive.getName()
            : keyHoldLocationController.text,
      ),
    );
  }

  addVehicleDetailsToSheet(int tokenNumber, int valetCarNumber) async {
    await vehicleBloc.addVehicleToSheet(
        addVehicleRequestModel: AddVehicleRequestModel(
      action: "addVehicle",
      spreadsheetId: ObjectFactory().appHive.getSheetId(),
      registrationNumber: registrationController.text.trim(),
      modelName: modelNameController.text,
      mobileNumber: phoneNumberController.text,
      vehicleStatus: "checkedin",
      tokenNumber: "$tokenNumber",
      checkInTime: DateFormat('h:mm a').format(DateTime.now()),
      checkOutTime: " ",
      parkedLocation: " ",
      parkedBy: " ",
      checkInBy: ObjectFactory().appHive.getName(),
      checkoutBy: " ",
      paymentMethod: selectedPaymentMethod,
      keyHoldLocation: keyHoldLocationController.text,
      valetCarNumber: "$valetCarNumber",
    ));
    setState(() {
      isUploadingDataToSheet = false;
    });
  }

  DateTime now = DateTime.now();
  DateTime? midnight;

  @override
  void initState() {
    print("DateTime(now.day,now.month,now.year)");
    midnight = DateTime(now.day, now.month, now.year);
    print(DateFormat('hh:mm:a').format(midnight!));
    print(DateTime(now.day, now.month, now.year));
    _startListeningToFirestore();
    initialize();
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
    checkSheetCreatedDate();
    super.initState();
    vehicleBloc.createSheetListener.listen((event) {
      updateCenterSheetId(event.data.sheetId);
      ObjectFactory().appHive.putSheetId(sheetId: event.data.sheetId);
      ObjectFactory().appHive.putSheetCreatedDate(
            createdDate: DateFormat.yMMMd().format(DateTime.now()),
          );
      setState(() {
        isSheetCreatedDateCheck = false;
      });
      sheetId = event.data.sheetId;
      addSheetDataToFirebase(event.data.sheetId,
          "${ObjectFactory().appHive.getCenterName()} ${DateFormat.yMMMd().format(DateTime.now())}");
    }).onError((error) async {
      await createSheet();
    });

    vehicleBloc.addVehicleDetailsToFirebaseListener.listen((event) async {
      if (event.valetCarNumber == null || event.tokenNumber == null) {
        AppToasts.showErrorToastTop(
            context, "Something went wrong, please add the details again");
        setState(() {
          isUploadingDataToFirebase = false;
          isUploadingDataToSheet = false;
          isMessageSending = false;
          isUpdatingTokenNumber = false;
        });
      } else {
        print(
            "ADDED VEHICLE DETAILS TO FIREBASE (documentId): ${event.documentId}");
        setState(() {
          isUploadingDataToFirebase = false;

          documentId = event.documentId;
          vehicleDetailsFirebaseResponseModel = event;
        });

        addVehicleDetailsToSheet(event.tokenNumber!, event.valetCarNumber!);
        sendTextMessage(
            vehicleDetailsModel: vehicleDetailsFirebaseResponseModel);
      }
    }, onError: (error) {
      setState(() {
        isUploadingDataToFirebase = false;
        isUploadingDataToSheet = false;
        isMessageSending = false;
        isUpdatingTokenNumber = false;
      });
      AppToasts.showErrorToastTop(
          context, "Oops! Something went wrong, Please try again!");
      print(error);
    });

    vehicleBloc.prefetchCArDetailsListener.listen((event) {
      print("PREFETCH VEHICLE DETAILS RESPONSE :${event.registrationNumber}");
      setState(() {
        isPrefetchingCarDetails = false;
        modelNameController.text = event.modelName!;
        phoneNumberController.text = event.mobileNumber!;
      });
    }, onError: (e) {
      setState(() {
        isPrefetchingCarDetails = false;
      });
    });
    vehicleBloc.addVehicleListener.listen((event) {
      setState(() {
        isUploadingDataToSheet = false;
      });
      pop(context);
    }, onError: (error) {
      setState(() {
        isUploadingDataToSheet = false;
      });
      print(error);
    });
    // centerBloc.updateTokenNumberListener.listen((event) {
    //   print("UPDATE TOKEN RESPONSE: $event");
    //   setState(() {
    //     isUpdatingTokenNumber = true;
    //   });
    //   pop(context);
    // }, onError: (error) {
    //   setState(() {
    //     isUpdatingTokenNumber = false;
    //   });
    //   print(error);
    // });
    // centerBloc.getTokenNumberListener.listen((event) {
    //   print("GET TOKEN RESPONSE: $event");
    //   setState(() {
    //     // tokenNumber = event;
    //     isFetchingTokenNumber = false;
    //   });
    // }, onError: (error) {
    //   setState(() {
    //     isFetchingTokenNumber = false;
    //   });
    //   print(error);
    // });
    centerBloc.getSheetCreatedDateListener.listen((event) {
      print("event");
      print(event);
      if (DateFormat.yMMMd().format(DateTime.now()) ==
          DateFormat.yMMMd().format(event)) {
        ObjectFactory()
            .appHive
            .putSheetCreatedDate(createdDate: DateFormat.yMMMd().format(event));
        getSheetId();
      } else {
        createSheet();
      }
    }, onError: (error) {
      print(error);
    });
    centerBloc.getSheetIdListener.listen((event) {
      ObjectFactory().appHive.putSheetId(sheetId: event);
      setState(() {
        isSheetCreatedDateCheck = false;
      });
    }, onError: (error) {
      print(error);
    });
    sheetBloc.addSheetDetailsToFirebaseListener.listen((event) {
      print(event);
    }, onError: (error) {
      print(error);
    });
  }

  void _startListeningToFirestore() {
    final DocumentReference centerDocRef = FirebaseFirestore.instance
        .collection('centers')
        .doc(ObjectFactory().appHive.getCenterId());

    // Listen to Firestore updates
    _subscription = centerDocRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var centerData = snapshot.data() as Map<String, dynamic>;

        int newValetCarNumber = centerData['valetCarNumber'] ?? 0;
        int newTokenNumber = centerData['tokenNumber'] ?? 0;
        debugPrint("CURRENT TOKEN NUMBER: $newTokenNumber");
        debugPrint("CURRENT VALET CAR NUMBER: $newValetCarNumber");
        if (newValetCarNumber != valetCarNumber ||
            newTokenNumber != tokenNumber) {
          setState(() {
            valetCarNumber = newValetCarNumber;
            tokenNumber = newTokenNumber;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          pop(context);
        },
        appBarTitle: "Enter the vehicle details",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body:
          // isFetchingTokenNumber ||
          isPrefetchingCarDetails || isSheetCreatedDateCheck
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: BuildElevatedButtonWidget(
                              width: screenWidth(context),
                              height: screenHeight(context, dividedBy: 18),
                              backgroundColor: AppColors.lightModeScaffoldColor,
                              borderColor: AppColors.primaryColor,
                              txt: "",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BuildSvgIcon(
                                    assetImagePath: AppAssets.cameraIcon,
                                    iconHeight: 25,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Scan",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            fontFamily: FontFamily.poppins,
                                            fontSize: 15),
                                  )
                                ],
                              ),
                              onTap: () {
                                push(
                                        context,
                                        ScanVehicleRegistrationNumberScreen(
                                            cameras: cameras))
                                    .then(
                                  (value) async {
                                    if (value != null) {
                                      if (value is String) {
                                        setState(() {
                                          registrationController.text = value;
                                          isPrefetchingCarDetails = true;
                                        });
                                        vehicleBloc.prefetchCarDetails(
                                            registrationNumber: value);
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          Text(
                            "Vehicle Details",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 20),
                          BuildTextFieldWithHeadingWidget(
                            textCapitalization: TextCapitalization.characters,
                            heading: "Registration Number",
                            controller: registrationController,
                            maxLines: 1,
                            textSize: 16,
                            contactHintText: "XY88XY8888",
                            validation: (value) {
                              // Check if the field is empty
                              if (value == null || value.isEmpty) {
                                return 'Please enter the registration number!';
                              }

                              if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                                return 'Special charecters and spaces are not expected!';
                              }
                            },
                            showErrorBorderAlways: false,
                            textInputType: TextInputType.text,
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  isPrefetchingCarDetails = true;
                                });
                                vehicleBloc.prefetchCarDetails(
                                    registrationNumber: value);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          BuildTextFieldWithHeadingWidget(
                            heading: "Model Name",
                            controller: modelNameController,
                            contactHintText: "BMW M4 Competition",
                            validation: (value) {
                              // if (value == null || value.isEmpty) {
                              //   return 'Please enter the make and model!';
                              // }
                            },
                            showErrorBorderAlways: false,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 20),
                          BuildTextFieldWithHeadingWidget(
                            heading: "Phone",
                            // maxLines: 2,
                            textSize: 16,
                            controller: phoneNumberController,
                            contactHintText: "XXXX-XXX-XXX",
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the phone number!';
                              }
                              if (value.contains(' ')) {
                                return 'Spaces are not allowed in the phone number!';
                              }

                              if (value.length != 10) {
                                return 'Phone number must be 10 digits long!';
                              }
                            },
                            showErrorBorderAlways: false,
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: BuildSvgIcon(
                                assetImagePath: AppAssets.indiaCountryCodeIcon,
                                iconHeight: 25,
                              ),
                            ),
                            textInputType: TextInputType.phone,
                            maxLength: 10,
                            // maxLines: 1,
                          ),
                          const SizedBox(height: 20),
                          BuildTextFieldWithHeadingWidget(
                              heading: "Key Hold Location",
                              controller: keyHoldLocationController,
                              contactHintText: "A88",
                              validation: (value) {},
                              showErrorBorderAlways: false),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 30),
          child:
              // isFetchingTokenNumber ||
              isPrefetchingCarDetails || isSheetCreatedDateCheck
                  ? const SizedBox.shrink()
                  : BuildElevatedButtonWidget(
                      width: screenWidth(context, dividedBy: 1.2),
                      height: screenHeight(context, dividedBy: 18),
                      txt: "SUBMIT",
                      child: isUploadingDataToSheet
                          ? const BuildLoadingWidget(
                              color: AppColors.primaryColorWhite)
                          : null,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          if (!isUploadingDataToFirebase &&
                              !isUploadingDataToSheet &&
                              !isMessageSending &&
                              !isUpdatingTokenNumber) {
                            await addVehicle();
                          }
                        }
                      },
                    )),
    );
  }
}
