import 'package:bops_mobile/src/bloc/center_bloc.dart';
import 'package:bops_mobile/src/screens/driver_screens/add_drivers_screen.dart';
import 'package:flutter/material.dart';

import '../../bloc/driver_bloc.dart';
import '../../models/center_response_model.dart';
import '../../models/driver_response_model.dart';
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

class SuspendedDriversListingScreen extends StatefulWidget {
  const SuspendedDriversListingScreen({super.key});

  @override
  State<SuspendedDriversListingScreen> createState() =>
      _SuspendedDriversListingScreenState();
}

class _SuspendedDriversListingScreenState
    extends State<SuspendedDriversListingScreen> {
  bool isLoading = true;
  bool isFetchCenters = false;
  CenterBloc centerBloc = CenterBloc();
  bool isUpdateSuspendStatus = false;
  DriverBloc driverBloc = DriverBloc();
  List<DriverResponseModel> suspendedDrivers = [];
  late List<CenterResponseModel> centers;
  List<String> centersList = [""];
  Map<String, String> centerIdMap = {};
  String? selectedCenter;
  String? selectedCenterId;
  getDrivers({required String centerId}) {
    setState(() {
      isLoading = true;
    });
    driverBloc.getDrivers(isSuspended: true, centerId: centerId);
  }

  fetchCenters() async {
    setState(() {
      isFetchCenters = true;
    });
    await centerBloc.getCenters();
  }

  updateDriversSuspendStatus(String driverId) async {
    await driverBloc.updateDriverSuspendStatus(
        isSuspended: false, driverId: driverId);
  }

  @override
  void initState() {
    super.initState();
    fetchCenters();
    driverBloc.getDriversListener.listen((event) {
      setState(() {
        suspendedDrivers = event!;
        isLoading = false;
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
        suspendedDrivers.clear();
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
      getDrivers(centerId: selectedCenterId!);
    });
    driverBloc.updateDriverSuspendStatusListener.listen((event) {
      setState(() {
        isUpdateSuspendStatus = false;
      });
      AppToasts.showSuccessToastTop(
          context, "Driver unsuspended successfully!");
    }, onError: (error) {
      setState(() {
        isUpdateSuspendStatus = false;
        // suspendedDrivers.clear();
      });
      AppToasts.showErrorToastTop(
          context, "Driver un suspending failed, Please try again");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          Navigator.pop(context, true);
        },
        appBarTitle: "Suspended Drivers",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: (isLoading || isUpdateSuspendStatus || isFetchCenters)
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
                    initialItem: selectedCenter,
                    onChanged: (event) {
                      setState(() {
                        selectedCenter = event;
                        if (event != null) {
                          selectedCenterId = centerIdMap[event];
                          selectedCenter = event;
                          print("SELECTED CENTER NAME: $event");
                          print("SELECTED CENTER ID: $selectedCenterId");
                          getDrivers(centerId: selectedCenterId!);
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: suspendedDrivers.isEmpty
                        ? Center(
                            child: Text(
                              "You haven't suspended any drivers!",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          )
                        : ListView.builder(
                            itemCount: suspendedDrivers.length,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemBuilder: (BuildContext context, int index) {
                              return BuildManagersListItemCardWidget(
                                isSuspended: true,
                                name: suspendedDrivers[index].driverName!,
                                email: suspendedDrivers[index].driverEmail!,
                                address: suspendedDrivers[index].driverAddress!,
                                phoneNumber:
                                    suspendedDrivers[index].driverPhoneNumber!,
                                buttonText: "Un suspend",
                                buttonBackgroundColor: AppColors
                                    .primaryColorGreen
                                    .withOpacity(0.3),
                                buttonTextColor: AppColors.primaryColorGreen,
                                buttonOnTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BuildSuspendActionAlertWidget(
                                          isSuspend: false,
                                          titleName: suspendedDrivers[index]
                                              .driverName!,
                                          isLoading: false,
                                          // isLoading || isUpdateSuspendStatus,
                                          firstButtonText: "Cancel",
                                          secondButtonText: "Un suspend",
                                          onFirstButtonTap: () {
                                            pop(context);
                                          },
                                          onSecondButtonTap: () async {
                                            setState(() {
                                              isUpdateSuspendStatus = true;
                                            });
                                            pop(context);
                                            await updateDriversSuspendStatus(
                                                suspendedDrivers[index]
                                                    .driverId!);
                                            await getDrivers(
                                                centerId: selectedCenterId!);
                                          },
                                        );
                                      });
                                },
                                editButtonOnTap: () {},
                              );
                            }),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          push(context, const AddDriversScreen());
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
