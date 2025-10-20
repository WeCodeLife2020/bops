import 'package:hive/hive.dart';

import 'constants.dart';

class AppHive {
  static const String _TOKEN = "token";
  static const String _EMAIL = "email";
  static const String _FCM_TOKEN = "fcmToken";
  static const String _NAME = "name";
  static const String _USER_ID = "userId";
  static const String _PROFILEPIC = "profilePicture";
  static const String _IS_LOGGED_IN = "isLoggedIn";
  static const String _PHONE_NUMBER = "phoneNumber";
  static const String _ADDRESS = "address";
  static const String _IS_MANAGER = "isManager";
  static const String _IS_SUPER_USER = "isSuperUser";
  static const String _ACCOUNT_TYPE = "accountType";
  static const String _IS_SUSPENDED = "isSuspended";
  static const String _CENTER_NAME = "centerName";
  static const String _CENTER_ID = "centerId";
  static const String _MANAGER_ID = "managerId";
  static const String _SHEET_CREATE_DATE = "sheetCreateDate";
  static const String _SHEET_ID = "sheetId";
  static const String _IS_STORAGE_PERMISSION_ENABLED =
      "isStoragePermissionEnabled";
  static const String _DRIVER_ID = "driverId";
  static const String _IS_DELETED = "isDeleted";
  static const String _IS_NOTIFICATION_ENABLED = "isNotificationEnabled";

  void hivePut({String? key, String? value}) async {
    await Hive.box(Constants.BOX_NAME).put(key, value);
  }

  String hiveGet({String? key}) {
    // openBox();
    return Hive.box(Constants.BOX_NAME).get(key) ?? " ";
  }

  void hivePutBool({String? key, bool? value}) async {
    await Hive.box(Constants.BOX_NAME).put(key, value);
  }

  bool hiveGetBool({String? key}) {
    return Hive.box(Constants.BOX_NAME).get(key) ?? false;
  }

  putToken({String? token}) {
    hivePut(key: _TOKEN, value: token);
  }

  String getToken() {
    return hiveGet(key: _TOKEN);
  }

  putEmail({String? email}) {
    return hivePut(key: _EMAIL, value: email);
  }

  String getEmail() {
    return hiveGet(key: _EMAIL);
  }

  putFcmToken({String? fcmToken}) {
    return hivePut(key: _FCM_TOKEN, value: fcmToken);
  }

  String getFcmToken() {
    return hiveGet(key: _FCM_TOKEN);
  }

  putUserPhoneNumber({String? phoneNumber}) {
    return hivePut(key: _PHONE_NUMBER, value: phoneNumber);
  }

  String getUserPhoneNumber() {
    return hiveGet(key: _PHONE_NUMBER);
  }

  putUserAddress({String? address}) {
    return hivePut(key: _ADDRESS, value: address);
  }

  String getUserAddress() {
    return hiveGet(key: _ADDRESS);
  }

  putName({String? name}) {
    return hivePut(key: _NAME, value: name);
  }

  String getName() {
    return hiveGet(key: _NAME);
  }

  putUserId({String? userId}) {
    hivePut(key: _USER_ID, value: userId);
  }

  String getUserId() {
    return hiveGet(key: _USER_ID);
  }

  putIsSuspended({bool? isSuspended}) {
    hivePutBool(key: _IS_SUSPENDED, value: isSuspended);
  }

  bool getIsSuspended() {
    return hiveGetBool(key: _IS_SUSPENDED);
  }

  putIsDeleted({bool? isDeleted}) {
    hivePutBool(key: _IS_DELETED, value: isDeleted);
  }

  bool getIsDeleted() {
    return hiveGetBool(key: _IS_DELETED);
  }

  putProfilePic({String? profilePic}) {
    hivePut(key: _PROFILEPIC, value: profilePic);
  }

  String getProfilePic() {
    return hiveGet(key: _PROFILEPIC);
  }

  putAccountType({String? accountType}) {
    hivePut(key: _ACCOUNT_TYPE, value: accountType);
  }

  String getAccountType() {
    return hiveGet(key: _ACCOUNT_TYPE);
  }

  putCenterName({String? centerName}) {
    hivePut(key: _CENTER_NAME, value: centerName);
  }

  String getCenterName() {
    return hiveGet(key: _CENTER_NAME);
  }

  putCenterId({String? centerId}) {
    hivePut(key: _CENTER_ID, value: centerId);
  }

  String getCenterId() {
    return hiveGet(key: _CENTER_ID);
  }

  putManagerId({String? managerId}) {
    hivePut(key: _MANAGER_ID, value: managerId);
  }

  String getManagerId() {
    return hiveGet(key: _MANAGER_ID);
  }

  putDriverId({String? driverId}) {
    hivePut(key: _DRIVER_ID, value: driverId);
  }

  String getDriverId() {
    return hiveGet(key: _DRIVER_ID);
  }

  putSheetId({String? sheetId}) {
    hivePut(key: _SHEET_ID, value: sheetId);
  }

  String getSheetId() {
    return hiveGet(key: _SHEET_ID);
  }

  putSheetCreatedDate({String? createdDate}) {
    hivePut(key: _SHEET_CREATE_DATE, value: createdDate);
  }

  String getSheetCreatedDate() {
    return hiveGet(key: _SHEET_CREATE_DATE);
  }

  putIsLoggedIn({bool? isLoggedIn}) {
    hivePutBool(key: _IS_LOGGED_IN, value: isLoggedIn);
  }

  bool getIsLoggedIn() {
    return hiveGetBool(key: _IS_LOGGED_IN);
  }

  putIsNotificationPermission({bool? isNotificationPermission}) {
    hivePutBool(key: _IS_NOTIFICATION_ENABLED, value: isNotificationPermission);
  }

  bool getIsNotificationPermission() {
    return hiveGetBool(key: _IS_NOTIFICATION_ENABLED);
  }

  putIsManager({bool? isManager}) {
    hivePutBool(key: _IS_MANAGER, value: isManager);
  }

  bool getIsManager() {
    return hiveGetBool(key: _IS_MANAGER);
  }

  putIsSuperUser({bool? isSuperUser}) {
    hivePutBool(key: _IS_SUPER_USER, value: isSuperUser);
  }

  bool getIsSuperUser() {
    return hiveGetBool(key: _IS_SUPER_USER);
  }

  putStoragePermissionStatus({bool? isStoragePermissionEnabled}) {
    hivePutBool(
        key: _IS_STORAGE_PERMISSION_ENABLED, value: isStoragePermissionEnabled);
  }

  bool getStoragePermissionStatus() {
    return hiveGetBool(key: _IS_STORAGE_PERMISSION_ENABLED);
  }

  clearBox() {
    Hive.box(Constants.BOX_NAME).clear();
  }

  AppHive();
}
