// To parse this JSON data, do
//
//     final createSheetResponseModel = createSheetResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreateSheetResponseModel createSheetResponseModelFromJson(String str) => CreateSheetResponseModel.fromJson(json.decode(str));

String createSheetResponseModelToJson(CreateSheetResponseModel data) => json.encode(data.toJson());

class CreateSheetResponseModel {
  int statusCode;
  String message;
  Data data;

  CreateSheetResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CreateSheetResponseModel.fromJson(Map<String, dynamic> json) => CreateSheetResponseModel(
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
  String sheetId;

  Data({
    required this.sheetId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sheetId: json["sheetId"],
  );

  Map<String, dynamic> toJson() => {
    "sheetId": sheetId,
  };
}
