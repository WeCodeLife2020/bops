import 'dart:async';

import 'package:bops_mobile/src/models/driver_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';

import '../utils/constants.dart';
import '../utils/object_factory.dart';
import '../utils/validators.dart';
import 'base_bloc.dart';

class DriverBloc extends Object with Validators implements BaseBloc {

  ///Conttrollers

  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<dynamic> _addDriver = StreamController<dynamic>.broadcast();
  final StreamController<List<DriverResponseModel>?> _getDrivers = StreamController<List<DriverResponseModel>?>.broadcast();
  final StreamController<dynamic> _updateDriverSuspendStatus = StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getDriverCenterName = StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getDriverCenterId = StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getDriverId = StreamController<dynamic>.broadcast();
  final StreamController<bool> _getDriverSuspendedStatus = StreamController<bool>.broadcast();
  final StreamController<dynamic> _updateDriverDetails = StreamController<dynamic>.broadcast();

  /// Stream

  Stream<bool> get loadingListener => _loading.stream;
  Stream<dynamic> get addDriverListener => _addDriver.stream;
  Stream<List<DriverResponseModel>?> get getDriversListener => _getDrivers.stream;
  Stream<dynamic> get updateDriverSuspendStatusListener => _updateDriverSuspendStatus.stream;
  Stream<dynamic> get getDriverCenterNameListener => _getDriverCenterName.stream;
  Stream<dynamic> get getDriverCenterIdListener => _getDriverCenterId.stream;
  Stream<dynamic> get getDriverIdListener => _getDriverId.stream;
  Stream<bool> get getDriverSuspendedStatusListener => _getDriverSuspendedStatus.stream;
  Stream<dynamic> get updateDriverDetailsListener => _updateDriverDetails.stream;


  /// Sink

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<dynamic> get addDriverSink => _addDriver.sink;
  StreamSink<List<DriverResponseModel>?> get getDriversSink => _getDrivers.sink;
  StreamSink<dynamic> get updateDriverSuspendStatusSink => _updateDriverSuspendStatus.sink;
  StreamSink<dynamic> get getDriverCenterNameSink => _getDriverCenterName.sink;
  StreamSink<dynamic> get getDriverCenterIdSink => _getDriverCenterId.sink;
  StreamSink<dynamic> get getDriverIdSink => _getDriverId.sink;
  StreamSink<bool> get getDriverSuspendedStatusSink => _getDriverSuspendedStatus.sink;
  StreamSink<dynamic> get updateDriverDetailsSink => _updateDriverDetails.sink;
  /// Functions

  /// add driver
  addDriver({required DriverResponseModel driverResponseModel}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .addDriver(driverResponseModel: driverResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      addDriverSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      addDriverSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }


  ///get drivers
  getDrivers({required bool isSuspended,required String centerId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .getDrivers(isSuspended: isSuspended,centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getDriversSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getDriversSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }
///update driver suspend status
  updateDriverSuspendStatus({required bool isSuspended,required String driverId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .updateDriverSuspendStatus(isSuspended: isSuspended, driverId: driverId);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateDriverSuspendStatusSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateDriverSuspendStatusSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getDriverCenterName({required String userId}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.getDriverCenterName(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getDriverCenterNameSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getDriverCenterNameSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getDriverCenterId({required String userId}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.getDriverCenterId(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getDriverCenterIdSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getDriverCenterIdSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getDriverId({required String userId}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.getDriverId(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getDriverIdSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getDriverIdSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getDriverSuspendedStatus({required String userId}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.getDriverSuspendedStatus(userId: userId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getDriverSuspendedStatusSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getDriverSuspendedStatusSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateDriverDetails({required DriverResponseModel driverResponseModel}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.updateDriverDetails(driverResponseModel: driverResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateDriverDetailsSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateDriverDetailsSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _loading.close();
    _addDriver.close();
    _getDrivers.close();
  }
}