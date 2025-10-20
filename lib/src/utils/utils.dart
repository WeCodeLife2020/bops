import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/widgets/cancel_alert_box.dart';
import 'package:bops_mobile/src/widgets/otp_message.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

///it contain common functions
class Utils {}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}

Future<dynamic> push(BuildContext context, Widget route) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => route));
}

void pop(BuildContext context) {
  return Navigator.pop(context);
}

Future<dynamic> pushAndRemoveUntil(
    BuildContext context, Widget route, bool goBack) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => route), (route) => goBack);
}

Future<dynamic> pushAndReplacement(BuildContext context, Widget route) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => route));
}

void cancelAlertBox(
    {context,
    msg,
    text1,
    text2,
    route,
    double? insetPadding,
    double? contentPadding,
    double? titlePadding}) {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return CancelAlertBox(
          title: msg,
          text1: text1,
          text2: text2,
          route: route,
          contentPadding: contentPadding!,
          titlePadding: titlePadding!,
          insetPadding: insetPadding!,
        );
      });
}

void showAlert(context, String msg) {
  // flutter defined function
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
      return PopScope(
        canPop: false,
        child: SizedBox(
          height: 150,
          child: AlertDialog(
            backgroundColor: AppColors.whiteTextColor,
            title: Text(
              "Update",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.primaryColorBlue),
            ),
            content: Text(
              msg,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: AppColors.primaryColor),
            ),
            //        content: new Text("Alert Dialog body"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
            ],
          ),
        ),
      );
    },
  );
}

void otpAlertBox({context, title, route, stayOnPage}) {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return OtpMessage(
          title: title,
          route: route,
          stayOnPage: stayOnPage,
        );
      });
}

Future<void> requestStoregePermission() async {
  print('requsting');
  await Permission.storage.request();
  await Permission.storage.isGranted
      ? ObjectFactory()
          .appHive
          .putStoragePermissionStatus(isStoragePermissionEnabled: true)
      : ObjectFactory()
          .appHive
          .putStoragePermissionStatus(isStoragePermissionEnabled: false);
  print('requesting');
  await Permission.storage.request();
}

//clear cache
Future<void> clearCache() async {
  final tempDir = await getTemporaryDirectory();
  final files = tempDir.listSync(recursive: true);
  if (tempDir.existsSync()) {
    tempDir.deleteSync(recursive: true);
  }
  // final files = tempDir.listSync(recursive: true);
  if (files.isEmpty) {
    print('✅ Cache directory is empty.');
  } else {
    print('⚠️ Cache directory still has ${files.length} files.');
    for (var f in files) {
      print(' - ${f.path}');
    }
  }
}