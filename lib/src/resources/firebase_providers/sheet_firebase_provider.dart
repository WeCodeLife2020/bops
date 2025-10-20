import 'package:bops_mobile/src/models/state.dart';

import '../../models/sheet_details_firebase_response_model.dart';
import '../../utils/object_factory.dart';

class SheetFirebaseProvider{

  Future<State?> addSheetDetailsToFirebase({required SheetDetailsFirebaseResponseModel sheetDetailsFirebaseResponseModel}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .addSheetDetailsToFirebase(sheetDetailsFirebaseResponseModel: sheetDetailsFirebaseResponseModel);
      return State.success(
          "Sheet details added successfully");
    } catch (e) {
      return State.error(
          "Error on adding sheet details: $e");
    }
  }

  Future<State?> getSheetDetails({required centerId,required int limit}) async {
    try {
     final dynamic resuilt= await ObjectFactory()
          .firebaseClient
          .getSheetDetails(centerId: centerId,limit: limit);
      return State.success(resuilt);
    } catch (e) {
      return State.error(
          "Error on get sheet details: $e");
    }
  }
}