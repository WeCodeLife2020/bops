// To parse this JSON data, do
//
//     final sheetDetailsFirebaseResponseModel = sheetDetailsFirebaseResponseModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

SheetDetailsFirebaseResponseModel sheetDetailsFirebaseResponseModelFromJson(String str) => SheetDetailsFirebaseResponseModel.fromJson(json.decode(str));

String sheetDetailsFirebaseResponseModelToJson(SheetDetailsFirebaseResponseModel data) => json.encode(data.toJson());

class SheetDetailsFirebaseResponseModel {
  String centerId;
  String centerName;
  String sheetId;
  String sheetName;
  Timestamp? sheetCreatedDate;

  SheetDetailsFirebaseResponseModel({
    required this.centerId,
    required this.centerName,
    required this.sheetId,
    required this.sheetName,
     this.sheetCreatedDate,
  });

  factory SheetDetailsFirebaseResponseModel.fromJson(Map<String, dynamic> json) => SheetDetailsFirebaseResponseModel(
    centerId: json["centerId"],
    centerName: json["centerName"],
    sheetId: json["sheetId"],
    sheetName: json["sheetName"],
    sheetCreatedDate: json["sheetCreatedDate"],
  );

  Map<String, dynamic> toJson() => {
    "centerId": centerId,
    "centerName": centerName,
    "sheetId": sheetId,
    "sheetName": sheetName,
    "sheetCreatedDate": sheetCreatedDate,
  };
}
