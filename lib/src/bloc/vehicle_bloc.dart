import 'dart:async';

import 'package:bops_mobile/src/models/add_vehicle_request_model.dart';
import 'package:bops_mobile/src/models/create_sheet_request_model.dart';
import 'package:bops_mobile/src/models/create_sheet_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';
import 'package:bops_mobile/src/models/update_vehicle_status_Response_model.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';

import '../models/add_vehicle_response model.dart';
import '../models/update_vehicle_status_request_model.dart';
import '../utils/constants.dart';
import '../utils/object_factory.dart';
import '../utils/validators.dart';
import 'base_bloc.dart';

class VehicleBloc extends Object with Validators implements BaseBloc {
  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<AddVehicleResponseModel> _addVehicle =
      StreamController<AddVehicleResponseModel>.broadcast();
  final StreamController<UpdateVehicleStatusResponseModel>
      _updateVehicleStatus =
      StreamController<UpdateVehicleStatusResponseModel>.broadcast();
  final StreamController<CreateSheetResponseModel> _createSheet =
      StreamController<CreateSheetResponseModel>.broadcast();
  final StreamController<VehicleDetailsFirebaseResponseModel>
      _addVehicleDetailsToFirebase =
      StreamController<VehicleDetailsFirebaseResponseModel>.broadcast();
  final StreamController<List<VehicleDetailsFirebaseResponseModel>>
      _getTickets =
      StreamController<List<VehicleDetailsFirebaseResponseModel>>.broadcast();

  final StreamController<dynamic> _updateTicket =
      StreamController<dynamic>.broadcast();

  final StreamController<VehicleDetailsFirebaseResponseModel>
      _prefetchCarDetails =
      StreamController<VehicleDetailsFirebaseResponseModel>.broadcast();

  final StreamController<VehicleDetailsFirebaseResponseModel>
      _searchVehicleDetails =
      StreamController<VehicleDetailsFirebaseResponseModel>.broadcast();
  final StreamController<List<VehicleDetailsFirebaseResponseModel>>
      _getRequestedVehicleDetails =
      StreamController<List<VehicleDetailsFirebaseResponseModel>>.broadcast();
  final StreamController<dynamic> _updateVehicleParkedLocation =
      StreamController<dynamic>.broadcast();
  final StreamController<List<dynamic>> _getPaymentCount =
      StreamController<List<dynamic>>.broadcast();

  /// Stream

  Stream<bool> get loadingListener => _loading.stream;
  Stream<AddVehicleResponseModel> get addVehicleListener => _addVehicle.stream;
  Stream<UpdateVehicleStatusResponseModel> get updateVehicleStatusListener =>
      _updateVehicleStatus.stream;
  Stream<CreateSheetResponseModel> get createSheetListener =>
      _createSheet.stream;
  Stream<VehicleDetailsFirebaseResponseModel>
      get addVehicleDetailsToFirebaseListener =>
          _addVehicleDetailsToFirebase.stream;
  Stream<List<VehicleDetailsFirebaseResponseModel>> get getTicketsListener =>
      _getTickets.stream;
  Stream<dynamic> get updateTicketListener => _updateTicket.stream;
  Stream<VehicleDetailsFirebaseResponseModel> get prefetchCArDetailsListener =>
      _prefetchCarDetails.stream;
  Stream<VehicleDetailsFirebaseResponseModel>
      get searchVehicleDetailsListener => _searchVehicleDetails.stream;

  Stream<List<VehicleDetailsFirebaseResponseModel>>
      get getRequestedVehicleDetailsListener =>
          _getRequestedVehicleDetails.stream;

  Stream<dynamic> get updateVehicleParkedLocationListener =>
      _updateVehicleParkedLocation.stream;

  Stream<List<dynamic>> get getPaymentCountListener => _getPaymentCount.stream;

  /// Sink

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<AddVehicleResponseModel> get addVehicleSink => _addVehicle.sink;
  StreamSink<UpdateVehicleStatusResponseModel> get updateVehicleStatusSink =>
      _updateVehicleStatus.sink;
  StreamSink<CreateSheetResponseModel> get createSheetSink => _createSheet.sink;
  StreamSink<dynamic> get addVehicleDetailsToFirebaseSink =>
      _addVehicleDetailsToFirebase.sink;
  StreamSink<List<VehicleDetailsFirebaseResponseModel>> get getTicketsSink =>
      _getTickets.sink;
  StreamSink<dynamic> get updateTicketSink => _updateTicket.sink;
  StreamSink<VehicleDetailsFirebaseResponseModel> get prefetchCarDetailsSink =>
      _prefetchCarDetails.sink;
  StreamSink<VehicleDetailsFirebaseResponseModel>
      get searchVehicleDetailsSink => _searchVehicleDetails.sink;

