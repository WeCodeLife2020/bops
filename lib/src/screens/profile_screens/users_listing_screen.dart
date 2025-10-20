import 'package:bops_mobile/src/bloc/profile_bloc.dart';
import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_managers_list_item_card_widget.dart';
import 'package:bops_mobile/src/widgets/build_users_list_widget.dart';
import 'package:flutter/material.dart';

class UsersListingScreen extends StatefulWidget {
  const UsersListingScreen({super.key});

  @override
  State<UsersListingScreen> createState() => _UsersListingScreenState();
}

class _UsersListingScreenState extends State<UsersListingScreen> {
  ProfileBloc profileBloc = ProfileBloc();
  bool isFetchingUsers = true;
  List<UserResponseModel> users = [];

  @override
  void initState() {
    profileBloc.getAllUsers();
    profileBloc.getAllUsersListener.listen((event) {
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

  @override
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
          : ListView.builder(
              itemCount: users.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (BuildContext context, int index) {
                return BuildUsersListWidget(
                  name: users[index].userName!,
                  email: users[index].userEmail!,
                  phoneNumber: users[index].userPhoneNumber!,
                  address: users[index].userAddress!,
                  accountType: users[index].accountType!,
                );
              }),
    );
  }
}
