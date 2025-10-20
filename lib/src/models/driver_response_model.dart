import 'dart:convert';

DriverResponseModel driverResponseModelFromJson(String str) =>
    DriverResponseModel.fromJson(json.decode(str));

String driverResponseModelToJson(DriverResponseModel data) =>
    json.encode(data.toJson());

class DriverResponseModel {
  String? driverId;
  String? driverEmail;
  String? driverCenter;
  String? driverCenterId;
  String? driverName;
  String? driverPhoneNumber;
  String? driverAddress;
  String? driverUserId;
  bool? isSuspended;

  DriverResponseModel({
    this.driverId,
    this.driverEmail,
    this.driverCenter,
    this.driverCenterId,
    this.driverName,
    this.driverPhoneNumber,
    this.driverAddress,
    this.driverUserId,
    this.isSuspended,
  });

  factory DriverResponseModel.fromJson(Map<String, dynamic> json) =>
      DriverResponseModel(
        driverId: json["driverId"],
        driverEmail: json["driverEmail"],
        driverCenter: json["driverCenter"],
        driverCenterId: json["driverCenterId"],
        driverName: json["driverName"],
        driverPhoneNumber: json["driverPhoneNumber"],
        driverAddress: json["driverAddress"],
        driverUserId: json["driverUserId"],
        isSuspended: json["isSuspended"],
      );

  Map<String, dynamic> toJson() => {
    "driverId": driverId,
    "driverEmail": driverEmail,
    "driverCenter": driverCenter,
    "driverCenterId": driverCenterId,
    "driverName": driverName,
    "driverPhoneNumber": driverPhoneNumber,
    "driverAddress": driverAddress,
    "driverUserId": driverUserId,
    "isSuspended": isSuspended,
  };
}
