
import 'dart:async';
import 'package:bops_mobile/src/models/login_request_model.dart';
import 'package:bops_mobile/src/models/login_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';
import 'package:bops_mobile/src/utils/constants.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/validators.dart';
import 'base_bloc.dart';

/// api response of login is managed by AuthBloc
/// stream data is handled by StreamControllers

class UserBloc extends Object with Validators implements BaseBloc {
  final StreamController<bool> _loading = StreamController<bool>.broadcast();


  /// stream for progress bar
  Stream<bool> get loadingListener => _loading.stream;


  StreamSink<bool> get loadingSink => _loading.sink;

 
  ///disposing the stream if it is not using
  @override
  void dispose() {
  
  }
}


