// To parse this JSON data, do
//
//     final createSheetRequestModel = createSheetRequestModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreateSheetRequestModel createSheetRequestModelFromJson(String str) => CreateSheetRequestModel.fromJson(json.decode(str));

String createSheetRequestModelToJson(CreateSheetRequestModel data) => json.encode(data.toJson());

class CreateSheetRequestModel {
  String action;
  String sheetName;

  CreateSheetRequestModel({
    required this.action,
    required this.sheetName,
  });

  factory CreateSheetRequestModel.fromJson(Map<String, dynamic> json) => CreateSheetRequestModel(
    action: json["action"],
    sheetName: json["sheetName"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "sheetName": sheetName,
  };
}
