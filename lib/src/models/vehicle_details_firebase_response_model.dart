import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

VehicleDetailsFirebaseResponseModel vehicleDetailsFirebaseResponseModelFromJson(
        String str) =>
    VehicleDetailsFirebaseResponseModel.fromJson(json.decode(str));

String vehicleDetailsFirebaseResponseModelToJson(
        VehicleDetailsFirebaseResponseModel data) =>
    json.encode(data.toJson());

class VehicleDetailsFirebaseResponseModel {
  int? tokenNumber;
  String? registrationNumber;
  String? modelName;
  String? mobileNumber;
  Timestamp? checkInTime;
  Timestamp? checkOut;
  Timestamp? requestedTime;
  String? vehicleStatus;
  String? parkedLocation;
  String? managerId;
  String? managerName;
  String? managerUserId;
  String? centerId;
  String? centerName;
  String? documentId;
  String? sheetId;
  String? driverId;
  String? checkInBy;
  String? parkedBy;
  String? checkOutBy;
  String? paymentMethod;
  String? keyHoldLocation;
  int? valetCarNumber;

  VehicleDetailsFirebaseResponseModel({
    this.tokenNumber,
    this.registrationNumber,
    this.modelName,
    this.mobileNumber,
    this.checkInTime,
    this.requestedTime,
    this.checkOut,
    this.vehicleStatus,
    this.parkedLocation,
    this.managerId,
    this.managerName,
    this.managerUserId,
    this.centerId,
    this.centerName,
    this.documentId,
    this.sheetId,
    this.driverId,
    this.checkInBy,
    this.parkedBy,
    this.checkOutBy,
    this.paymentMethod,
    this.keyHoldLocation,
    this.valetCarNumber,
  });

  factory VehicleDetailsFirebaseResponseModel.fromJson(
          Map<String, dynamic> json) =>
      VehicleDetailsFirebaseResponseModel(
        tokenNumber: json["tokenNumber"],
        registrationNumber: json["registrationNumber"],
        modelName: json["modelName"],
        mobileNumber: json["mobileNumber"],
        checkInTime: json["checkInTime"] != null
            ? (json["checkInTime"] as Timestamp)
            : null,
        // Set to null if not provided
        checkOut:
            json["checkOut"] != null ? (json["checkOut"] as Timestamp) : null,
        // Set to null if not provided
        requestedTime: json['requestedTime'] != null
            ? (json['requestedTime'] as Timestamp)
            : null,
        vehicleStatus: json["vehicleStatus"],
        parkedLocation: json["parkedLocation"],
        managerId: json["managerId"],
        managerName: json["managerName"],
        managerUserId: json["managerUserId"],
        centerId: json["centerId"],
        centerName: json["centerName"],
        documentId: json["documentId"],
        sheetId: json["sheetId"],
        driverId: json["driverId"],
        checkInBy: json["checkInBy"],
        parkedBy: json["parkedBy"],
        checkOutBy: json["checkOutBy"],
        paymentMethod: json["paymentMethod"],
        keyHoldLocation: json["keyHoldLocation"],
        valetCarNumber: json['valetCarNumber'],
      );

  Map<String, dynamic> toJson() => {
        "tokenNumber": tokenNumber,
        "registrationNumber": registrationNumber,
        "modelName": modelName,
        "mobileNumber": mobileNumber,
        "checkInTime": checkInTime,
        "checkOut": checkOut,
        "requestedTime": requestedTime,
        "vehicleStatus": vehicleStatus,
        "parkedLocation": parkedLocation,
        "managerId": managerId,
        "managerName": managerName,
        "managerUserId": managerUserId,
        "centerId": centerId,
        "centerName": centerName,
        "documentId": documentId,
        "sheetId": sheetId,
        "driverId": driverId,
        "checkInBy": checkInBy,
        "parkedBy": parkedBy,
        "checkOutBy": checkOutBy,
        "paymentMethod": paymentMethod,
        "keyHoldLocation": keyHoldLocation,
        "valetCarNumber": valetCarNumber,
      };
}
