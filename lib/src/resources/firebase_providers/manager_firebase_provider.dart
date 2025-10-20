import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';

import '../../models/state.dart';

class ManagerFirebaseProvider {
  Future<State?> addManager(
      {required ManagerResponseModel managerResponseModel}) async {
    final dynamic result = await ObjectFactory()
        .firebaseClient
        .addManager(managerResponseModel: managerResponseModel);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Adding manager failed");
    }
  }

  Future<State?> fetchManagers({required bool isSuspended}) async {
    final dynamic result = await ObjectFactory()
        .firebaseClient
        .fetchManagers(isSuspended: isSuspended);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Fetching managers failed");
    }
  }

  Future<State?> updateSuspendStatus({required String managerId}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .updateSuspendStatus(managerId: managerId);
      return State.success("Suspend Status updation successfull");
    } catch (e) {
      return State.error("Suspend Status updation failed");
    }
  }

  Future<State?> getIsSuspended({required String userId}) async {
    try {
      bool result =await ObjectFactory()
          .firebaseClient
          .getIsSuspended(userId: userId);
      return State.success(result);
    } catch (e) {
      return State.error("Suspend Status updation failed");
    }
  }

Future<State?> getCenterName({required String userId}) async {
    try {
      String? result =
          await ObjectFactory().firebaseClient.getCenterName(userId: userId);

      return State.success(result);
    } catch (e) {
      return State.error("Fetching center name failed: $e");
    }
  }

  Future<State?> getCenterId({required String userId}) async {
    try {
      String? result =
          await ObjectFactory().firebaseClient.getCenterId(userId: userId);

      return State.success(result);
    } catch (e) {
      return State.error("Fetching center id failed: $e");
    }
  }

  Future<State?> getManagerId({required String userId}) async {
    try {
      String? result =
          await ObjectFactory().firebaseClient.getManagerId(userId: userId);

      return State.success(result);
    } catch (e) {
      return State.error("Fetching manager id failed: $e");
    }
  }

  Future<State?> updateManagerDetails({required ManagerResponseModel managerResponseModel}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .updateManagerDetails(managerResponseModel: managerResponseModel);
      return State.success("Manager details updated successfully");
    } catch (e) {
      return State.error("Manager details updated failed");
    }
  }
}
