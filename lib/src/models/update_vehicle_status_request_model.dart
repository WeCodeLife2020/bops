// To parse this JSON data, do
//
//     final updateVehicleStatusRequestModel = updateVehicleStatusRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateVehicleStatusRequestModel updateVehicleStatusRequestModelFromJson(String str) => UpdateVehicleStatusRequestModel.fromJson(json.decode(str));

String updateVehicleStatusRequestModelToJson(UpdateVehicleStatusRequestModel data) => json.encode(data.toJson());

class UpdateVehicleStatusRequestModel {
  String? action;
  String? sheetId;
  String? sheetIndex;
  String? checkedoutTime;
  String? parkedLocation;
  String? parkedBy;
  String? vehicleStatus;
  String? checkoutBy;
  String? paymentMethod;
  String? keyHoldLocation;

  UpdateVehicleStatusRequestModel({
    this.action,
    this.sheetId,
    this.sheetIndex,
    this.checkedoutTime,
    this.parkedLocation,
    this.parkedBy,
    this.vehicleStatus,
    this.checkoutBy,
    this.paymentMethod,
    this.keyHoldLocation
  });

  factory UpdateVehicleStatusRequestModel.fromJson(Map<String, dynamic> json) => UpdateVehicleStatusRequestModel(
    action: json["action"],
    sheetId: json["sheetId"],
    sheetIndex: json["sheetIndex"],
    checkedoutTime: json["checkedoutTime"],
    parkedLocation: json["parkedLocation"],
    parkedBy: json["parkedBy"],
    vehicleStatus: json["vehicleStatus"],
    checkoutBy: json["checkoutBy"],
    paymentMethod: json["paymentMethod"],
    keyHoldLocation: json["keyHoldLocation"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "sheetId": sheetId,
    "sheetIndex": sheetIndex,
    "checkedoutTime": checkedoutTime,
    "parkedLocation": parkedLocation,
    "parkedBy": parkedBy,
    "vehicleStatus": vehicleStatus,
    "checkoutBy": checkoutBy,
    "paymentMethod":paymentMethod,
    "keyHoldLocation":keyHoldLocation,
  };
}
