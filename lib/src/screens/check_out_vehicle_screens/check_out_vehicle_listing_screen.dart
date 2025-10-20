import 'package:bops_mobile/src/bloc/center_bloc.dart';
import 'package:bops_mobile/src/bloc/vehicle_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/center_response_model.dart';
import '../../models/vehicle_details_firebase_response_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/object_factory.dart';
import '../../utils/utils.dart';
import '../../widgets/build_checked_out_listing_screen_bottom_sheet_widget.dart';
import '../../widgets/build_curved_appbar_widget.dart';
import '../../widgets/build_custom_dropdown_widget.dart';
import '../../widgets/build_home_screen_header_punch_button_widget.dart';
import '../../widgets/build_homepage_item_list_widget.dart';
import '../../widgets/build_lottie_loading_widget.dart';
import '../../widgets/build_svg_icon.dart';
import '../details_screens/vehicle_details_screen.dart';

class CheckOutVehicleListingScreen extends StatefulWidget {
  const CheckOutVehicleListingScreen({super.key});

  @override
  State<CheckOutVehicleListingScreen> createState() =>
      _CheckOutVehicleListingScreenState();
}

class _CheckOutVehicleListingScreenState
    extends State<CheckOutVehicleListingScreen> {
  ScrollController scrollController = ScrollController();
  List<VehicleDetailsFirebaseResponseModel>? tickets;
  VehicleBloc vehicleBloc = VehicleBloc();
  String? selectedCenterIdForAdmin;
  String? selectedVehicleStatus;
  bool isFetchingTickets = false;
  late List<CenterResponseModel> centers;
  List<String> centersList = [""];
  Map<String, String> centerIdMap = {};
  String? selectedCenter;
  int upiCount = 0;
  int cashCount = 0;
  String? selectedCenterId;
  bool isAdmin = false;
  bool isFetchCenters = false;
  bool isFetchingPaymentCount = false;
  CenterBloc centerBloc = CenterBloc();
  checkIsAdmin() {
    isAdmin =
        ObjectFactory().appHive.getAccountType() == 'admin' ? true : false;
  }

  getPaymentCount() async {
    setState(() {
      isFetchingPaymentCount = true;
    });
    await vehicleBloc.getPaymentCount(
      centerId:
          isAdmin ? selectedCenterId! : ObjectFactory().appHive.getCenterId(),
    );
  }

  getTickets() async {
    setState(() {
      isFetchingTickets = true;
    });
    print("it work");
    await vehicleBloc.getTickets(
        centerId:
            isAdmin ? selectedCenterId! : ObjectFactory().appHive.getCenterId(),
        vehicleStatus: "checkedout");
  }

  fetchCenters() async {
    setState(() {
      isFetchCenters = true;
    });
    await centerBloc.getCenters();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIsAdmin();
    fetchCenters();
    vehicleBloc.getPaymentCountListener.listen((event) {
      setState(() {
        isFetchingPaymentCount = false;
        upiCount = event[0];
        cashCount = event[1];
      });

      print(upiCount);
      print(cashCount);
    }, onError: (error) {
      setState(() {
        isFetchingPaymentCount = false;
      });
    });
    vehicleBloc.getTicketsListener.listen((event) {
      print("data get${event.length}");
      setState(() {
        tickets = event;
        isFetchingTickets = false;
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
      getTickets();
      getPaymentCount();
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
        appBarTitle: " Checked Out Vehicles",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: isFetchingTickets || isFetchCenters || isFetchingPaymentCount
          ? const BuildLottieLoadingWidget()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  if (isAdmin) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: BuildCustomDropdownWidget(
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
                              getTickets();
                              getPaymentCount();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 52,
                          child: BuildHomeScreenHeaderPunchButtonWidget(
                            onTap: (value) {},
                            buttonText: "Vehicle count : ${tickets?.length}",
                            selectedVehicleStatus: 'count',
                          ),
                        ),
                        // Text('${tickets.length}',style: Theme.of(context).textTheme.bodyLarge,),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child:
                  tickets?.length == 0
                      ? Expanded(
                          child: Center(
                            child: Text(
                                "No tickets were generated for this center!"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: tickets?.length,
                            itemBuilder: (BuildContext context, int index) {
                              /// statuses are requested, parked, checkedin, checkedout
                              return BuildHomepageItemListWidget(
                                  tokenNumber:
                                      tickets![index].tokenNumber.toString(),
                                  registrationNumber:
                                      tickets![index].registrationNumber!,
                                  modelName: tickets![index].modelName!,
                                  phoneNumber: tickets![index].mobileNumber!,
                                  inTime: DateFormat('h:mm a').format(
                                      tickets![index].checkInTime!.toDate()),
                                  verticalPadding: 14.0,
                                  outTime: tickets?[index].checkOut != null
                                      ? DateFormat('h:mm a').format(
                                          tickets![index].checkOut!.toDate())
                                      : "",
                                  status: tickets![index].vehicleStatus!,
                                  requestedTime:
                                      tickets?[index].checkOut != null
                                          ? DateFormat('h:mm a').format(
                                              tickets![index]
                                                      .requestedTime
                                                      ?.toDate() ??
                                                  DateTime.now())
                                          : "",
                                  onTap: () {
                                    push(
                                        context,
                                        VehicleDetailsScreen(
                                          ticket: tickets![index],
                                          index: index + 2,
                                        ));
                                  });
                            },
                          ),
                        ),
                  // ),
                ],
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ///Search icon

            FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return BuildCheckedOutListingScreenBottomSheetWidget(
                        upiCount: upiCount,
                        cashCount: cashCount,
                      );
                    }
                    // return BuildHomescreenBottomSheetWidget(
                    //     searchController: searchController,
                    //     onValetCarNumberSearch: () {
                    //       // setState(() {
                    //       //   isSearchingForVehicle = true;
                    //       // });
                    //       //
                    //       // ObjectFactory().appHive.getAccountType() ==
                    //       //     "admin"
                    //       //     ? vehicleBloc.searchVehicleDetails(
                    //       //     valetCarNumber:
                    //       //     int.tryParse(searchController.text),
                    //       //     centerId: selectedCenterIdForAdmin!)
                    //       //     : vehicleBloc.searchVehicleDetails(
                    //       //     valetCarNumber:
                    //       //     int.tryParse(searchController.text),
                    //       //     centerId: ObjectFactory()
                    //       //         .appHive
                    //       //         .getCenterId());
                    //       // searchController.clear();
                    //       // pop(context);
                    //     },
                    //     onRegistrationNumberSearch: () {
                    //       // setState(() {
                    //       //   isSearchingForVehicle = true;
                    //       // });
                    //       // ObjectFactory().appHive.getAccountType() ==
                    //       //     "admin"
                    //       //     ? vehicleBloc.searchVehicleDetails(
                    //       //     registrationNumber: searchController.text,
                    //       //     centerId: selectedCenterIdForAdmin!)
                    //       //     : vehicleBloc.searchVehicleDetails(
                    //       //     registrationNumber: searchController.text,
                    //       //     centerId: ObjectFactory()
                    //       //         .appHive
                    //       //         .getCenterId());
                    //       // searchController.clear();
                    //       // pop(context);
                    //     },
                    //   );
                    // },
                    // );
                    );
              },
              backgroundColor: AppColors.primaryColorBlue,
              child: BuildSvgIcon(
                assetImagePath: AppAssets.moneyReceiveIcon,
                iconHeight: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
