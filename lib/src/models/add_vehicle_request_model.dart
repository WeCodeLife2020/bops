// To parse this JSON data, do
//
//     final addVehicleRequestModel = addVehicleRequestModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddVehicleRequestModel addVehicleRequestModelFromJson(String str) => AddVehicleRequestModel.fromJson(json.decode(str));

String addVehicleRequestModelToJson(AddVehicleRequestModel data) => json.encode(data.toJson());

class AddVehicleRequestModel {
  String action;
  String spreadsheetId;
  String registrationNumber;
  String tokenNumber;
  String modelName;
  String mobileNumber;
  String checkInTime;
  String checkOutTime;
  String parkedLocation;
  String parkedBy;
  String vehicleStatus;
  String checkInBy;
  String checkoutBy;
  String paymentMethod;
  String keyHoldLocation;
  String valetCarNumber;
  AddVehicleRequestModel({
    required this.action,
    required this.spreadsheetId,
    required this.registrationNumber,
    required this.tokenNumber,
    required this.modelName,
    required this.mobileNumber,
    required this.checkInTime,
    required this.checkOutTime,
    required this.parkedLocation,
    required this.parkedBy,
    required this.vehicleStatus,
    required this.checkInBy,
    required this.checkoutBy,
    required this.paymentMethod,
    required this.keyHoldLocation,
    required this.valetCarNumber,
  });

  factory AddVehicleRequestModel.fromJson(Map<String, dynamic> json) => AddVehicleRequestModel(
    action: json["action"],
    spreadsheetId: json["spreadsheetId"],
    registrationNumber: json["registrationNumber"],
    tokenNumber: json["tokenNumber"],
    modelName: json["modelName"],
    mobileNumber: json["mobileNumber"],
    checkInTime: json["checkInTime"],
    checkOutTime: json["checkOutTime"],
    parkedLocation: json["parkedLocation"],
    parkedBy: json["parkedBy"],
    vehicleStatus: json["vehicleStatus"],
    checkInBy: json["checkInBy"],
    checkoutBy: json["checkoutBy"],
    paymentMethod:json["paymentMethod"],
    keyHoldLocation: json["keyHoldLocation"],
    valetCarNumber: json["valetCarNumber"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "spreadsheetId": spreadsheetId,
    "registrationNumber": registrationNumber,
    "tokenNumber": tokenNumber,
    "modelName": modelName,
    "mobileNumber": mobileNumber,
    "checkInTime": checkInTime,
    "checkOutTime": checkOutTime,
    "parkedLocation": parkedLocation,
    "parkedBy": parkedBy,
    "vehicleStatus": vehicleStatus,
    "checkInBy": checkInBy,
    "checkoutBy": checkoutBy,
    "paymentMethod":paymentMethod,
    "keyHoldLocation":keyHoldLocation,
    "valetCarNumber":valetCarNumber,
  };
}
