import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

CenterResponseModel centerResponseModelFromJson(String str) =>
    CenterResponseModel.fromJson(json.decode(str));

String centerResponseModelToJson(CenterResponseModel data) =>
    json.encode(data.toJson());

class CenterResponseModel {
  String? centerName;
  String? centerId;
  int? tokenNumber;
  Timestamp? currentDate; 
  Timestamp? previousDate;
  String?sheetId;
  Timestamp?sheetCreatedDate;
  bool? isDelete;
  int valetCarNumber;

  CenterResponseModel({
    this.centerName,
    this.centerId,
    this.tokenNumber,
    this.currentDate,
    this.previousDate,
    this.sheetId,
    this.sheetCreatedDate,
    this.isDelete,
    required this.valetCarNumber,
  });

  factory CenterResponseModel.fromJson(Map<String, dynamic> json) =>
      CenterResponseModel(
        centerName: json["centerName"],
        centerId: json["centerId"],
        tokenNumber: json["tokenNumber"],
        currentDate: json["currentDate"] != null
            ? json["currentDate"] 
            : null,
        previousDate: json["previousDate"] != null
            ? json["previousDate"] 
            : null,
        sheetId: json["sheetId"],
        sheetCreatedDate: json["sheetCreatedDate"] != null
            ? json["sheetCreatedDate"]
            : null,
         isDelete: json["isDelete"],
        valetCarNumber: json["valetCarNumber"],
      );

  Map<String, dynamic> toJson() => {
        "centerName": centerName,
        "centerId": centerId,
        "tokenNumber": tokenNumber,
        "currentDate": currentDate,
        "previousDate": previousDate,
        "sheetId": sheetId,
        "sheetCreatedDate":sheetCreatedDate,
        "isDelete":isDelete,
        "valetCarNumber":valetCarNumber,
      };
}
