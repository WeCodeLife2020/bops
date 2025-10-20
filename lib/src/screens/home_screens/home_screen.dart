import 'dart:async';

import 'package:bops_mobile/src/bloc/driver_bloc.dart';
import 'package:bops_mobile/src/bloc/managers_bloc.dart';
import 'package:bops_mobile/src/bloc/profile_bloc.dart';
import 'package:bops_mobile/src/bloc/user_auth_bloc.dart';
import 'package:bops_mobile/src/bloc/vehicle_bloc.dart';
import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/screens/center_screens/centers_listing_screen.dart';
import 'package:bops_mobile/src/screens/check_out_vehicle_screens/check_out_vehicle_listing_screen.dart';
import 'package:bops_mobile/src/screens/details_screens/vehicle_details_screen.dart';
import 'package:bops_mobile/src/screens/driver_screens/drivers_listing_screen.dart';
import 'package:bops_mobile/src/screens/manager_screens/managers_listing_screen.dart';
import 'package:bops_mobile/src/screens/notification_screens/notification_screen.dart';
import 'package:bops_mobile/src/screens/onboarding_screens/login_screen.dart';
import 'package:bops_mobile/src/screens/profile_screens/edit_profile_screen.dart';
import 'package:bops_mobile/src/screens/profile_screens/requested_users_listing_screen.dart';
import 'package:bops_mobile/src/screens/profile_screens/users_listing_screen.dart';
import 'package:bops_mobile/src/screens/report_screens/report_screen.dart';
import 'package:bops_mobile/src/screens/scanning_screens/add_vehicle_details_screen.dart';
import 'package:bops_mobile/src/services/notification_services.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/constants.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_home_screen_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_home_screen_drawer_widget.dart';
import 'package:bops_mobile/src/widgets/build_home_screen_header_punch_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_homepage_item_list_widget.dart';
import 'package:bops_mobile/src/widgets/build_homescreen_bottom_sheet_widget.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../../bloc/center_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = SearchController();
  NotificationsServices notificationsServices = NotificationsServices();
  bool isScrolled = false;
  String? selectedVehicleStatus;
  List<String> statusList = [
    "Requested",
    "Checked In",
    "Parked",
  ];
  UserAuthBloc userAuthBloc = UserAuthBloc();
  ProfileBloc profileBloc = ProfileBloc();
  ManagersBloc managerBloc = ManagersBloc();
  CenterBloc centerBloc = CenterBloc();
  VehicleBloc vehicleBloc = VehicleBloc();
  DriverBloc driverBloc = DriverBloc();
  bool isSigningOut = false;
  bool isClearingFcmToken = false;
  bool isInitializing = true;
  bool isFetchingSuspendStatus = true;
  bool isUserSuspended = false;
  bool isCenterDeleted = false;
  bool isFetchingCenters = true;
  bool isFetchingCurrentCenter = true;
  bool isFetchingCurrentCenterId = true;
  bool isFetchingManagerId = true;
  bool isUpdatingCenterDates = false;
  bool isFetchingTickets = true;
  bool isSearchingForVehicle = false;
  String? managerId;
  String? currentCenter;
  String? currentCenterId;
  String? selectedCenterForAdmin;
  String? selectedCenterIdForAdmin;
  List<String> centersList = [""];

  // List<String>vehicleStatusList=["Requested","Parked","CheckIn","CheckOut"];
  late List<CenterResponseModel> centers;
  List<VehicleDetailsFirebaseResponseModel> tickets = [];
  Map<String, String> centerIdMap = {};
  Timer? timer;
  int? appData;
  bool needUpdate = false;

  // String appBuildNumber = "";

  /// for logout
  logout() async {
    setState(() {
      isClearingFcmToken = true;
      isSigningOut = true;
    });
    await userAuthBloc.signOut();
    await profileBloc.clearFcmToken(
        userId: ObjectFactory().appHive.getUserId());
    // await FirebaseMessaging.instance
    //     .unsubscribeFromTopic(ObjectFactory().appHive.getCenterId());
    await ObjectFactory().appHive.clearBox();
    await clearCache();
    pushAndReplacement(context, const LoginScreen());
  }

  //get app version from firebase
  getAppVersion() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("appVersion").get();
    // final data = querySnapshot.docs.map((e) => e.data()).toList();
    // print("querySnapshot.docs[0].data()");
    // print(querySnapshot.docs[0]['buildNumber']);
    // packageInfo = await PackageInfo.fromPlatform();

    return int.parse(querySnapshot.docs[0]['buildNumber']);
  }

  /// Initializing- get if user is suspended and fetches user data
  initialize() async {
    appData = await getAppVersion();
    if (appData! <= Constants.APP_BUILD_NUMBER) {
      await managerBloc.getIsSuspended(
          userId: ObjectFactory().appHive.getUserId());

      await profileBloc.getUserData(
          userId: ObjectFactory().appHive.getUserId());
    } else {
      setState(() {
        needUpdate = true;
      });
      showAlert(context, "Please update the app");
      // AppToasts.showErrorToastTop(context, "Show alert box now");
    }
  }

  getDriverSuspendedStatus() {
    driverBloc.getDriverSuspendedStatus(
        userId: ObjectFactory().appHive.getUserId());
  }

  /// refetch user data upon pressing reload button
  void reFetchUserData() async {
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          isInitializing = true;
          isFetchingSuspendStatus = true;
          isFetchingCenters = true;
          isFetchingCurrentCenter = true;
          isFetchingCurrentCenterId = true;
          isFetchingManagerId = true;
          isUpdatingCenterDates = true;
          isFetchingTickets = true;
        });
      }

      await initialize();
    }
  }

  /// Starting timer to automatically reload every 2 minutes
  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      refreshButtonTapAction();
    });
  }

  /// Function to call for auto refresh every 2 minutes
  Future<void> refreshButtonTapAction() async {
    setState(() {
      isFetchingTickets = true;
    });
    print(selectedCenterForAdmin);
    ObjectFactory().appHive.getAccountType() == "manager" ||
            ObjectFactory().appHive.getAccountType() == "driver"
        ? await vehicleBloc.getTickets(
            centerId: ObjectFactory().appHive.getCenterId(),
            vehicleStatus: selectedVehicleStatus!)
        : selectedCenterIdForAdmin != null
            ? await vehicleBloc.getTickets(
                centerId: selectedCenterIdForAdmin!,
                vehicleStatus: selectedVehicleStatus!)
            : setState(() {
                isFetchingTickets = false;
              });
  }

  /// for saving user data to hive
  saveUserDataToHive(UserResponseModel userResponseModel) async {
    /// to put account type as user, manager or admin
    await ObjectFactory()
        .appHive
        .putAccountType(accountType: userResponseModel.accountType);

    /// to put username
    await ObjectFactory().appHive.putName(name: userResponseModel.userName);

    /// Setting account tyoe to local variable
    String accountType = ObjectFactory().appHive.getAccountType();

    /// if account type is fetching all centers
    if (accountType == "admin") {
      print("IS ADMIN");
      await centerBloc.getCenters();

      /// Stopping all other loadings which are used if account type is manager
      setState(() {
        isFetchingCurrentCenter = false;
        isFetchingCurrentCenterId = false;
        isFetchingManagerId = false;
        isUpdatingCenterDates = false;
      });
    }

    /// get center Id, center name and manager Id if account type is manager
    else if (accountType == "manager") {
      /// Fetching center name
      // print("IS MANAGER");

      /// fetching centerId
      await managerBloc.getCenterId(
          userId: ObjectFactory().appHive.getUserId());

      /// fetching managerId
      await managerBloc.getManagerId(
          userId: ObjectFactory().appHive.getUserId());

      /// stopping loading for account type admin, as that loading is not necessary
      setState(() {
        isFetchingCenters = false;
      });
    } else if (accountType == "driver") {
      ///fetch centerName
      // print("IS DRIVER");
      // print(ObjectFactory().appHive.getUserId());
      // await driverBloc.getDriverCenterName(
      //     userId: ObjectFactory().appHive.getUserId());

      await driverBloc.getDriverCenterId(
          userId: ObjectFactory().appHive.getUserId());

      await driverBloc.getDriverId(userId: ObjectFactory().appHive.getUserId());

      setState(() {
        isFetchingCenters = false;
      });
    }

    /// Stopping all loadings as account type is user
    else {
      setState(() {
        isFetchingCenters = false;
        isFetchingCurrentCenter = false;
        isFetchingCurrentCenterId = false;
        isFetchingManagerId = false;
        isUpdatingCenterDates = false;
        isFetchingTickets = false;
      });
    }
  }

  /// Saving suspend status to hive
  saveSuspendStatusToHive(bool isSuspended) async {
    await ObjectFactory().appHive.putIsSuspended(isSuspended: isSuspended);
  }

  saveCenterDeleteStatusToHive(bool isDeleted) async {
    await ObjectFactory().appHive.putIsDeleted(isDeleted: isDeleted);
  }

  /// Saving current center to hive  for manager
  saveCurrentCenterToHive(String currentCenter) async {
    await ObjectFactory().appHive.putCenterName(centerName: currentCenter);
  }

  /// Saving current centerId to hive for manager
  saveCurrentCenterIdToHive(String currentCenterId) async {
    await ObjectFactory().appHive.putCenterId(centerId: currentCenterId);
  }

  /// Saving manager Id to hive
  saveManagerIdToHive(String managerId) async {
    await ObjectFactory().appHive.putManagerId(managerId: managerId);
  }

  saveDriverCenterNameToHive(String centerName) async {
    await ObjectFactory().appHive.putCenterName(centerName: centerName);
  }

  saveDriverCenterIdToHive(String centerId) async {
    await ObjectFactory().appHive.putCenterId(centerId: centerId);
  }

  saveDriverIdToHive(String driverId) async {
    await ObjectFactory().appHive.putDriverId(driverId: driverId);
  }

  getTicket() async {
    ObjectFactory().appHive.getAccountType() == "manager" ||
            ObjectFactory().appHive.getAccountType() == "driver"
        ? await vehicleBloc.getTickets(
            centerId: ObjectFactory().appHive.getCenterId(),
            vehicleStatus: selectedVehicleStatus!)
        : selectedCenterIdForAdmin != null
            ? await vehicleBloc.getTickets(
                centerId: selectedCenterIdForAdmin!,
                vehicleStatus: selectedVehicleStatus!)
            : setState(() {
                isFetchingTickets = false;
              });
  }

  Future<void> getNotificationPermission() async {
    await notificationsServices.init();
  }

  @override
  void initState() {
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     actionType: ActionType.Default,
    //     id: 10,
    //     channelKey: 'basic_channel',
    //     title: "Hello",
    //     body:"There",
    //     wakeUpScreen: true,
    //   ),
    // );
    /// for getting suspend status and user details
    initialize();
    getNotificationPermission();

    startTimer();
    selectedVehicleStatus = "requested";

    /// For fetching user data
    profileBloc.getUserDataListener.listen((event) async {
      print("FETCHED USER DATA:${event.toJson()}");
      saveUserDataToHive(event);
      setState(() {
        isInitializing = false;
      });
    }, onError: (error) {
      setState(() {
        isInitializing = false;
      });
      AppToasts.showErrorToastTop(context, error);
    });

    /// Get user suspended status
    managerBloc.getIsSuspendedListener.listen((event) async {
      print("IS USER SUSPENDED RESPONSE: $event");
      setState(() {
        isUserSuspended = event;
      });
      saveSuspendStatusToHive(event);
      if (event == false) {
        getDriverSuspendedStatus();
      } else {
        setState(() {
          isFetchingSuspendStatus = false;
        });
      }
    }, onError: (error) {
      print('error occuer in menager suspend status');
      setState(() {
        isFetchingSuspendStatus = false;
      });
    });

    /// Fetching driver suspended status
    driverBloc.getDriverSuspendedStatusListener.listen((event) {
      setState(() {
        isUserSuspended = event;
        isFetchingSuspendStatus = false;
      });
      saveSuspendStatusToHive(event);
    }, onError: (error) {
      setState(() {
        isFetchingSuspendStatus = false;
      });
    });

    /// Fetching all centers when account type is admin
    centerBloc.getCentersListener.listen((event) async {
      print("FETCHED CENTERS DATA: $event");

      setState(() {
        centers = event;
        centersList = centers.map((center) => center.centerName!).toList();
        centerIdMap = {
          for (var center in centers) center.centerName!: center.centerId!,
        };

        if (centers.isNotEmpty) {
          selectedCenterForAdmin =
              centersList[0]; // Set as default selected center
          selectedCenterIdForAdmin = centerIdMap[selectedCenterForAdmin];
        } else {
          centersList = ["No centers !"];
          selectedCenterForAdmin = null; // No selection possible
        }

        isFetchingCenters = false;
      });

      print("SELECTED CENTER: $selectedCenterForAdmin");
      print("SELECTED CENTER ID: $selectedCenterIdForAdmin");

      if (centers.isNotEmpty && selectedCenterIdForAdmin != null) {
        print("Fetching tickets for center ID: $selectedCenterIdForAdmin");

        // Await the getTickets call to ensure it completes
        await vehicleBloc.getTickets(
            centerId: selectedCenterIdForAdmin!,
            vehicleStatus: selectedVehicleStatus!);

        print("Tickets fetched for center ID: $selectedCenterIdForAdmin");
      } else {
        setState(() {
          isFetchingTickets =
              false; // Reset loading state if no tickets can be fetched
        });
      }
    });

    /// Fetching center name for manager
    managerBloc.getCenterNameListener.listen((event) async {
      print("FETCHED CENTER NAME: $event");

      /// Saving current center tot hive
      saveCurrentCenterToHive(event);
      // await FirebaseMessaging.instance
      //     .subscribeToTopic(ObjectFactory().appHive.getCenterId());

      // await centerBloc.getIsDeleted(centerId: ObjectFactory().appHive.getCenterId());
      setState(() {
        currentCenter = event;
        isFetchingCurrentCenter = false;
      });
    });
    centerBloc.getCenterNameByCenterIdListener.listen((event) async {
      print("FETCHED CENTER NAME: $event");

      /// Saving current center tot hive
      saveCurrentCenterToHive(event);
      // await FirebaseMessaging.instance
      //     .subscribeToTopic(ObjectFactory().appHive.getCenterId())
      //     .whenComplete(() {
      //   debugPrint("IS SUBSCRIBED to : ${ObjectFactory().appHive.getCenterId()}");
      // });
      await centerBloc.getIsDeleted(
          centerId: ObjectFactory().appHive.getCenterId());
      setState(() {
        currentCenter = event;
        isFetchingCurrentCenter = false;
      });
    });
    centerBloc.getIsDeletedListener.listen((event) {
      // print("this is event $event");
      setState(() {
        isCenterDeleted = event;
        saveCenterDeleteStatusToHive(event);
      });
    });

    /// Fetching center Id for manager
    managerBloc.getCenterIdListener.listen((event) async {
      print("FETCHED CENTER ID: $event");

      /// Saving current center id to hive
      saveCurrentCenterIdToHive(event);

      await centerBloc.getCenterNameByCenterId(
          centerId: event,
          userId: ObjectFactory().appHive.getUserId(),
          isManager: true);
      // await managerBloc.getCenterName(
      //     userId: ObjectFactory().appHive.getUserId());
      /// Updating center dates and tokens based on daily refresh timeline
      // centerBloc.updateCenterDates(centerId: event);
      setState(() {
        currentCenterId = event;
        isFetchingCurrentCenterId = false;
      });
    });

    /// fetching manager id
    managerBloc.getManagerIdListener.listen((event) {
      print("FETCHED MANAGER ID: $event");

      /// Saving manager id to hive
      saveManagerIdToHive(event);
      setState(() {
        managerId = event;
        isFetchingManagerId = false;
      });

      /// Fetching tickets for manager based on center id
      vehicleBloc.getTickets(
          centerId: ObjectFactory().appHive.getCenterId(),
          vehicleStatus: selectedVehicleStatus!);
    });

    driverBloc.getDriverCenterNameListener.listen((event) {
      print(event);
      saveDriverCenterNameToHive(event);
      setState(() {
        currentCenter = event;
        isFetchingCurrentCenter = false;
      });
    });

    driverBloc.getDriverCenterIdListener.listen((event) async {
      saveCurrentCenterIdToHive(event);
      await centerBloc.getCenterNameByCenterId(
          centerId: event,
          userId: ObjectFactory().appHive.getUserId(),
          isManager: false);

      /// Updating center dates and tokens based on daily refresh timeline
      // centerBloc.updateCenterDates(centerId: event);
      setState(() {
        currentCenterId = event;
        isFetchingCurrentCenterId = false;
      });
    });

    driverBloc.getDriverIdListener.listen((event) {
      saveDriverIdToHive(event);
      setState(() {
        // managerId = event;
        isFetchingManagerId = false;
      });

      /// Fetching tickets for manager based on center id
      vehicleBloc.getTickets(
          centerId: ObjectFactory().appHive.getCenterId(),
          vehicleStatus: selectedVehicleStatus!);
    });

    /// Fetching tickets listener
    vehicleBloc.getTicketsListener.listen((event) {
      print("GET TICKETS RESPONSE: $event");
      setState(() {
        tickets = event;
        isFetchingTickets = false;
      });
      tickets.isEmpty ? isScrolled = false : null;
    });

    /// updating centres dates and token number listener
    centerBloc.updateCenterDatesListener.listen((event) {
      print("CENTER DATES UPDATE RESPONSE: $event");
      setState(() {
        isUpdatingCenterDates = false;
      });
      print(
          "$isInitializing $isClearingFcmToken $isSigningOut $isFetchingCenters");
    });

    /// Sign out listener
    userAuthBloc.signOutResponse.listen((event) {
      print("SIGN OUT RESPONSE: $event");
      setState(() {
        isSigningOut = false;
      });
      AppToasts.showSuccessToastTop(context, "Signed out successfully!");
    }, onError: (error) {
      setState(() {
        isSigningOut = false;
      });
      AppToasts.showErrorToastTop(context, error);
    });

    /// Clearing fcm token listener
    profileBloc.clearFcmTokenListener.listen((event) {
      print("CLEAR FCM TOKEN RESPONSE: $event");
      setState(() {
        isClearingFcmToken = false;
      });
    }, onError: (error) {
      setState(() {
        isClearingFcmToken = false;
      });
      AppToasts.showErrorToastTop(context, error);
    });

    /// Search vehicle listener
    vehicleBloc.searchVehicleDetailsListener.listen((event) {
      setState(() {
        isSearchingForVehicle = false;
      });
      push(context, VehicleDetailsScreen(ticket: event)).then((_) {
        if (ObjectFactory().appHive.getAccountType() == "manager") {
          reFetchUserData();
        }
      });
    }).onError((error) {
      setState(() {
        isSearchingForVehicle = false;
      });
      AppToasts.showErrorToastTop(context, "No vehicle data found!");
    });

    /// Scroll listener for appbar variable height
    scrollController.addListener(() {
      // if (scrollController.offset > 50 && !isScrolled) {
      //   setState(() {
      //     isScrolled = true;
      //   });
      // } else if (scrollController.offset <= 50 && isScrolled) {
      //   setState(() {
      //     isScrolled = false;
      //   });
      // }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrolled) {
          if (mounted) {
            setState(() {
              isScrolled = true;
            });
          }
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrolled) {
          if (mounted) {
            setState(() {
              isScrolled = false;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.lightModeScaffoldColor,
      drawer: BuildHomeScreenDrawerWidget(
        backgroundColor: AppColors.lightModeScaffoldColor,
        headerColor: AppColors.lightModeScaffoldColor,
        backButtonTap: () {
          scaffoldKey.currentState?.closeDrawer();
        },
        firstButtonTap: () {
          push(context, const ReportScreen());
          scaffoldKey.currentState?.closeDrawer();
        },
        secondButtonTap: () {
          push(context, const ManagersListingScreen());
          scaffoldKey.currentState?.closeDrawer();
        },
        thirdButtonTap: () {
          push(context, const CentersListingScreen()).then((value) {
            if (value == true) {
              reFetchUserData();
            }
          });
          scaffoldKey.currentState?.closeDrawer();
        },
        fourthButtonTap: () {
          push(context, DriversListingScreen());
          scaffoldKey.currentState?.closeDrawer();
        },
        fifthButtonTap: () {
          push(context, const UsersListingScreen());
          scaffoldKey.currentState?.closeDrawer();
        },
        sixthButtonTap: () {
          push(context, const RequestedUsersListingScreen());
          scaffoldKey.currentState?.closeDrawer();
        },
        seventhButtonTap: () {
          push(context, const EditProfileScreen());
          scaffoldKey.currentState?.closeDrawer();
        },
        eighthButtonTap: () {
          push(context, const CheckOutVehicleListingScreen());
          scaffoldKey.currentState?.closeDrawer();
        },
        sliderAction: () async {
          scaffoldKey.currentState?.closeDrawer();
          await logout();
        },
      ),
      body: isInitializing ||
              isClearingFcmToken ||
              isSigningOut ||
              isFetchingCenters ||
              isFetchingCurrentCenter ||
              isFetchingCurrentCenterId ||
              isUpdatingCenterDates
          // ||
          // isSearchingForVehicle
          ? const BuildLottieLoadingWidget()
          : Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: screenHeight(context, dividedBy: 5),
                    end: isScrolled
                        ? screenHeight(context, dividedBy: 9)
                        : screenHeight(context, dividedBy: 5),
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, appBarHeight, child) {
                    return BuildHomeScreenAppbarWidget(
                      isSuspended: isUserSuspended || isCenterDeleted,
                      appBarHeight: appBarHeight,
                      drawerIconTap: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                      notificationIconTap: () {
                        push(context, NotificationScreen());
                      },
                      refreshButtonTapAction: () async {
                        setState(() {
                          isFetchingTickets = true;
                        });
                        ObjectFactory().appHive.getAccountType() == "manager" ||
                                ObjectFactory().appHive.getAccountType() ==
                                    "driver"
                            ? await vehicleBloc.getTickets(
                                centerId: ObjectFactory().appHive.getCenterId(),
                                vehicleStatus: selectedVehicleStatus!)
                            : selectedCenterIdForAdmin != null
                                ? await vehicleBloc.getTickets(
                                    centerId: selectedCenterIdForAdmin!,
                                    vehicleStatus: selectedVehicleStatus!)
                                : setState(() {
                                    isFetchingTickets = false;
                                  });
                      },
                      dropDownSelectionAction: (event) async {
                        // print("EVENT: $event");
                        setState(() {
                          selectedCenterForAdmin = event;
                          if (centersList.isNotEmpty && event != null) {
                            selectedCenterIdForAdmin = centerIdMap[event];
                          }
                        });

                        if (selectedCenterIdForAdmin != null) {
                          setState(() {
                            isFetchingTickets = true;
                          });
                          await vehicleBloc.getTickets(
                              centerId: selectedCenterIdForAdmin!,
                              vehicleStatus: selectedVehicleStatus!);
                        } else {
                          AppToasts.showErrorToastTop(
                              context, "No centers available to select.");
                        }
                      },
                      centersList: centersList,
                      iconHeight: 30,
                      imageUrl: ObjectFactory().appHive.getProfilePic(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 52,
                    width: screenWidth(context, dividedBy: 2),
                    child: BuildHomeScreenHeaderPunchButtonWidget(
                      onTap: (value) {},
                      buttonText: "Vehicle count : ${tickets.length}",
                      selectedVehicleStatus: 'count',
                    ),
                  ),
                ),
                if (ObjectFactory().appHive.getAccountType() != "user" &&
                    !isUserSuspended &&
                    !isCenterDeleted) ...[
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: statusList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return BuildHomeScreenHeaderPunchButtonWidget(
                          onTap: (value) {
                            setState(() {
                              selectedVehicleStatus = value;
                              isFetchingTickets = true;
                            });
                            print(selectedVehicleStatus);
                            getTicket();
                          },
                          buttonText: statusList[index],
                          selectedVehicleStatus: selectedVehicleStatus!,
                        );
                      },
                    ),
                  ),
                ],
                (isSigningOut ||
                        isClearingFcmToken ||
                        isFetchingCurrentCenter ||
                        isSigningOut ||
                        isFetchingCurrentCenterId ||
                        isUpdatingCenterDates ||
                        isFetchingTickets ||
                        isSearchingForVehicle ||
                        isFetchingCenters)
                    ? Expanded(
                        child: BuildLottieLoadingWidget(
                          lottieHeight: screenHeight(context, dividedBy: 6),
                          lottieWidth: screenHeight(context, dividedBy: 6),
                        ),
                      )
                    : isUserSuspended
                        ? Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Your account is suspended",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 20),
                                  BuildElevatedButtonWidget(
                                    width: screenWidth(context, dividedBy: 2.8),
                                    height:
                                        screenHeight(context, dividedBy: 22),
                                    txt: "TRY AGAIN",
                                    child: null,
                                    onTap: () {
                                      reFetchUserData();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ObjectFactory().appHive.getAccountType() == "user"
                            ? Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "You are not a manager!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      const SizedBox(height: 20),
                                      BuildElevatedButtonWidget(
                                        width: screenWidth(context,
                                            dividedBy: 2.8),
                                        height: screenHeight(context,
                                            dividedBy: 22),
                                        txt: "TRY AGAIN",
                                        child: null,
                                        onTap: () {
                                          reFetchUserData();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : isCenterDeleted
                                ? Expanded(
                                    child: Center(
                                      child: Text(
                                        "The center has been deleted by the admin",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                    ),
                                  )
                                : tickets.isEmpty
                                    ? Expanded(
                                        child: Center(
                                          child: Text(
                                            "No tickets were generated for this center!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: tickets.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            /// statuses are requested, parked, checkedin, checkedout
                                            return BuildHomepageItemListWidget(
                                              requestedTime: tickets[index]
                                                          .requestedTime !=
                                                      null
                                                  ? DateFormat('h:mm a').format(
                                                      tickets[index]
                                                          .requestedTime!
                                                          .toDate())
                                                  : "",
                                              tokenNumber: tickets[index]
                                                  .tokenNumber
                                                  .toString(),
                                              registrationNumber: tickets[index]
                                                  .registrationNumber!,
                                              modelName:
                                                  tickets[index].modelName!,
                                              phoneNumber:
                                                  tickets[index].mobileNumber!,
                                              inTime: DateFormat('h:mm a')
                                                  .format(tickets[index]
                                                      .checkInTime!
                                                      .toDate()),
                                              outTime:
                                                  tickets[index].checkOut !=
                                                          null
                                                      ? DateFormat('h:mm a')
                                                          .format(tickets[index]
                                                              .checkOut!
                                                              .toDate())
                                                      : "",
                                              status:
                                                  tickets[index].vehicleStatus!,
                                              onTap: () {
                                                push(
                                                    context,
                                                    VehicleDetailsScreen(
                                                      ticket: tickets[index],
                                                      index: index + 2,
                                                    )).then(
                                                  (_) async {
                                                    setState(() {
                                                      isFetchingTickets = true;
                                                    });
                                                    await vehicleBloc.getTickets(
                                                        centerId: ObjectFactory()
                                                                        .appHive
                                                                        .getAccountType() ==
                                                                    "manager" ||
                                                                ObjectFactory()
                                                                        .appHive
                                                                        .getAccountType() ==
                                                                    "driver"
                                                            ? ObjectFactory()
                                                                .appHive
                                                                .getCenterId()
                                                            : selectedCenterIdForAdmin!,
                                                        vehicleStatus:
                                                            selectedVehicleStatus!);
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
              ],
            ),
      floatingActionButton: isInitializing ||
              isClearingFcmToken ||
              isFetchingCurrentCenter ||
              isUpdatingCenterDates ||
              isSigningOut ||
              isFetchingCurrentCenterId ||
              isFetchingTickets ||
              isFetchingCenters ||
              ObjectFactory().appHive.getAccountType() == "user" ||
              isUserSuspended ||
              isCenterDeleted
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ///Search icon

                  FloatingActionButton(
                    heroTag: null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90)),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return BuildHomescreenBottomSheetWidget(
                            searchController: searchController,
                            onValetCarNumberSearch: () {
                              setState(() {
                                isSearchingForVehicle = true;
                              });

                              ObjectFactory().appHive.getAccountType() ==
                                      "admin"
                                  ? vehicleBloc.searchVehicleDetails(
                                      valetCarNumber:
                                          int.tryParse(searchController.text),
                                      centerId: selectedCenterIdForAdmin!)
                                  : vehicleBloc.searchVehicleDetails(
                                      valetCarNumber:
                                          int.tryParse(searchController.text),
                                      centerId: ObjectFactory()
                                          .appHive
                                          .getCenterId());
                              searchController.clear();
                              pop(context);
                            },
                            onRegistrationNumberSearch: () {
                              setState(() {
                                isSearchingForVehicle = true;
                              });
                              ObjectFactory().appHive.getAccountType() ==
                                      "admin"
                                  ? vehicleBloc.searchVehicleDetails(
                                      registrationNumber: searchController.text,
                                      centerId: selectedCenterIdForAdmin!)
                                  : vehicleBloc.searchVehicleDetails(
                                      registrationNumber: searchController.text,
                                      centerId: ObjectFactory()
                                          .appHive
                                          .getCenterId());
                              searchController.clear();
                              pop(context);
                            },
                          );
                        },
                      );
                    },
                    backgroundColor: AppColors.primaryColorBlue,
                    child: const BuildSvgIcon(
                      assetImagePath: AppAssets.searchIcon,
                      iconHeight: 22,
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Add vehicle
                  if (ObjectFactory().appHive.getAccountType() == "manager" ||
                      ObjectFactory().appHive.getAccountType() == "driver")
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90)),
                      onPressed: () {
                        push(context, const AddVehicleDetailsScreen()).then(
                          (_) async {
                            setState(() {
                              isFetchingTickets = true;
                            });
                            await vehicleBloc.getTickets(
                                centerId: currentCenterId!,
                                vehicleStatus: selectedVehicleStatus!);
                          },
                        );
                      },
                      backgroundColor: AppColors.primaryColorBlue,
                      child: BuildSvgIcon(
                        assetImagePath: AppAssets.scanIcon,
                        iconHeight: 30,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
