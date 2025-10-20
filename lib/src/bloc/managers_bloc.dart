import 'dart:async';

import 'package:bops_mobile/src/bloc/base_bloc.dart';
import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/utils/constants.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/validators.dart';

import '../models/state.dart';

class ManagersBloc extends Object with Validators implements BaseBloc {
  ///Conttrollers

  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<dynamic> _addManager =
      StreamController<dynamic>.broadcast();
  final StreamController<List<ManagerResponseModel>> _fetchManagers =
      StreamController<List<ManagerResponseModel>>.broadcast();

  final StreamController<dynamic> _updateSuspendStatus =
      StreamController<dynamic>.broadcast();

  final StreamController<bool> _getIsSuspended =
      StreamController<bool>.broadcast();

  final StreamController<String> _getCenterName =
      StreamController<String>.broadcast();

  final StreamController<String> _getCenterId =
      StreamController<String>.broadcast();

  final StreamController<String> _getManagerId =
      StreamController<String>.broadcast();

  final StreamController<String> _updateManagerDetails =
  StreamController<String>.broadcast();

  /// Stream

  Stream<bool> get loadingListener => _loading.stream;
  Stream<dynamic> get addManagerListener => _addManager.stream;
  Stream<List<ManagerResponseModel>> get fetchManagersListener =>
      _fetchManagers.stream;
  Stream<dynamic> get updateSuspendStatusListener =>
      _updateSuspendStatus.stream;
  Stream<bool> get getIsSuspendedListener => _getIsSuspended.stream;
  Stream<String> get getCenterNameListener => _getCenterName.stream;
  Stream<String> get getCenterIdListener => _getCenterId.stream;

  Stream<String> get getManagerIdListener => _getManagerId.stream;
  Stream<String> get updateManagerDetailsListener => _updateManagerDetails.stream;

  /// Sink

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<dynamic> get addManagerSink => _addManager.sink;
  StreamSink<List<ManagerResponseModel>> get fetchManagersSink =>
      _fetchManagers.sink;
  StreamSink<dynamic> get updateSuspendStatusSink => _updateSuspendStatus.sink;
  StreamSink<bool> get getIsSuspendedSink => _getIsSuspended.sink;
  StreamSink<String> get getCenterNameSink => _getCenterName.sink;
  StreamSink<String> get getCenterIdSink => _getCenterId.sink;
  StreamSink<String> get getManagerIdSink => _getManagerId.sink;
  StreamSink<String> get updateManagerDetailsSink => _updateManagerDetails.sink;

  /// Functions

  /// add manager
  addManager({required ManagerResponseModel managerResponseModel}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .addManager(managerResponseModel: managerResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      addManagerSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      addManagerSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  /// Get managers
  fetchManagers({required bool isSuspended}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .fetchManagers(isSuspended: isSuspended);
    if (state is SuccessState) {
      loadingSink.add(false);
      fetchManagersSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      fetchManagersSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  /// update suspend status
  updateSuspendStatus({required String managerId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .updateSuspendStatus(managerId: managerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateSuspendStatusSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateSuspendStatusSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  /// get Suspened status
  getIsSuspended({required String userId}) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.getIsSuspended(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getIsSuspendedSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getIsSuspendedSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  /// get center name
  getCenterName({required String userId}) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.getCenterName(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getCenterNameSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getCenterNameSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  /// get center id
  getCenterId({required String userId}) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.getCenterId(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getCenterIdSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getCenterIdSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  /// get manager id
  getManagerId({required String userId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getManagerId(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getManagerIdSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getManagerIdSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateManagerDetails({required ManagerResponseModel managerResponseModel}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.updateManagerDetails(managerResponseModel: managerResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateManagerDetailsSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateManagerDetailsSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }
  @override
  void dispose() {
    _loading.close();
    _addManager.close();
    _fetchManagers.close();
    _updateSuspendStatus.close();
    _getIsSuspended.close();
    _getCenterName.close();
    _getCenterId.close();
    _getManagerId.close();
  }
}
