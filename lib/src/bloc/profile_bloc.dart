import 'dart:async';

import 'package:bops_mobile/src/bloc/base_bloc.dart';
import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/utils/constants.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/validators.dart';

import '../models/state.dart';

class ProfileBloc extends Object with Validators implements BaseBloc {
  ///Conttrollers

  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<dynamic> _addOrUpdateUser =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _clearFcmToken =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getPhoneAndAddress =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _updatePhoneAndAddress =
      StreamController<dynamic>.broadcast();
  final StreamController<List<UserResponseModel>> _getAllUsers =
      StreamController<List<UserResponseModel>>.broadcast();
  final StreamController<UserResponseModel> _getUserData= StreamController<UserResponseModel>.broadcast();
  final StreamController<List<UserResponseModel>> _getRequestedUsers =
  StreamController<List<UserResponseModel>>.broadcast();

  /// Stream

  Stream<bool> get loadingListener => _loading.stream;
  Stream<dynamic> get addOrUpdateUserListener => _addOrUpdateUser.stream;
  Stream<dynamic> get clearFcmTokenListener => _clearFcmToken.stream;
  Stream<dynamic> get getPhoneAndAddressListener => _getPhoneAndAddress.stream;
  Stream<dynamic> get updatePhoneAndAddressListener =>
      _updatePhoneAndAddress.stream;
  Stream<List<UserResponseModel>> get getAllUsersListener =>
      _getAllUsers.stream;
  Stream<UserResponseModel> get getUserDataListener =>
      _getUserData.stream;
  Stream<List<UserResponseModel>> get getRequestedUsersListener =>
      _getRequestedUsers.stream;
  /// Sink

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<dynamic> get addOrUpdateUserSink => _addOrUpdateUser.sink;
  StreamSink<dynamic> get clearFcmTokenSink => _clearFcmToken.sink;
  StreamSink<dynamic> get getPhoneAndAddressSink => _getPhoneAndAddress.sink;
  StreamSink<dynamic> get updatePhoneAndAddressSink =>
      _updatePhoneAndAddress.sink;
  StreamSink<List<UserResponseModel>> get getAllUsersSink =>
      _getAllUsers.sink;
  StreamSink<UserResponseModel> get getUserDataSink => _getUserData.sink;
  StreamSink<List<UserResponseModel>> get getRequestedUsersSink =>
      _getRequestedUsers.sink;

  /// Functions

  addOrUpdateUser({required UserResponseModel userResponseModel}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .addOrUpdateUser(userResponseModel: userResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      addOrUpdateUserSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      addOrUpdateUserSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  clearFcmToken({required String userId}) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.clearFcmToken(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      clearFcmTokenSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      clearFcmTokenSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getPhoneAndAddress({required String userId}) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.getPhoneAndAddress(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getPhoneAndAddressSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getPhoneAndAddressSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updatePhoneAndAddress({
    required String userId,
    required String address,
    required String phoneNumber,
  }) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.updatePhoneAndAddress(
          userId: userId,
          address: address,
          phoneNumber: phoneNumber,
        );
    if (state is SuccessState) {
      loadingSink.add(false);
      updatePhoneAndAddressSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updatePhoneAndAddressSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }



  getAllUsers() async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getAllUsers();
    if (state is SuccessState) {
      loadingSink.add(false);
      getAllUsersSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getAllUsersSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getUserData({required String userId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getUserData(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getUserDataSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getUserDataSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getRequestedUsers() async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getRequestedUsers();
    if (state is SuccessState) {
      loadingSink.add(false);
      getRequestedUsersSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getRequestedUsersSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }
  @override
  void dispose() {
    _loading.close();
    _addOrUpdateUser.close();
    _clearFcmToken.close();
    _getPhoneAndAddress.close();
    _updatePhoneAndAddress.close();
    _getAllUsers.close();
    _getUserData.close();
    _getRequestedUsers.close();
  }
}
