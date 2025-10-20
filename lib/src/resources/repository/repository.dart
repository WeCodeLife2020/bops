import 'package:bops_mobile/src/models/add_vehicle_request_model.dart';
import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/create_sheet_request_model.dart';
import 'package:bops_mobile/src/models/driver_response_model.dart';
import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/models/send_message_request_model.dart';
import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';
import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/resources/api_providers/sms_api_provider.dart';
import 'package:bops_mobile/src/resources/api_providers/user_api_provider.dart';
import 'package:bops_mobile/src/resources/firebase_providers/center_firebase_provider.dart';
import 'package:bops_mobile/src/resources/firebase_providers/driver_firebase_provider.dart';
import 'package:bops_mobile/src/resources/firebase_providers/manager_firebase_provider.dart';
import 'package:bops_mobile/src/resources/firebase_providers/profile_firebase_provider.dart';
import 'package:bops_mobile/src/resources/firebase_providers/user_firebase_provider.dart';
import 'package:bops_mobile/src/resources/firebase_providers/vehicles_firebase_provider.dart';

import '../../models/update_vehicle_status_request_model.dart';
import '../api_providers/vehicle_api_provider.dart';
import '../firebase_providers/sheet_firebase_provider.dart';

/// Repository is an intermediary class between network and data
class Repository {
  final userApiProvider = UserApiProvider();
  final userFirebaseProvider = UserFirebaseProvider();
  final profileFirebaseProvider = ProfileFirebaseProvider();
  final centerFirebaseProvider = CenterFirebaseProvider();
  final smsApiProvider = SmsApiProvider();
  final managerFirebaseProvider = ManagerFirebaseProvider();
  final vehicleApiProvider = VehicleApiProvider();
  final vehiclesFirebaseProvider = VehiclesFirebaseProvider();
  final sheetFirebaseProvider = SheetFirebaseProvider();
  final driverFirebaseProvider = DriverFirebaseProvider();

  /// login
  Future<State?> login() => userFirebaseProvider.login();

  /// sign out
  Future<State?> signOut() => userFirebaseProvider.signOut();

  /// add or update user data
  Future<State?> addOrUpdateUser(
          {required UserResponseModel userResponseModel}) =>
      profileFirebaseProvider.addOrUpdateUser(
        userResponseModel: userResponseModel,
      );

  /// clear fcm token
  Future<State?> clearFcmToken({required String userId}) =>
      profileFirebaseProvider.clearFcmToken(userId: userId);

  /// get phone number and address
  Future<State?> getPhoneAndAddress({required String userId}) =>
      profileFirebaseProvider.getPhoneAndAddress(userId: userId);

  /// update phone number and address
  Future<State?> updatePhoneAndAddress({
    required String userId,
    required String address,
    required String phoneNumber,
  }) =>
      profileFirebaseProvider.updatePhoneAndAddress(
        userId: userId,
        address: address,
        phoneNumber: phoneNumber,
      );

  /// get all users
  Future<State?> getAllUsers() => profileFirebaseProvider.getAllUsers();

  /// fetch one user data
  Future<State?> getUserData({required String userId}) =>
      profileFirebaseProvider.getUserData(userId: userId);

  /// Add manager
  Future<State?> addManager(
          {required ManagerResponseModel managerResponseModel}) =>
      managerFirebaseProvider.addManager(
          managerResponseModel: managerResponseModel);

  /// Fetch managers
  Future<State?> fetchManagers({required bool isSuspended}) =>
      managerFirebaseProvider.fetchManagers(isSuspended: isSuspended);

  /// update suspend status
  Future<State?> updateSuspendStatus({required String managerId}) =>
      managerFirebaseProvider.updateSuspendStatus(managerId: managerId);

  /// get suspend status
  Future<State?> getIsSuspended({required String userId}) =>
      managerFirebaseProvider.getIsSuspended(userId: userId);

  /// get center name
  Future<State?> getCenterName({required String userId}) =>
      managerFirebaseProvider.getCenterName(userId: userId);

  /// get center id
  Future<State?> getCenterId({required String userId}) =>
      managerFirebaseProvider.getCenterId(userId: userId);

  /// get manager Id
  Future<State?> getManagerId({required String userId}) =>
      managerFirebaseProvider.getManagerId(userId: userId);

  /// add center
  Future<State?> sendMessage(
          {required SendMessageRequestModel sendMessageRequestModel}) =>
      smsApiProvider.sendMessage(sendMessageRequestModel);

  /// add center
  Future<State?> addCenter(
          {required CenterResponseModel centerResponseModel}) =>
      centerFirebaseProvider.addCenter(
          centerResponseModel: centerResponseModel);

  Future<State?> getCenters() => centerFirebaseProvider.getCenters();

  Future<State?> deleteCenter({required centerId}) =>
      centerFirebaseProvider.deleteCenter(centerId: centerId);

  Future<State?> updateCenterName({required centerName, required centerId}) =>
      centerFirebaseProvider.updateCenterName(
          centerId: centerId, centerName: centerName);

  Future<State?> updateCenterDates({required centerId}) =>
      centerFirebaseProvider.updateCenterDates(centerId: centerId);

  Future<State?> getTokenNumber({required centerId}) =>
      centerFirebaseProvider.getTokenNumber(centerId: centerId);

  Future<State?> getSheetId({required centerId}) =>
      centerFirebaseProvider.getSheetId(centerId: centerId);

  Future<State?> getSheetCreatedDate({required centerId}) =>
      centerFirebaseProvider.getSheetCreatedDate(centerId: centerId);

