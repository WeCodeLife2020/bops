import 'dart:convert';

SendMessageResponseModel sendMessageResponseModelFromJson(String str) =>
    SendMessageResponseModel.fromJson(json.decode(str));

String sendMessageResponseModelToJson(SendMessageResponseModel data) =>
    json.encode(data.toJson());

class SendMessageResponseModel {
  String? message;
  String? type;

  SendMessageResponseModel({
    this.message,
    this.type,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      SendMessageResponseModel(
        message: json["message"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "type": type,
      };
}
