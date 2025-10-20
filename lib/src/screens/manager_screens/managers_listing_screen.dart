import 'package:bops_mobile/src/bloc/managers_bloc.dart';
import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/screens/manager_screens/add_managers_screen.dart';
import 'package:bops_mobile/src/screens/manager_screens/suspended_managers_listing_screen.dart';
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

class ManagersListingScreen extends StatefulWidget {
  const ManagersListingScreen({super.key});

  @override
  State<ManagersListingScreen> createState() => _ManagersListingScreenState();
}

class _ManagersListingScreenState extends State<ManagersListingScreen> {
  ManagersBloc managersBloc = ManagersBloc();
  List<ManagerResponseModel> managers = [];
  bool isLoadingManagers = true;
  bool isUpdatingSuspendStatus = false;
getManagers()async{
  await managersBloc.fetchManagers(isSuspended: false);
}
  @override
  void initState() {
    managersBloc.fetchManagers(isSuspended: false);
    managersBloc.fetchManagersListener.listen((event) {
      print("NO OF UNSUSPENDED MANAGERS: ${event.length}");
      setState(() {
        managers = event;
        isLoadingManagers = false;
      });
    }, onError: (error) {
      setState(() {
        isLoadingManagers = false;
      });
      AppToasts.showErrorToastTop(context, "Fetching managers failed!");
    });
    managersBloc.updateSuspendStatusListener.listen((event) {
      print("SUSPEND ACTION RESULT: $event");
      setState(() {
        isUpdatingSuspendStatus = false;
      });
      AppToasts.showSuccessToastTop(context, "Manager suspended successfully!");
    }, onError: (error) {
      setState(() {
        isUpdatingSuspendStatus = false;
      });
      AppToasts.showErrorToastTop(
          context, "Manager suspension failed, Please try");
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
        appBarTitle: "Managers",
        appBarHeight: screenHeight(context, dividedBy: 9),
        actions: [
          BuildSvgIconButton(
            assetImagePath: AppAssets.suspendedManagersIcon,
            iconHeight: 40,
            onTap: () {
              push(context, SuspendedManagersListingScreen()).then(
                (value) async {
                  // print("VALUE: $value");
                  if (value) {
                    setState(() {
                      isLoadingManagers = true;
                    });
                    await managersBloc.fetchManagers(isSuspended: false);
                  }
                },
              );
            },
          )
        ],
      ),
      body: (isLoadingManagers || isUpdatingSuspendStatus)
          ? BuildLottieLoadingWidget(
              lottieHeight: screenHeight(context, dividedBy: 6),
              lottieWidth: screenHeight(context, dividedBy: 6),
            )
          : managers.isEmpty
              ? Center(
                  child: Text(
                    "You haven't added any managers!",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                )
              : ListView.builder(
                  itemCount: managers.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (BuildContext context, int index) {
                    return BuildManagersListItemCardWidget(
                      isSuspended: managers[index].isSuspended!,
                      name: managers[index].managerName!,
                      email: managers[index].managerEmail!,
                      address: managers[index].managerAddress!,
                      phoneNumber: managers[index].managerPhoneNumber!,
                      buttonText: "Suspend",
                      buttonBackgroundColor:
                          AppColors.primaryColorRed.withOpacity(0.3),
                      buttonTextColor: AppColors.primaryColorRed,
                      buttonOnTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BuildSuspendActionAlertWidget(
                                  isSuspend: true,
                                  titleName: managers[index].managerName!,
                                  isLoading: isUpdatingSuspendStatus,
                                  firstButtonText: "Cancel",
                                  secondButtonText: "Suspend",
                                  onFirstButtonTap: () {
                                    pop(context);
                                  },
                                  onSecondButtonTap: () async {
                                    setState(() {
                                      isUpdatingSuspendStatus = true;
                                      // managers.clear();
                                    });
                                    pop(context);
                                    await managersBloc.updateSuspendStatus(
                                        managerId: managers[index].managerId!);

                                    await managersBloc.fetchManagers(
                                        isSuspended: false);
                                  });
                            });
                      },
                      editButtonOnTap: (){
                        push(context,  AddManagersScreen(isEdit: true,managerDetails: managers[index],)).then(
                              (value) async {
                            print("VALUE: $value");
                            if (value) {
                              setState(() {
                                isLoadingManagers = true;
                              });
                              getManagers();
                            }
                          },
                        );
                      },
                    );
                  }),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          push(context, const AddManagersScreen()).then(
            (value) async {
              // print("VALUE: $value");
              if (value) {
                setState(() {
                  isLoadingManagers = true;
                });
                await managersBloc.fetchManagers(isSuspended: false);
              }
            },
          );
          ;
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