  StreamSink<List<VehicleDetailsFirebaseResponseModel>>
      get getRequestedVehicleDetailsSink => _getRequestedVehicleDetails.sink;

  StreamSink<dynamic> get updateVehicleParkedLocationSink =>
      _updateVehicleParkedLocation.sink;

  StreamSink<List<dynamic>> get getPaymentCountSink => _getPaymentCount.sink;

  addVehicleToSheet(
      {required AddVehicleRequestModel addVehicleRequestModel}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .addVehicleToSheet(addVehicleRequestModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      addVehicleSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      addVehicleSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateVehicleStatus(
      {required UpdateVehicleStatusRequestModel
          updateVehicleStatusRequestModel}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .updateVehicleStatus(updateVehicleStatusRequestModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateVehicleStatusSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateVehicleStatusSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  createSheet({required spreadsheetName}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.createSheet(
        CreateSheetRequestModel(
            action: 'createSpreadsheet', sheetName: spreadsheetName));
    if (state is SuccessState) {
      loadingSink.add(false);
      createSheetSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      createSheetSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  addVehicleDetailsToFirebase({
    required VehicleDetailsFirebaseResponseModel
        vehicleDetailsFirebaseResponseModel,
    // required int tokenNumber,
    // required int valetCarNumber,
  }) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.addVehicleDetailsToFirebase(
        // valetCarNumber: valetCarNumber,
        // tokenNumber: tokenNumber,
        vehicleDetailsFirebaseResponseModel:
            vehicleDetailsFirebaseResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      addVehicleDetailsToFirebaseSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      addVehicleDetailsToFirebaseSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getTickets({required String centerId, required String vehicleStatus}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .getTickets(centerId: centerId, vehicleStatus: vehicleStatus);
    if (state is SuccessState) {
      loadingSink.add(false);
      getTicketsSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getTicketsSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateTicket(
      {required VehicleDetailsFirebaseResponseModel
          vehicleDetailsFirebaseResponseModel}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.updateTicket(
        vehicleDetailsFirebaseResponseModel:
            vehicleDetailsFirebaseResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateTicketSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateTicketSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  prefetchCarDetails({required String registrationNumber}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .prefetchCarDetails(registrationNumber: registrationNumber);
    if (state is SuccessState) {
      loadingSink.add(false);
      prefetchCarDetailsSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      prefetchCarDetailsSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  searchVehicleDetails({
    String? registrationNumber,
    int? valetCarNumber,
    required String centerId,
  }) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.searchVehicleDetails(
          registrationNumber: registrationNumber,
          valetCarNumber: valetCarNumber,
          centerId: centerId,
        );
    if (state is SuccessState) {
      loadingSink.add(false);
      searchVehicleDetailsSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      searchVehicleDetailsSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getRequestedVehicleDetails(
      {required String centerId, required int limit}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .getRequestedVehicleDetails(centerId: centerId, limit: limit);
    if (state is SuccessState) {
      loadingSink.add(false);
      getRequestedVehicleDetailsSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getRequestedVehicleDetailsSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  updateVehicleParkedLocation(
      {required String documentId, required String parkedLocation}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.updateVehicleParkedLocation(
        documentId: documentId, parkedLocation: parkedLocation);
    if (state is SuccessState) {
      loadingSink.add(false);
      updateVehicleParkedLocationSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      updateVehicleParkedLocationSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getPaymentCount({
    required String centerId,
  }) async {
    loadingSink.add(true);
    State? state =
        await ObjectFactory().repository.getPaymentCount(centerId: centerId);
    if (state is SuccessState) {
      loadingSink.add(false);
      getPaymentCountSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getPaymentCountSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  @override
  void dispose() {
    _loading.close();
    _addVehicle.close();
    _updateVehicleStatus.close();
    _createSheet.close();
    _addVehicleDetailsToFirebase.close();
    _getTickets.close();
    _updateTicket.close();
    _prefetchCarDetails.close();
    _searchVehicleDetails.close();
  }
}
