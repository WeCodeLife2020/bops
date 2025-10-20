import 'dart:io';

import 'package:bops_mobile/src/bloc/center_bloc.dart';
import 'package:bops_mobile/src/bloc/sheet_bloc.dart';
import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/screens/report_screens/report_download_success_screen.dart';
import 'package:bops_mobile/src/services/firebase_services.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/font_family.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_curved_appbar_widget.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_report_screen_month_view_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/app_toasts.dart';
import '../../widgets/build_custom_dropdown_widget.dart';
import '../../widgets/build_loading_widget.dart';
import '../../widgets/build_lottie_loading_widget.dart';
import '../../widgets/build_report_screen_item_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime focusedDay = DateTime.now();
  ScrollController scrollController=ScrollController();
  DateTime? selectedDay;
  bool isLoading = true;
  bool isLoadingMore=false;
  int limit=15;
  bool isDownloadLoading=false;
  late List<CenterResponseModel> centers;
  List<String>centersList=[""];
  Map<String, String> centerIdMap = {};
  String?selectedCenter;
  String?selectedCenterId;
  bool isFirstData = true;

  bool isFetchCenters=false;
  SheetBloc sheetBloc = SheetBloc();
  CenterBloc centerBloc=CenterBloc();
  bool isAdmin=false;
   List<SheetDetailsFirebaseResponseModel>? sheetDetailsList;


  getSheetDetails(int limit) {
    print("this is center Id :$selectedCenterId");
    sheetBloc.getSheetDetails(centerId:isAdmin?selectedCenterId: ObjectFactory().appHive.getCenterId(),limit: limit);
  }


 checkIsAdmin(){
    isAdmin=ObjectFactory().appHive.getAccountType() == 'admin' ? true : false;
 }

  fetchCenters() async{
    setState(() {
     isFetchCenters=true;
    });
    await centerBloc.getCenters();
  }
  downloadSheet( String sheetId,String sheetName) {
    setState(
          () {
        isDownloadLoading = true;
      },
    );
    FileDownloader.downloadFile(
        url:
            'https://docs.google.com/spreadsheets/d/$sheetId/export?format=csv&gid=0',
        name: "$sheetName ${DateTime.now()}.csv",
        onDownloadCompleted: (path){
          setState(
                () {
              isDownloadLoading = false;
            },
          );
      push(context, ReportDownloadSuccessScreen());
    },
        // downloadDestination:DownloadDestinations.publicDownloads,
        onDownloadError: (error) {
          setState(
                () {
              isDownloadLoading = false;
            },
          );
          AppToasts.showErrorToastTop(context, "error to download $error");
        });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIsAdmin();
    fetchCenters();
    scrollController.addListener((){
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent&&!isLoadingMore ){
        print('it work');
        setState(() {
          isLoadingMore=true;
          limit+=15;
        });
        getSheetDetails(limit);
      }
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
        isFetchCenters=false;
      });
      getSheetDetails(limit);
    });

    // getSheetDetails();
    sheetBloc.getSheetDetailsListener.listen((event) {
      sheetDetailsList = event;
      setState(
        () {
          isLoading = false;
          isLoadingMore=false;
        },
      );
    }, onError: (error) {
      setState(
        () {
          isLoading = false;
          isLoadingMore=false;
        },
      );
    });
    requestStoregePermission();
    print(sheetDetailsList?.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeScaffoldColor,
      appBar: BuildCurvedAppbarWidget(
        backButtonOnTap: () {
          pop(context);
        },
        appBarTitle: " Reports",
        appBarHeight: screenHeight(context, dividedBy: 9),
      ),
      body: isLoading||isDownloadLoading||isFetchCenters
          ? const BuildLottieLoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // BuildReportScreenMonthViewWidget(monthName: 'March'),
                  // SizedBox(height: 20,),
                 if(isAdmin)...[
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
                          getSheetDetails(limit);
                        }
                      });
                    },
                  ),
                  ],
                  Expanded(
                    child: sheetDetailsList==null?Center(child: Text("no sheet Found"),): ListView.builder(
                      itemCount: sheetDetailsList?.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return BuildReportScreenItemWidget(
                              sheetDetailsList: sheetDetailsList![index],
                              isWithMonthHeading: true,
                              onPress: (){
                                downloadSheet(sheetDetailsList![index].sheetId,sheetDetailsList![index].sheetName );
                              },
                              monthName: DateFormat.MMMM().format(
                                  sheetDetailsList![0]
                                      .sheetCreatedDate!
                                      .toDate()));
                        }
                        else if (DateFormat.MMMM().format(
                                sheetDetailsList![index]
                                    .sheetCreatedDate!
                                    .toDate()) ==
                            DateFormat.MMMM().format(
                                sheetDetailsList![index - 1]
                                    .sheetCreatedDate!
                                    .toDate())) {
                          return BuildReportScreenItemWidget(
                            sheetDetailsList: sheetDetailsList![index],onPress: (){
                            downloadSheet(sheetDetailsList![index].sheetId,sheetDetailsList![index].sheetName );
                          },
                          );
                        }
                        else {
                          return BuildReportScreenItemWidget(
                              sheetDetailsList: sheetDetailsList![index],
                              isWithMonthHeading: true,
                              onPress: (){
                              downloadSheet(sheetDetailsList![index].sheetId,sheetDetailsList![index].sheetName );
                              },
                              monthName: DateFormat.MMMM().format(
                                  sheetDetailsList![index]
                                      .sheetCreatedDate!
                                      .toDate()));
                        }
                      },
                    ),
                  ),
                  isLoadingMore?const BuildLoadingWidget(
                      color: AppColors.primaryColorBlue):SizedBox()
                ],
              ),
            ),
    );
  }
}
