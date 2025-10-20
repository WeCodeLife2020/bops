import 'dart:async';
import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';

import '../utils/constants.dart';
import '../utils/object_factory.dart';
import '../utils/validators.dart';
import 'base_bloc.dart';

class CenterBloc extends Object with Validators implements BaseBloc {

  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<dynamic> _addCenter =StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getCenters =StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _deleteCenter =StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _updateCenterName =StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _updateCenterDates =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getTokenNumber =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _updateTokenNumber =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getSheetId =
  StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _getSheetCreatedDate =
  StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _updateCenterSheetId =StreamController<dynamic>.broadcast();
  final StreamController<dynamic>_getCenterNameByCenterId=StreamController<dynamic>.broadcast();
  final StreamController<dynamic>_getIsDeleted=StreamController<dynamic>.broadcast();

  /// Stream

  Stream<bool> get loadingListener => _loading.stream;
  Stream<dynamic> get addCenterListener => _addCenter.stream;
  Stream<dynamic> get getCentersListener => _getCenters.stream;
  Stream<dynamic> get deleteCenterListener => _deleteCenter.stream;
  Stream<dynamic> get updateCenterNameListener => _updateCenterName.stream;
  Stream<dynamic> get updateCenterDatesListener => _updateCenterDates.stream;
  Stream<dynamic> get getTokenNumberListener => _getTokenNumber.stream;
  Stream<dynamic> get getSheetIdListener => _getSheetId.stream;
  Stream<dynamic> get getSheetCreatedDateListener => _getSheetCreatedDate.stream;
  Stream<dynamic> get updateTokenNumberListener => _updateTokenNumber.stream;
  Stream<dynamic> get updateCenterSheetIdListener => _updateCenterSheetId.stream;
  Stream<dynamic> get getCenterNameByCenterIdListener =>_getCenterNameByCenterId.stream;
  Stream<dynamic> get getIsDeletedListener =>_getIsDeleted.stream;
  /// Sink

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<dynamic> get addCenterSink => _addCenter.sink;
  StreamSink<dynamic> get getCentersSink => _getCenters.sink;
  StreamSink<dynamic> get deleteCenterSink => _deleteCenter.sink;
  StreamSink<dynamic> get updateCenterNameSink => _updateCenterName.sink;
  StreamSink<dynamic> get updateCenterDatesSink => _updateCenterDates.sink;
  StreamSink<dynamic> get getTokenNumberSink => _getTokenNumber.sink;
  StreamSink<dynamic> get getSheetIdSink => _getSheetId.sink;
  StreamSink<dynamic> get getSheetCreatedDateSink => _getSheetCreatedDate.sink;
  StreamSink<dynamic> get updateTokenNumberSink => _updateTokenNumber.sink;
  StreamSink<dynamic> get updateCenterSheetIdSink => _updateCenterSheetId.sink;
  StreamSink<dynamic> get getCenterNameByCenterIdSink => _getCenterNameByCenterId.sink;
  StreamSink<dynamic> get getIsDeletedSink => _getIsDeleted.sink;


  addCenter({required CenterResponseModel centerResponseModel }) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.addCenter(centerResponseModel: centerResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      addCenterSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      addCenterSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getCenters() async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getCenters();
    if (state is SuccessState) {
      loadingSink.add(false);
      getCentersSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getCentersSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  deleteCenter({required centerId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.deleteCenter(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      deleteCenterSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      deleteCenterSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateCenterName({required centerId,required centerName}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.updateCenterName(centerName: centerName, centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateCenterNameSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateCenterNameSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateCenterDates({required centerId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .updateCenterDates(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateCenterDatesSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateCenterDatesSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getTokenNumber({required centerId}) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.getTokenNumber(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getTokenNumberSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getTokenNumberSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }
  getSheetId({required centerId}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.getSheetId(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getSheetIdSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getSheetIdSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }
  getSheetCreatedDate({required centerId}) async {
    loadingSink.add(true);
    State? state =
    await ObjectFactory().repository.getSheetCreatedDate(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getSheetCreatedDateSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getSheetCreatedDateSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateTokenNumber({required centerId}) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.updateTokenNumber(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateTokenNumberSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateTokenNumberSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateCenterSheetId({required centerId,required sheetId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.updateCenterSheetId(sheetId: sheetId, centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateCenterSheetIdSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateCenterSheetIdSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getCenterNameByCenterId({required String centerId,
    required String userId,
    required bool isManager}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getCenterNameByCenterId(centerId: centerId, userId: userId, isManager: isManager);
    if (state is SuccessState) {
      loadingSink.add(false);
      getCenterNameByCenterIdSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getCenterNameByCenterIdSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getIsDeleted({required String centerId}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getIsDeleted(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getIsDeletedSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getIsDeletedSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  @override
  void dispose() {
    _loading.close();
    _addCenter.close();
    _getCenters.close();
    _deleteCenter.close();
    _updateCenterName.close();
    _updateCenterDates.close();
    _getTokenNumber.close();
    _updateTokenNumber.close();
  }
}