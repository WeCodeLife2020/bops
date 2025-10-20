import 'dart:async';

import 'package:bops_mobile/src/bloc/base_bloc.dart';
import 'package:bops_mobile/src/utils/constants.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/state.dart';

class UserAuthBloc extends Object with Validators implements BaseBloc {
  ///Conttrollers

  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<UserCredential> _login =
      StreamController<UserCredential>.broadcast();
  final StreamController<dynamic> _signOut =
      StreamController<dynamic>.broadcast();

  /// Stream

  Stream<bool> get loadingListener => _loading.stream;
  Stream<UserCredential> get loginResponse => _login.stream;
  Stream<dynamic> get signOutResponse => _signOut.stream;

  /// Sink

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<UserCredential> get loginSink => _login.sink;
  StreamSink<dynamic> get signOutSink => _signOut.sink;

  /// Functions

  login() async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.login();
    if (state is SuccessState) {
      loadingSink.add(false);
      loginSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      loginSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }


  signOut() async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.signOut();
    if (state is SuccessState) {
      loadingSink.add(false);
      signOutSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      signOutSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  @override
  void dispose() {
    _loading.close();
    _login.close();
    _signOut.close();
  }
}
