import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/screens/center_screens/add_center_screen.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_center_listing_screen_heading_widget.dart';
import 'package:bops_mobile/src/widgets/build_center_listing_screen_item_widget.dart';
import 'package:bops_mobile/src/widgets/build_centers_listing_screen_action_alert_widget.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_lottie_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';

import '../../bloc/center_bloc.dart';

class CentersListingScreen extends StatefulWidget {
  const CentersListingScreen({super.key});

  @override
  State<CentersListingScreen> createState() => _CentersListingScreenState();
}

class _CentersListingScreenState extends State<CentersListingScreen> {
  bool isLoading = false;
  bool isDeleteLoading = false;
  late List<CenterResponseModel> centersList;
  CenterBloc centerBloc = CenterBloc();

  deleteCenter(String centerId, int index) {
    if (!isDeleteLoading) {
      setState(() {
        isDeleteLoading = true;
      });
      centerBloc.deleteCenter(centerId: centerId);
    }
  }

  getCenters() {
    setState(() {
      isLoading = true;
    });
    centerBloc.getCenters();
  }

  @override
  void initState() {
    getCenters();
    centerBloc.getCentersListener.listen((event) {
      centersList = event;
      setState(() {
        isLoading = false;
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      AppToasts.showErrorToastTop(
          context, "Fetching centers failed, Please try again");
    });

    centerBloc.deleteCenterListener.listen((event) {
      setState(() {
        isDeleteLoading = false;
      });

      AppToasts.showSuccessToastTop(context, "Center deleted successfully!");
      getCenters();
    }, onError: (error) {
      setState(() {
        isDeleteLoading = false;
      });
      AppToasts.showErrorToastTop(
          context, "Center deletion failed, Please try again");
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
        appBarTitle: "Centers",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Centers ",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const BuildCenterListingScreenHeadingWidget(),
            const SizedBox(height: 15),
            isLoading || isDeleteLoading
                ? const Expanded(child: BuildLottieLoadingWidget())
                : Expanded(
                    child: Container(
                      width: screenWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.dividerColor,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListView.builder(
                            itemCount: centersList.length,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemBuilder: (BuildContext context, int index) {
                              return BuildCenterListingScreenItemWidget(
                                isEvenItem: index % 2 == 0 ? true : false,
                                serialName: (index + 1).toString(),
                                centerName: centersList[index].centerName!,
                                editButtonTap: () {
                                  print("EDIT BUTTON PRESSED");
                                  pushAndReplacement(
                                      context,
                                      AddCenterScreen(
                                        isEdit: true,
                                        centerName:
                                            centersList[index].centerName,
                                        centerId: centersList[index].centerId,
                                      )).then((value) {
                                    if (value == true) {
                                      getCenters();
                                    }
                                  });
                                },
                                deleteButtonTap: () {
                                  print("DELETE BUTTON PRESSED");
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BuildCentersListingScreenActionAlertWidget(
                                          isLoading: false,
                                          firstButtonText: "Cancel",
                                          secondButtonText: "Delete",
                                          onFirstButtonTap: () {
                                            pop(context);
                                          },
                                          onSecondButtonTap: () async {
                                            pop(context);
                                            await deleteCenter(
                                                    centersList[index]
                                                        .centerId!,
                                                    index)
                                                .then((value) {
                                              if (value == true) {
                                                getCenters();
                                              }
                                            });
                                          },
                                        );
                                      });
                                },
                              );
                            }),
                      ),
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          print("ADD CENTER BUTTON PRESSED");
          push(context, AddCenterScreen()).then((value) {
            if (value == true) {
              getCenters();
            }
          });
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
