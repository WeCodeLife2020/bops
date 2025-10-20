import 'dart:async';

import 'package:bops_mobile/src/models/login_request_model.dart';
import 'package:bops_mobile/src/models/send_message_request_model.dart';
import 'package:bops_mobile/src/utils/urls.dart';
import 'package:dio/dio.dart';

import '../models/add_vehicle_request_model.dart';
import '../models/create_sheet_request_model.dart';
import '../models/update_vehicle_status_request_model.dart';
import 'object_factory.dart';

class ApiClient {
  ///  user login
  Future<Response> loginRequest(LoginRequest loginRequest) {
    print(loginRequest.toString());

    return ObjectFactory().appDio.post(url: Urls.baseUrl, data: loginRequest);
  }

  Future<Response> sendMessage(
      SendMessageRequestModel sendMessageRequestModel) async {
    print(
        "SEND MESSAGE REQUEST MODEL IN API CLIENT: ${sendMessageRequestModel.toJson()}");
    final response = await ObjectFactory().appDio.postSmsWithAuthKey(
          authKey: "429623Ae5yIr9BU67456f9bP1",
          url: Urls.smsUrl,
          data: sendMessageRequestModel.toJson(),
        );

    print(response.headers);
    return response;
  }

  Future<Response> addVehicleToSheet(
      AddVehicleRequestModel addVehicleRequest) async {
    // print("object");
    print(addVehicleRequest.toJson());
    final response = await ObjectFactory()
        .appDio
        .post(url: Urls.sheetBaseUrl, data: addVehicleRequest.toJson());
    // print("object");
    print(response.headers);
    return response;
  }

  Future<Response> updateVehicleStatus(
      UpdateVehicleStatusRequestModel updateVehicleStatusRequest) async {
    print(updateVehicleStatusRequest.toJson());
    final response = await ObjectFactory().appDio.post(
        url: Urls.sheetBaseUrl, data: updateVehicleStatusRequest.toJson());
    print(response);
    return response;
  }

  Future<Response> createSheet(
      CreateSheetRequestModel createSheetRequest) async {
    print(createSheetRequest.toJson());
    final response = await ObjectFactory()
        .appDio
        .post(url: Urls.sheetBaseUrl, data: createSheetRequest.toJson());
    print(response.statusCode);
    print(response);
    return response;
  }
}
