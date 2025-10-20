import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';

import '../../models/state.dart';

class ProfileFirebaseProvider {
  Future<State?> addOrUpdateUser(
      {required UserResponseModel userResponseModel}) async {
    final dynamic result = await ObjectFactory()
        .firebaseClient
        .addOrUpdateUser(userResponseModel: userResponseModel);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("USER ADDITION OR UPDATION FAILED");
    }
  }

  Future<State?> clearFcmToken({required String userId}) async {
    final dynamic result =
        await ObjectFactory().firebaseClient.clearFcmToken(userId: userId);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Clearing FCM token failed");
    }
  }

  Future<State?> getPhoneAndAddress({required String userId}) async {
    final dynamic result =
        await ObjectFactory().firebaseClient.getPhoneAndAddress(userId: userId);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Fetching phone number and address failed");
    }
  }

  Future<State?> updatePhoneAndAddress({
    required String userId,
    required String address,
    required String phoneNumber,
  }) async {
    final dynamic result =
        await ObjectFactory().firebaseClient.updatePhoneAndAddress(
              userId: userId,
              address: address,
              phoneNumber: phoneNumber,
            );

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Updating phone number and address failed");
    }
  }



  Future<State?> getAllUsers() async {
    final dynamic result =
        await ObjectFactory().firebaseClient.getAllUsers();

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Fetching users failed");
    }
  }

  Future<State?> getUserData({required String userId}) async {
    final dynamic result = await ObjectFactory().firebaseClient.getUserData(userId: userId);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Fetching user data failed");
    }
  }


  Future<State?> getRequestedUsers() async {
    final dynamic result =
    await ObjectFactory().firebaseClient.getRequestedUsers();

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Fetching users failed");
    }
  }
}
