import 'package:bops_mobile/src/bloc/center_bloc.dart';
import 'package:bops_mobile/src/bloc/driver_bloc.dart';
import 'package:bops_mobile/src/models/driver_response_model.dart';
import 'package:bops_mobile/src/screens/driver_screens/add_drivers_screen.dart';
import 'package:bops_mobile/src/screens/driver_screens/suspended_drivers_listing_screen.dart';
import 'package:bops_mobile/src/screens/manager_screens/suspended_managers_listing_screen.dart';
import 'package:flutter/material.dart';

import '../../models/center_response_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_toasts.dart';
import '../../utils/utils.dart';
import '../../widgets/build_curved_appbar_widget.dart';
import '../../widgets/build_custom_dropdown_widget.dart';
import '../../widgets/build_lottie_loading_widget.dart';
import '../../widgets/build_managers_list_item_card_widget.dart';
import '../../widgets/build_suspend_action_alert_widget.dart.dart';
import '../../widgets/build_svg_icon.dart';
import '../../widgets/build_svg_icon_button.dart';
import '../manager_screens/add_managers_screen.dart';

class DriversListingScreen extends StatefulWidget {
  const DriversListingScreen({super.key});

  @override
  State<DriversListingScreen> createState() => _DriversListingScreenState();
}

class _DriversListingScreenState extends State<DriversListingScreen> {
  bool isLoading = true;
  bool isFetchCenters = false;
  bool isUpdateSuspendStatus = false;
  DriverBloc driverBloc = DriverBloc();
  CenterBloc centerBloc = CenterBloc();
  List<DriverResponseModel> drivers = [];
  late List<CenterResponseModel> centers;
  List<String> centersList = [""];
  Map<String, String> centerIdMap = {};
  String? selectedCenter;
  String? selectedCenterId;
  getDrivers() {

    driverBloc.getDrivers(isSuspended: false, centerId: selectedCenterId!);
  }

  fetchCenters() async {
    setState(() {
      isFetchCenters = true;
    });
    await centerBloc.getCenters();
  }

  updateDriversSuspendStatus(String driverId) async {
    await driverBloc.updateDriverSuspendStatus(
        isSuspended: true, driverId: driverId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCenters();
    driverBloc.getDriversListener.listen((event) {
      print('data get');
      setState(() {
        drivers = event!;
        isLoading = false;
      });
    }, onError: (error) {
      drivers.clear();
      setState(() {
        isLoading = false;
      });
    });
    centerBloc.getCentersListener.listen((event) {
      setState(() {
        centers = event;
        centersList = centers.map((center) => center.centerName!).toList();
        centerIdMap = {
          for (var center in centers) center.centerName!: center.centerId!,
        };
        selectedCenter = centersList[0];
        selectedCenterId = centerIdMap[centersList[0]];
        isFetchCenters = false;
      });
      getDrivers();
    });
    driverBloc.updateDriverSuspendStatusListener.listen((event) {
      setState(() {
        isUpdateSuspendStatus = false;
      });
      AppToasts.showSuccessToastTop(context, "Driver suspended successfully!");
    }, onError: (error) {
      setState(() {
        isUpdateSuspendStatus = false;
      });
      AppToasts.showErrorToastTop(
          context, "Driver suspension failed, Please try");
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
        appBarTitle: "Drivers",
        appBarHeight: screenHeight(context, dividedBy: 9),
        actions: [
          BuildSvgIconButton(
            assetImagePath: AppAssets.suspendedIcon,
            iconHeight: 40,
            onTap: () {
              push(context, SuspendedDriversListingScreen()).then(
                (value) async {
                  print("VALUE: $value");
                  if (value) {
                    setState(() {
                      isLoading = true;
                    });
                    getDrivers();
                  }
                },
              );
            },
          )
        ],
      ),
      body: (isLoading || isUpdateSuspendStatus)
          ? BuildLottieLoadingWidget(
              lottieHeight: screenHeight(context, dividedBy: 6),
              lottieWidth: screenHeight(context, dividedBy: 6),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [

                  BuildCustomDropdownWidget(
                    dropDownItems: centersList,
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
                          getDrivers();
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                 Expanded(
                          child:  drivers.isEmpty
                              ? Center(
                            child: Text(
                              "You haven't added any drivers!",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          )
                              : ListView.builder(
                              itemCount: drivers.length,
                              // padding: const EdgeInsets.all(20),
                              itemBuilder: (BuildContext context, int index) {
                                return BuildManagersListItemCardWidget(
                                  isSuspended: false,
                                  name: drivers[index].driverName!,
                                  email: drivers[index].driverEmail!,
                                  address: drivers[index].driverAddress!,
                                  phoneNumber:
                                      drivers[index].driverPhoneNumber!,
                                  buttonText: "Suspend",
                                  buttonBackgroundColor: AppColors
                                      .primaryColorRed
                                      .withOpacity(0.3),
                                  buttonTextColor: AppColors.primaryColorRed,
                                  buttonOnTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return BuildSuspendActionAlertWidget(
                                              isSuspend: true,
                                              titleName:
                                                  drivers[index].driverName!,
                                              isLoading: isLoading ||
                                                  isUpdateSuspendStatus,
                                              firstButtonText: "Cancel",
                                              secondButtonText: "Suspend",
                                              onFirstButtonTap: () {
                                                pop(context);
                                              },
                                              onSecondButtonTap: () async {
                                                setState(() {
                                                  isUpdateSuspendStatus = true;
                                                  // drivers.clear();
                                                });
                                                pop(context);
                                                await updateDriversSuspendStatus(
                                                    drivers[index].driverId!);
                                                await getDrivers();
                                              });
                                        });
                                  },
                                  editButtonOnTap: (){
                                    push(context,  AddDriversScreen(isEdit: true,driverDetails: drivers[index],)).then(
                                          (value) async {
                                        print("VALUE: $value");
                                        if (value) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          getDrivers();
                                        }
                                      },
                                    );
                                  },
                                );
                              }),
                        ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          push(context, const AddDriversScreen()).then(
            (value) async {
              print("VALUE: $value");
              if (value) {
                setState(() {
                  isLoading = true;
                });
                getDrivers();
              }
            },
          );
          // ;
        },
        backgroundColor: AppColors.primaryColorBlue,
        child: BuildSvgIcon(
          assetImagePath: AppAssets.addIcon,
          iconHeight: 30,
        ),
      ),
    );
  }
}
