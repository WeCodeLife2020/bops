import 'dart:async';

import 'package:bops_mobile/src/bloc/base_bloc.dart';
import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';
import 'package:bops_mobile/src/utils/validators.dart';

import '../utils/constants.dart';
import '../utils/object_factory.dart';

class SheetBloc extends Object with Validators implements BaseBloc {

  final StreamController<bool> _loading = StreamController<bool>.broadcast();
  final StreamController<dynamic> _addSheetDetailsToFireBase =StreamController<dynamic>.broadcast();
  final StreamController<List<SheetDetailsFirebaseResponseModel>?> _getSheetDetails =StreamController<List<SheetDetailsFirebaseResponseModel>?>.broadcast();


  /// Stream

  Stream<bool> get loadingListener => _loading.stream;
  Stream<dynamic> get addSheetDetailsToFirebaseListener => _addSheetDetailsToFireBase.stream;
  Stream<List<SheetDetailsFirebaseResponseModel>?> get getSheetDetailsListener => _getSheetDetails.stream;


  /// Sink

  StreamSink<bool> get loadingSink => _loading.sink;
  StreamSink<dynamic> get addSheetDetailsToFirebaseSink => _addSheetDetailsToFireBase.sink;
  StreamSink<List<SheetDetailsFirebaseResponseModel>?> get getSheetDetailsSink => _getSheetDetails.sink;



  addSheetDetailsToFirebase({required SheetDetailsFirebaseResponseModel sheetDetailsFirebaseResponseModel }) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.addSheetDetailsToFirebase(sheetDetailsFirebaseResponseModel: sheetDetailsFirebaseResponseModel);
    if (state is SuccessState) {
      loadingSink.add(false);
      addSheetDetailsToFirebaseSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      addSheetDetailsToFirebaseSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }

  getSheetDetails({required centerId,required int limit }) async {
    loadingSink.add(true);
    State? state = await ObjectFactory().repository.getSheetDetails(centerId: centerId,limit: limit);
    if (state is SuccessState) {
      loadingSink.add(false);
      getSheetDetailsSink.add(state.value);
    } else if (state is ErrorState) {
      loadingSink.add(false);
      getSheetDetailsSink.addError(Constants.SOME_ERROR_OCCURRED);
    }
  }





  @override
  void dispose() {
    // TODO: implement dispose
    _loading.close();
    _addSheetDetailsToFireBase.close();
    _getSheetDetails.close();
  }
}