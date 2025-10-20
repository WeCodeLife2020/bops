// To parse this JSON data, do
//
//     final addVehicleResponseModel = addVehicleResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddVehicleResponseModel addVehicleResponseModelFromJson(String str) =>
    AddVehicleResponseModel.fromJson(json.decode(str));

String addVehicleResponseModelToJson(AddVehicleResponseModel data) =>
    json.encode(data.toJson());

class AddVehicleResponseModel {
  int statusCode;
  String message;
  Data data;

  AddVehicleResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddVehicleResponseModel.fromJson(Map<String, dynamic> json) =>
      AddVehicleResponseModel(
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

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
