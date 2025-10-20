import 'package:bops_mobile/src/bloc/managers_bloc.dart';
import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/screens/manager_screens/add_managers_screen.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_managers_list_item_card_widget.dart';
import 'package:bops_mobile/src/widgets/build_suspend_action_alert_widget.dart.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon_button.dart';
import 'package:flutter/material.dart';

class SuspendedManagersListingScreen extends StatefulWidget {
  const SuspendedManagersListingScreen({super.key});

  @override
  State<SuspendedManagersListingScreen> createState() =>
      _SuspendedManagersListingScreenState();
}

class _SuspendedManagersListingScreenState
    extends State<SuspendedManagersListingScreen> {
  ManagersBloc managersBloc = ManagersBloc();
  List<ManagerResponseModel> suspendedManagers = [];
  bool isLoadingManagers = true;
  bool isUpdatingSuspendStatus = false;

  @override
  void initState() {
    managersBloc.fetchManagers(isSuspended: true);
    managersBloc.fetchManagersListener.listen((event) {
      print("NO OF SUSPENDED MANAGERS: ${event.length}");
      setState(() {
        suspendedManagers = event;
        isLoadingManagers = false;
      });
    }, onError: (error) {
      setState(() {
        isLoadingManagers = false;
      });
       AppToasts.showErrorToastTop(
          context, "Fetching suspended failed, Please try again");
    });
    managersBloc.updateSuspendStatusListener.listen((event) {
      print("SUSPEND ACTION RESULT: $event");
      setState(() {
        isUpdatingSuspendStatus = false;
      });
      AppToasts.showSuccessToastTop(context, "Manager unsuspended successfully!");
      Navigator.pop(context, true);
    }, onError: (error) {
      setState(() {
        isUpdatingSuspendStatus = false;
      });
       AppToasts.showErrorToastTop(
          context, "Unsuspending manager failed, Please try again");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
           Navigator.pop(context, true);
        },
        appBarTitle: "Suspended Managers",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: (isLoadingManagers || isUpdatingSuspendStatus)
          ? BuildLottieLoadingWidget(
              lottieHeight: screenHeight(context, dividedBy: 6),
              lottieWidth: screenHeight(context, dividedBy: 6),
            )
          : suspendedManagers.isEmpty
              ? Center(
                  child: Text(
                    "You haven't suspended any managers!",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                )
              : ListView.builder(
              itemCount: suspendedManagers.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (BuildContext context, int index) {
                return BuildManagersListItemCardWidget(
                  isSuspended: true,
                  name: suspendedManagers[index].managerName!,
                  email: suspendedManagers[index].managerEmail!,
                  address: suspendedManagers[index].managerAddress!,
                  phoneNumber: suspendedManagers[index].managerPhoneNumber!,
                  buttonText: "Unsuspend",
                  buttonBackgroundColor:
                      AppColors.primaryColorGreen.withOpacity(0.3),
                  buttonTextColor: AppColors.primaryColorGreen,
                  buttonOnTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BuildSuspendActionAlertWidget(
                            isSuspend: false,
                            titleName: suspendedManagers[index].managerName!,
                            isLoading:
                                isLoadingManagers || isUpdatingSuspendStatus,
                            firstButtonText: "Cancel",
                            secondButtonText: "UnSuspend",
                            onFirstButtonTap: () {
                              pop(context);
                            },
                            onSecondButtonTap: () async {
                              setState(() {
                                isUpdatingSuspendStatus = true;
                                // suspendedManagers.clear();
                              });
                              pop(context);
                              await managersBloc.updateSuspendStatus(
                                  managerId:
                                      suspendedManagers[index].managerId!);

                              await managersBloc.fetchManagers(
                                  isSuspended: true);
                            },
                          );
                        });
                  },
                  editButtonOnTap: (){},
                );
              }),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          push(context, const AddManagersScreen());
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
