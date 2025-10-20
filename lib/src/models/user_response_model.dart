import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) =>
    json.encode(data.toJson());

class UserResponseModel {
  String? userId;
  String? userEmail;
  String? profilePictureUrl;
  String? userName;
  String? fcmToken;
  String? accountType;
  String? userPhoneNumber;
  String? userAddress;

  UserResponseModel({
    this.userId,
    this.userEmail,
    this.profilePictureUrl,
    this.userName,
    this.fcmToken,
    this.accountType,
    this.userPhoneNumber,
    this.userAddress,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        userId: json["userId"],
        userEmail: json["userEmail"],
        profilePictureUrl: json["profilePictureUrl"],
        userName: json["userName"],
        fcmToken: json["fcmToken"],
        accountType: json["accountType"],
        userPhoneNumber: json["userPhoneNumber"],
        userAddress: json["userAddress"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userEmail": userEmail,
        "profilePictureUrl": profilePictureUrl,
        "userName": userName,
        "fcmToken": fcmToken,
        "accountType": accountType,
        "userPhoneNumber": userPhoneNumber,
        "userAddress": userAddress,
      };
}
