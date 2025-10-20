import 'package:flutter/material.dart';

import '../../bloc/profile_bloc.dart';
import '../../models/driver_response_model.dart';
import '../../models/manager_response_model.dart';
import '../../models/user_response_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_toasts.dart';
import '../../utils/utils.dart';
import '../../widgets/build_curved_appbar_widget.dart';
import '../../widgets/build_lottie_loading_widget.dart';
import '../../widgets/build_requested_users_list_widget.dart';
import '../../widgets/build_users_list_widget.dart';
import '../driver_screens/add_drivers_screen.dart';
import '../manager_screens/add_managers_screen.dart';

class RequestedUsersListingScreen extends StatefulWidget {
  const RequestedUsersListingScreen({super.key});

  @override
  State<RequestedUsersListingScreen> createState() =>
      _RequestedUsersListingScreenState();
}

class _RequestedUsersListingScreenState
    extends State<RequestedUsersListingScreen> {
  ProfileBloc profileBloc = ProfileBloc();
  bool isFetchingUsers = true;
  List<UserResponseModel> users = [];
  getRequestedUsers() async {
    setState(() {
      isFetchingUsers = true;
    });
    await profileBloc.getRequestedUsers();
  }

  @override
  void initState() {
    getRequestedUsers();
    profileBloc.getRequestedUsersListener.listen((event) {
      print("USERS LIST COUNT: ${event.length}");
      setState(() {
        users = event;
        isFetchingUsers = false;
      });
    }, onError: (error) {
      setState(() {
        isFetchingUsers = false;
      });
      AppToasts.showErrorToastTop(
          context, "Fetching users failed, Please try again");
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          pop(context);
        },
        appBarTitle: "Users",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: isFetchingUsers
          ? const BuildLottieLoadingWidget()
          : users.length == 0
              ? Center(
                  child: Text("No Requested User Found"),
                )
              : ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (BuildContext context, int index) {
                    return BuildRequestedUsersListWidget(
                      name: users[index].userName!,
                      email: users[index].userEmail!,
                      // phoneNumber: users[index].userPhoneNumber!,
                      // address: users[index].userAddress!,
                      accountType: users[index].accountType!,
                      popupFirstTitle: "promoted as manager",
                      popupSecondTitle: "promoted as driver",
                      popupOnPress: (value) {
                        value == 1
                            ? push(
                                context,
                                AddManagersScreen(
                                  managerDetails: ManagerResponseModel(
                                    managerEmail: users[index].userEmail!,
                                    managerName: users[index].userName!,
                                  ),
                                )).then(
                                (value) async {
                              getRequestedUsers();
                            })
                            : push(
                                context,
                                AddDriversScreen(
                                  driverDetails: DriverResponseModel(
                                    driverEmail: users[index].userEmail!,
                                    driverName: users[index].userName!,
                                  ),
                                )).then(
    (value) async {
      getRequestedUsers();
    });
                      },
                    );
                  }),
    );
  }
}
