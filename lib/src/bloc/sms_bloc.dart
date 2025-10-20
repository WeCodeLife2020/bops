import 'dart:async';

import 'package:bops_mobile/src/bloc/base_bloc.dart';
import 'package:bops_mobile/src/models/send_message_request_model.dart';
import 'package:bops_mobile/src/models/send_message_response_model.dart';

import '../models/state.dart';
import '../utils/constants.dart';
import '../utils/object_factory.dart';
import '../utils/validators.dart';

class SmsBloc extends Object with Validators implements BaseBloc {
  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<SendMessageResponseModel> _sendMessage =
      StreamController<SendMessageResponseModel>.broadcast();

  Stream<bool> get loadingListener => _loading.stream;
  Stream<SendMessageResponseModel> get sendMessageListener =>
      _sendMessage.stream;

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<SendMessageResponseModel> get sendMessageSink => _sendMessage.sink;

  sendMessage(
      {required SendMessageRequestModel sendMessageRequestModel}) async {
    loadingSink.add(true);
    State? state = await ObjectFactory()
        .repository
        .sendMessage(sendMessageRequestModel: sendMessageRequestModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      sendMessageSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      sendMessageSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  @override
  void dispose() {
    _loading.close();
    _sendMessage.close();
  }
}
