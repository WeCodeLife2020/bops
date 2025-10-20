import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/driver_response_model.dart';
import '../models/manager_response_model.dart';

class FirebaseClient {
  /// Login
  Future<UserCredential?> login() {
    return FirebaseServices().signInWithGoogle();
  }

  /// Log-Out
  Future<void> signOut() {
    return FirebaseServices().signOut();
  }

  /// Create or Update user
  Future<DocumentReference?> addOrUpdateUser(
      {required UserResponseModel userResponseModel}) {
    return FirebaseServices()
        .addOrUpdateUser(userResponseModel: userResponseModel);
  }

  /// get phone number and address
  Future<Map<String, dynamic>?> getPhoneAndAddress({required String userId}) {
    return FirebaseServices().getPhoneAndAddress(userId: userId);
  }

  /// update phone number and address
  Future<DocumentReference?> updatePhoneAndAddress({
    required String userId,
    required String address,
    required String phoneNumber,
  }) {
    return FirebaseServices().updatePhoneAndAddress(
      userId: userId,
      address: address,
      phoneNumber: phoneNumber,
    );
  }

  /// fetch all users
  Future<List<UserResponseModel>> getAllUsers() {
    return FirebaseServices().getAllUsers();
  }

  /// fetch user data
  Future<UserResponseModel?> getUserData({required String userId}) {
    return FirebaseServices().getUserData(userId: userId);
  }

  /// Create or Update user
  Future<DocumentReference?> clearFcmToken({required String userId}) {
    return FirebaseServices().clearFcmToken(userId: userId);
  }

  /// Add manager
  Future<DocumentReference?> addManager(
      {required ManagerResponseModel managerResponseModel}) {
    return FirebaseServices()
        .addManager(managerResponseModel: managerResponseModel);
  }

  /// Fetch managers
  Future<List<ManagerResponseModel>> fetchManagers(
      {required bool isSuspended}) {
    return FirebaseServices().fetchManagers(isSuspended: isSuspended);
  }

  /// update suspend status
  Future<void> updateSuspendStatus({required String managerId}) {
    return FirebaseServices().updateSuspendStatus(managerId: managerId);
  }

  /// update suspend status
  Future<bool> getIsSuspended({required String userId}) {
    return FirebaseServices().getIsSuspended(userId: userId);
  }

  /// get center name
  Future<String?> getCenterName({required String userId}) {
    return FirebaseServices().getCenterName(userId: userId);
  }

  /// get center id
  Future<String?> getCenterId({required String userId}) {
    return FirebaseServices().getCenterId(userId: userId);
  }

  /// get manager id
  Future<String?> getManagerId({required String userId}) {
    return FirebaseServices().getManagerId(userId: userId);
  }

  // center add
  Future<String?> addCenter(
      {required CenterResponseModel centerResponseModel}) {
    return FirebaseServices()
        .addCenter(centerResponseModel: centerResponseModel);
  }

  Future<List<CenterResponseModel>> getCenters() {
    return FirebaseServices().getCenters();
  }

  Future<void> deleteCenter({required centerId}) {
    return FirebaseServices().deleteCenter(centerId: centerId);
  }

  Future<void> updateCenterName({required centerId, required centerName}) {
    return FirebaseServices()
        .updateCenterName(centerId: centerId, centerName: centerName);
  }

  Future<void> updateCenterDates({required centerId}) {
    return FirebaseServices().updateCenterDates(centerId: centerId);
  }

  Future<int?> getTokenNumber({required centerId}) {
    return FirebaseServices().getTokenNumber(centerId: centerId);
  }

  Future<String?> getSheetId({required centerId}) {
    return FirebaseServices().getSheetId(centerId: centerId);
  }

  Future<DateTime?> getSheetCreatedDate({required centerId}) {
    return FirebaseServices().getSheetCreatedDate(centerId: centerId);
  }

  Future<int?> updateTokenNumber({required centerId}) {
    return FirebaseServices().updateTokenNumber(centerId: centerId);
  }

  /// Add manager
  Future<VehicleDetailsFirebaseResponseModel?> addVehicleDetailsToFirebase({
    required VehicleDetailsFirebaseResponseModel
        vehicleDetailsFirebaseResponseModel,
    // required int tokenNumber,
    // required int valetCarNumber,
  }) {
    return FirebaseServices().addVehicleDetailsToFirebase(
      vehicleDetailsFirebaseResponseModel: vehicleDetailsFirebaseResponseModel,
      // valetCarNumber: valetCarNumber,
      // tokenNumber: tokenNumber,
    );
  }

