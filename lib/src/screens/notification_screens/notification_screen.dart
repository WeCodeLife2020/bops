import 'package:bops_mobile/src/bloc/vehicle_bloc.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/services/firebase_services.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/build_homepage_item_list_widget.dart';
import '../../widgets/build_loading_widget.dart';
import '../../widgets/build_lottie_loading_widget.dart';
import '../details_screens/vehicle_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<VehicleDetailsFirebaseResponseModel> requestedVehicleDetailsList = [];
  int limit = 10;
  bool isLoading = true;
  bool isLoadingMore = false;
  VehicleBloc vehicleBloc = VehicleBloc();
  ScrollController scrollController = ScrollController();
  getRequestedVehicleDetails() async {
    await vehicleBloc.getRequestedVehicleDetails(
        centerId: ObjectFactory().appHive.getCenterId(), limit: limit);
  }

  void initState() {
    super.initState();
    getRequestedVehicleDetails();

    vehicleBloc.getRequestedVehicleDetailsListener.listen((event) {
      requestedVehicleDetailsList = event;
      for (var item in requestedVehicleDetailsList) {
        print("REQUESTED DATE TIME : ${item.requestedTime}");
        print("CHECKED OUT DATE TIME : ${item.checkOut}");
      }

      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadingMore = true;
          limit += 15;
        });
        print('working');
        getRequestedVehicleDetails();
      }
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
        appBarTitle: "Notifications",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: isLoading
          ? const BuildLottieLoadingWidget()
          : requestedVehicleDetailsList.isEmpty
              ? Center(
                  child: Text('No data found'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: requestedVehicleDetailsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(
                              "REQUESTED VEHICLE LENGTH: ${requestedVehicleDetailsList.length}");

                          /// statuses are requested, parked, checkedin, checkedout
                          return BuildHomepageItemListWidget(
                            requestedTime: requestedVehicleDetailsList[index]
                                        .requestedTime !=
                                    null
                                ? DateFormat('h:mm a').format(
                                        requestedVehicleDetailsList[index]
                                            .requestedTime!
                                            .toDate()) 
                                : "",
                            tokenNumber: requestedVehicleDetailsList[index]
                                .tokenNumber
                                .toString(),
                            registrationNumber:
                                requestedVehicleDetailsList[index]
                                    .registrationNumber!,
                            modelName:
                                requestedVehicleDetailsList[index].modelName!,
                            phoneNumber: requestedVehicleDetailsList[index]
                                .mobileNumber!,
                            inTime: DateFormat('h:mm a').format(
                                requestedVehicleDetailsList[index]
                                    .checkInTime!
                                    .toDate()),
                            outTime:
                                requestedVehicleDetailsList[index].checkOut !=
                                        null
                                    ? DateFormat('h:mm a').format(
                                        requestedVehicleDetailsList[index]
                                            .checkOut!
                                            .toDate())
                                    : "",
                            status: requestedVehicleDetailsList[index]
                                .vehicleStatus!,
                            onTap: () {
                              push(
                                  context,
                                  VehicleDetailsScreen(
                                    ticket: requestedVehicleDetailsList[index],
                                    index: index + 2,
                                  )).then(
                                (_) async {
                                  setState(() {
                                    isLoading = true;
                                    // isFetchingTickets = true;
                                  });
                                  await getRequestedVehicleDetails();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    isLoadingMore
                        ? const BuildLoadingWidget(
                            color: AppColors.primaryColorBlue)
                        : SizedBox(),
                  ],
                ),
    );
  }
}
