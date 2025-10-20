import 'package:bops_mobile/src/models/driver_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';

import '../../utils/object_factory.dart';

class DriverFirebaseProvider {
  Future<State?> addDriver(
      {required DriverResponseModel driverResponseModel}) async {
    final dynamic result = await ObjectFactory()
        .firebaseClient
        .addDriver(driverResponseModel: driverResponseModel);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Adding Driver failed");
    }
  }


  Future<State?> getDrivers(
      {required bool isSuspended,required String centerId}) async {
    final dynamic result = await ObjectFactory()
        .firebaseClient
        .getDrivers(isSuspended: isSuspended,centerId: centerId);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Getting Driver failed");
    }
  }

  Future<State?> updateDriverSuspendStatus({required String driverId,required bool isSuspended}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .updateDriversSuspendStatus(driverId: driverId, isSuspended: isSuspended);
      return State.success("Suspend Status updated successfully");
    } catch (e) {
      return State.error("Suspend Status updated failed");
    }
  }

  Future<State?> getDriverCenterName({required String userId}) async {
    try {
      String? result =
      await ObjectFactory().firebaseClient.getDriverCenterName(userId: userId);

      return State.success(result);
    } catch (e) {
      return State.error("Fetching center name failed: $e");
    }
  }
  Future<State?> getDriverCenterId({required String userId}) async {
    try {
      String? result =
      await ObjectFactory().firebaseClient.getDriverCenterId(userId: userId);

      return State.success(result);
    } catch (e) {
      return State.error("Fetching center id failed: $e");
    }
  }
  Future<State?> getDriverId({required String userId}) async {
    try {
      String? result =
      await ObjectFactory().firebaseClient.getDriverId(userId: userId);

      return State.success(result);
    } catch (e) {
      return State.error("Fetching center id failed: $e");
    }
  }
  Future<State?> getDriverSuspendedStatus({required String userId}) async {
    try {
      bool result =await ObjectFactory()
          .firebaseClient
          .getDriverSuspendedStatus(userId: userId);
      return State.success(result);
    } catch (e) {
      return State.error("Suspend Status updation failed");
    }
  }
  Future<State?> updateDriverDetails({required DriverResponseModel driverResponseModel}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .updateDriverDetails(driverResponseModel: driverResponseModel);
      return State.success("Driver details updated successfully");
    } catch (e) {
      return State.error("Driver details updated failed");
    }
  }
}