  /// get tickets
  Future<List<VehicleDetailsFirebaseResponseModel>?> getTickets(
      {required String centerId, required String vehicleStatus}) {
    return FirebaseServices()
        .getTickets(centerId: centerId, vehicleStatus: vehicleStatus);
  }

  /// update center sheet id
  Future<void> updateCenterSheetId({required centerId, required sheetId}) {
    return FirebaseServices()
        .updateCenterSheetId(centerId: centerId, sheetId: sheetId);
  }

  /// update ticket
  Future<bool?> updateTicket(
      {required VehicleDetailsFirebaseResponseModel
          vehicleDetailsFirebaseResponseModel}) {
    return FirebaseServices().updateTicket(
        vehicleDetailsFirebaseResponseModel:
            vehicleDetailsFirebaseResponseModel);
  }

  /// prefetch car details
  Future<VehicleDetailsFirebaseResponseModel?> prefetchCarDetails(
      {required String registrationNumber}) {
    return FirebaseServices()
        .prefetchCarDetails(registrationNumber: registrationNumber);
  }

  /// search vehicle details
  Future<VehicleDetailsFirebaseResponseModel?> searchVehicleDetails({
    String? registrationNumber,
    int? valetCarNumber,
    required String centerId,
  }) {
    return FirebaseServices().searchVehicleDetails(
      registrationNumber: registrationNumber,
      valetCarNumber: valetCarNumber,
      centerId: centerId,
    );
  }

  Future<void> addSheetDetailsToFirebase(
      {required SheetDetailsFirebaseResponseModel
          sheetDetailsFirebaseResponseModel}) {
    return FirebaseServices().addSheetDetailsToFirebase(
        sheetDetailsFirebaseResponseModel: sheetDetailsFirebaseResponseModel);
  }

  Future<List<SheetDetailsFirebaseResponseModel>?> getSheetDetails(
      {required centerId, required int limit}) {
    return FirebaseServices().getSheetDetails(centerId: centerId, limit: limit);
  }

  Future<List<VehicleDetailsFirebaseResponseModel>?> getRequestedVehicleDetails(
      {required centerId, required int limit}) {
    return FirebaseServices()
        .getRequestedVehicleDetails(centerId: centerId, limit: limit);
  }

  Future<DocumentReference?> addDriver(
      {required DriverResponseModel driverResponseModel}) {
    return FirebaseServices()
        .addDriver(driverResponseModel: driverResponseModel);
  }

  Future<List<DriverResponseModel>?> getDrivers(
      {required isSuspended, required String centerId}) {
    return FirebaseServices()
        .getDrivers(isSuspended: isSuspended, centerId: centerId);
  }

  /// update driver suspend status
  Future<void> updateDriversSuspendStatus(
      {required String driverId, required bool isSuspended}) {
    return FirebaseServices().updatedDriverSuspendStatus(
        driverId: driverId, isSuspended: isSuspended);
  }

  Future<String?> getDriverCenterName({required String userId}) {
    return FirebaseServices().getDriverCenterName(userId: userId);
  }

  Future<String?> getDriverCenterId({required String userId}) {
    return FirebaseServices().getDriverCenterId(userId: userId);
  }

  Future<String?> getDriverId({required String userId}) {
    return FirebaseServices().getDriverId(userId: userId);
  }

  Future<bool> getDriverSuspendedStatus({required String userId}) {
    return FirebaseServices().getDriverSuspendedStatus(userId: userId);
  }

  Future<void> updateDriverDetails(
      {required DriverResponseModel driverResponseModel}) {
    return FirebaseServices()
        .updateDriverDetails(driverResponseModel: driverResponseModel);
  }

  Future<void> updateManagerDetails(
      {required ManagerResponseModel managerResponseModel}) {
    return FirebaseServices()
        .updateManagerDetails(managerResponseModel: managerResponseModel);
  }

  Future<void> updateVehicleParkedLocation(
      {required String documentId, required String parkedLocation}) {
    return FirebaseServices().updateVehicleParkedLocation(
        documentId: documentId, parkedLocation: parkedLocation);
  }

  Future<List<UserResponseModel>> getRequestedUsers() {
    return FirebaseServices().getRequestedUsers();
  }

  Future<List<dynamic>> getPaymentCount({required String centerId}) {
    return FirebaseServices().getPaymentCount(centerId: centerId);
  }

  Future<String?> getCenterNameByCenterId(
      {required String centerId,
      required String userId,
      required bool isManager}) {
    return FirebaseServices().getCenterNameByCenterId(
        centerId: centerId, userId: userId, isManager: isManager);
  }

  Future<bool?> getIsDeleted({required String centerId}) {
    return FirebaseServices().getIsDeleted(centerId: centerId);
  }
}
