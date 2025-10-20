import 'dart:convert';

ManagerResponseModel managerResponseModelFromJson(String str) =>
    ManagerResponseModel.fromJson(json.decode(str));

String managerResponseModelToJson(ManagerResponseModel data) =>
    json.encode(data.toJson());

class ManagerResponseModel {
  String? managerId;
  String? managerEmail;
  String? managerCenter;
  String? managerCenterId;
  String? managerName;
  String? managerPhoneNumber;
  String? managerAddress;
  String? managerUserId;
  bool? isSuspended;

  ManagerResponseModel({
    this.managerId,
    this.managerEmail,
    this.managerCenter,
    this.managerCenterId,
    this.managerName,
    this.managerPhoneNumber,
    this.managerAddress,
    this.managerUserId,
    this.isSuspended,
  });

  factory ManagerResponseModel.fromJson(Map<String, dynamic> json) =>
      ManagerResponseModel(
        managerId: json["managerId"],
        managerEmail: json["managerEmail"],
        managerCenter: json["managerCenter"],
        managerCenterId: json["managerCenterId"],
        managerName: json["managerName"],
        managerPhoneNumber: json["managerPhoneNumber"],
        managerAddress: json["managerAddress"],
        managerUserId: json["managerUserId"],
        isSuspended: json["isSuspended"],
      );

  Map<String, dynamic> toJson() => {
        "managerId": managerId,
        "managerEmail": managerEmail,
        "managerCenter": managerCenter,
        "managerCenterId": managerCenterId,
        "managerName": managerName,
        "managerPhoneNumber": managerPhoneNumber,
        "managerAddress": managerAddress,
        "managerUserId": managerUserId,
        "isSuspended": isSuspended,
      };
}
