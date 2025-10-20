// To parse this JSON data, do
//
//     final sendMessageRequestModel = sendMessageRequestModelFromJson(jsonString);

import 'dart:convert';

SendMessageRequestModel sendMessageRequestModelFromJson(String str) =>
    SendMessageRequestModel.fromJson(json.decode(str));

String sendMessageRequestModelToJson(SendMessageRequestModel data) =>
    json.encode(data.toJson());

class SendMessageRequestModel {
  String templateId;
  String shortUrl;
  String realTimeResponse;
  List<Recipient> recipients;

  SendMessageRequestModel({
    required this.templateId,
    required this.shortUrl,
    required this.realTimeResponse,
    required this.recipients,
  });

  factory SendMessageRequestModel.fromJson(Map<String, dynamic> json) =>
      SendMessageRequestModel(
        templateId: json["template_id"],
        shortUrl: json["short_url"],
        realTimeResponse: json["realTimeResponse"],
        recipients: List<Recipient>.from(
            json["recipients"].map((x) => Recipient.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "template_id": templateId,
        "short_url": shortUrl,
        "realTimeResponse": realTimeResponse,
        "recipients": List<dynamic>.from(recipients.map((x) => x.toJson())),
      };
}

class Recipient {
  String mobiles;
  String var1;
  String var2;
  String var3;

  Recipient({
    required this.mobiles,
    required this.var1,
    required this.var2,
    required this.var3,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        mobiles: json["mobiles"],
        var1: json["var1"],
        var2: json["var2"],
        var3: json["var3"],
      );

  Map<String, dynamic> toJson() => {
        "mobiles": mobiles,
        "var1": var1,
        "var2": var2,
        "var3": var3,
      };
}
