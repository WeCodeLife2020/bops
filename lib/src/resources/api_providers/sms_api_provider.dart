import 'package:bops_mobile/src/models/send_message_request_model.dart';
import 'package:bops_mobile/src/models/send_message_response_model.dart';

import '../../models/state.dart';
import '../../utils/object_factory.dart';

class SmsApiProvider {
  Future<State?> sendMessage(
      SendMessageRequestModel sendMessageRequestModel) async {
    try {
      final response =
          await ObjectFactory().apiClient.sendMessage(sendMessageRequestModel);
      print(response);
      if (response.statusCode == 200) {
        print(response.toString());
        return State<SendMessageResponseModel>.success(
            SendMessageResponseModel.fromJson(response.data));
      } else {
        return State<String>.error(response.data["message"]);
      }
    } catch (e) {
      return State.error(e);
    }
  }
}
