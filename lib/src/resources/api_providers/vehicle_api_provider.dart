import 'package:bops_mobile/src/models/add_vehicle_request_model.dart';
import 'package:bops_mobile/src/models/create_sheet_request_model.dart';
import 'package:bops_mobile/src/models/create_sheet_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';
import 'package:bops_mobile/src/models/update_vehicle_status_Response_model.dart';
import 'package:bops_mobile/src/models/update_vehicle_status_request_model.dart';

import '../../models/add_vehicle_response model.dart';
import '../../utils/object_factory.dart';

class VehicleApiProvider {

  Future<State?> addVehicleToSheet(AddVehicleRequestModel addVehicleRequest) async {
    try {
      final response =
      await ObjectFactory().apiClient.addVehicleToSheet(addVehicleRequest);
      print(response);
      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          response.statusCode == 203) {
        // print(response.toString());
        return State<AddVehicleResponseModel>.success(
            AddVehicleResponseModel.fromJson(response.data));
      } else {
        return State<String>.error(response.data["message"]);
      }
    } catch (e) {
      return State.error(e);
    }
  }
  Future<State?> updateVehicleStatus(UpdateVehicleStatusRequestModel updateVehicleStatusRequest) async {
    try {
      final response =
      await ObjectFactory().apiClient.updateVehicleStatus(updateVehicleStatusRequest);
      print(response);
      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          response.statusCode == 203) {
        // print(response.toString());
        return State<UpdateVehicleStatusResponseModel>.success(
            UpdateVehicleStatusResponseModel.fromJson(response.data));
      } else {
        return State<String>.error(response.data["message"]);
      }
    } catch (e) {
      return State.error(e);
    }
  }

  Future<State?> createSheet(CreateSheetRequestModel createSheetRequest) async {
    try {
      final response =
      await ObjectFactory().apiClient.createSheet(createSheetRequest);
      print("${response.statusCode} this is response");
      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          response.statusCode == 203) {
        // print(response.toString());
        print(CreateSheetResponseModel.fromJson(response.data));
        return State<CreateSheetResponseModel>.success(
            CreateSheetResponseModel.fromJson(response.data));
      } else {
        print(CreateSheetResponseModel.fromJson(response.data));
        return State<String>.error(response.data["message"]);
      }
    } catch (e) {
      return State.error(e);
    }
  }
}