// To parse this JSON data, do
//
//     final updateVehicleStatusResponseModel = updateVehicleStatusResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateVehicleStatusResponseModel updateVehicleStatusResponseModelFromJson(String str) => UpdateVehicleStatusResponseModel.fromJson(json.decode(str));

String updateVehicleStatusResponseModelToJson(UpdateVehicleStatusResponseModel data) => json.encode(data.toJson());

class UpdateVehicleStatusResponseModel {
  int statusCode;
  String message;
  Data data;

  UpdateVehicleStatusResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UpdateVehicleStatusResponseModel.fromJson(Map<String, dynamic> json) => UpdateVehicleStatusResponseModel(
    statusCode: json["status_code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data(
  );

  Map<String, dynamic> toJson() => {
  };
}