  Future<State?> updateTokenNumber({required centerId}) =>
      centerFirebaseProvider.updateTokenNumber(centerId: centerId);

// add vehicle in sheet

  Future<State?> addVehicleToSheet(AddVehicleRequestModel addCarRequest) =>
      vehicleApiProvider.addVehicleToSheet(addCarRequest);

  /// update vehicle status

  Future<State?> updateVehicleStatus(
          UpdateVehicleStatusRequestModel updateVehicleStatusRequest) =>
      vehicleApiProvider.updateVehicleStatus(updateVehicleStatusRequest);

  ///create sheet

  Future<State?> createSheet(CreateSheetRequestModel createSheetRequest) =>
      vehicleApiProvider.createSheet(createSheetRequest);

  ///add vehicle details to firebase

  Future<State?> addVehicleDetailsToFirebase({
    required VehicleDetailsFirebaseResponseModel
        vehicleDetailsFirebaseResponseModel,
    // required int tokenNumber,
    // required int valetCarNumber,
  }) =>
      vehiclesFirebaseProvider.addVehicleDetailsToFirebase(
          // tokenNumber: tokenNumber,
          // valetCarNumber: valetCarNumber,
          vehicleDetailsFirebaseResponseModel:
              vehicleDetailsFirebaseResponseModel);

  ///fetch all tickets

  Future<State?> getTickets(
          {required String centerId, required String vehicleStatus}) =>
      vehiclesFirebaseProvider.getTickets(
          centerId: centerId, vehicleStatus: vehicleStatus);

  ///update ticket

  Future<State?> updateTicket(
          {required VehicleDetailsFirebaseResponseModel
              vehicleDetailsFirebaseResponseModel}) =>
      vehiclesFirebaseProvider.updateTicket(
          vehicleDetailsFirebaseResponseModel:
              vehicleDetailsFirebaseResponseModel);

  ///prefetch vehicle details

  Future<State?> prefetchCarDetails({required String registrationNumber}) =>
      vehiclesFirebaseProvider.prefetchVehicleDetails(
          registrationNumber: registrationNumber);

  Future<State?> searchVehicleDetails({
    String? registrationNumber,
    int? valetCarNumber,
    required String centerId,
  }) =>
      vehiclesFirebaseProvider.searchVehicleDetails(
        registrationNumber: registrationNumber,
        valetCarNumber: valetCarNumber,
        centerId: centerId,
      );

  Future<State?> updateCenterSheetId({required sheetId, required centerId}) =>
      centerFirebaseProvider.updateCenterSheetId(
          centerId: centerId, sheetId: sheetId);

  Future<State?> addSheetDetailsToFirebase(
          {required SheetDetailsFirebaseResponseModel
              sheetDetailsFirebaseResponseModel}) =>
      sheetFirebaseProvider.addSheetDetailsToFirebase(
          sheetDetailsFirebaseResponseModel: sheetDetailsFirebaseResponseModel);

  Future<State?> getSheetDetails({required centerId, required int limit}) =>
      sheetFirebaseProvider.getSheetDetails(centerId: centerId, limit: limit);

  Future<State?> getRequestedVehicleDetails(
          {required centerId, required int limit}) =>
      vehiclesFirebaseProvider.getRequestedVehicleDetails(
          centerId: centerId, limit: limit);

  Future<State?> addDriver(
          {required DriverResponseModel driverResponseModel}) =>
      driverFirebaseProvider.addDriver(
          driverResponseModel: driverResponseModel);

  Future<State?> getDrivers(
          {required bool isSuspended, required String centerId}) =>
      driverFirebaseProvider.getDrivers(
          isSuspended: isSuspended, centerId: centerId);

  Future<State?> updateDriverSuspendStatus(
          {required bool isSuspended, required String driverId}) =>
      driverFirebaseProvider.updateDriverSuspendStatus(
          driverId: driverId, isSuspended: isSuspended);

  Future<State?> getDriverCenterName({required String userId}) =>
      driverFirebaseProvider.getDriverCenterName(userId: userId);

  Future<State?> getDriverCenterId({required String userId}) =>
      driverFirebaseProvider.getDriverCenterId(userId: userId);

  Future<State?> getDriverId({required String userId}) =>
      driverFirebaseProvider.getDriverId(userId: userId);

  Future<State?> getDriverSuspendedStatus({required String userId}) =>
      driverFirebaseProvider.getDriverSuspendedStatus(userId: userId);

  Future<State?> updateDriverDetails(
          {required DriverResponseModel driverResponseModel}) =>
      driverFirebaseProvider.updateDriverDetails(
          driverResponseModel: driverResponseModel);

  Future<State?> updateManagerDetails(
          {required ManagerResponseModel managerResponseModel}) =>
      managerFirebaseProvider.updateManagerDetails(
          managerResponseModel: managerResponseModel);

  Future<State?> updateVehicleParkedLocation(
          {required String documentId, required String parkedLocation}) =>
      vehiclesFirebaseProvider.updateVehicleParkedLocation(
          documentId: documentId, parkedLocation: parkedLocation);
  Future<State?> getRequestedUsers() =>
      profileFirebaseProvider.getRequestedUsers();
  Future<State?> getPaymentCount({required String centerId}) =>
      vehiclesFirebaseProvider.getPaymentCount(centerId: centerId);
  Future<State?> getCenterNameByCenterId(
          {required String centerId,
          required String userId,
          required bool isManager}) =>
      centerFirebaseProvider.getCenterNameByCenterId(
          centerId: centerId, userId: userId, isManager: isManager);

  Future<State?> getIsDeleted({required String centerId}) =>
      centerFirebaseProvider.getIsDeleted(centerId: centerId);
}
