

import 'dart:math';

import 'package:bops_mobile/src/models/center_response_model.dart';
import 'package:bops_mobile/src/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/object_factory.dart';

class CenterFirebaseProvider {


  Future<State?> addCenter({required CenterResponseModel centerResponseModel}) async {
    try {
      print(centerResponseModel.toJson());
     String? result= await ObjectFactory()
          .firebaseClient
          .addCenter(centerResponseModel: centerResponseModel);

      return State.success(result);
    } catch (e) {
      return State.error(
          "Error on adding center: $e");
    }
  }

    Future<State?> getCenters() async {
      final dynamic result = await ObjectFactory()
          .firebaseClient
          .getCenters();

      if (result != null) {
        return State.success(result);
      } else {
        return State.error("Fetching centers failed");
      }
    }

  Future<State?> deleteCenter({required centerId}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .deleteCenter(centerId: centerId);
      return State.success(
          "Center delete successfully");
    } catch (e) {
      return State.error(
          "Error on delete center: $e");
    }
  }

  Future<State?> updateCenterName({required centerId,required centerName}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .updateCenterName(centerId: centerId, centerName: centerName);
      return State.success(
          "Center name update successfully");
    } catch (e) {
      return State.error(
          "Error on name update center: $e");
    }
  }

  Future<State?> updateCenterDates(
      {required centerId}) async {
    try {
      await ObjectFactory()
          .firebaseClient
          .updateCenterDates(centerId: centerId);
      return State.success("Center dates updated successfully");
    } catch (e) {
      return State.error("Error on updating center dates: $e");
    }
  }

  Future<State?> getTokenNumber({required centerId}) async {
    try {
     int? tokenNumber= await ObjectFactory()
          .firebaseClient
          .getTokenNumber(centerId: centerId);
      return State.success(tokenNumber);
    } catch (e) {
      return State.error("Error in fetching token number: $e");
    }
  }
  Future<State?> getSheetId({required centerId}) async {
    try {
      String? sheetId= await ObjectFactory()
          .firebaseClient
          .getSheetId(centerId: centerId);
      return State.success(sheetId);
    } catch (e) {
      return State.error("Error in fetching token number: $e");
    }
  }
  Future<State?> getSheetCreatedDate({required centerId}) async {
    try {
      DateTime? sheetCreatedDate= await ObjectFactory()
          .firebaseClient
          .getSheetCreatedDate(centerId: centerId);
      return State.success(sheetCreatedDate);
    } catch (e) {
      return State.error("Error in fetching token number: $e");
    }
  }

  Future<State?> updateTokenNumber({required centerId}) async {
    try {
      int? tokenNumber = await ObjectFactory()
          .firebaseClient
          .updateTokenNumber(centerId: centerId);
      return State.success(tokenNumber);
    } catch (e) {
      return State.error("Error updating token number: $e");
    }
  }
  Future<State?> updateCenterSheetId({required centerId,required sheetId}) async {
    try {
      void t = await ObjectFactory()
          .firebaseClient
          .updateCenterSheetId(centerId: centerId, sheetId: sheetId);
      return State.success("center sheet Id update successfully");
    } catch (e) {
      return State.error("Error updating sheet id: $e");
    }
  }
  Future<State?>getCenterNameByCenterId({required String centerId,
    required String userId,
    required bool isManager})async{
    try {
      String? centerName = await ObjectFactory().firebaseClient
          .getCenterNameByCenterId(
          centerId: centerId, userId: userId, isManager: isManager);
      return State.success(centerName);
    }catch(e){
      return State.error("Error get center name : $e ");
    }
  }

  Future<State?>getIsDeleted({required String centerId})async{
    try {
      bool? isDeleted = await ObjectFactory().firebaseClient
          .getIsDeleted(centerId: centerId);
      if(isDeleted==null){
        return State.error("Error get center delete status : $e ");
      }
      else {
        return State.success(isDeleted);

      }
    }catch(e){
      return State.error("Error get center delete status : $e ");
    }
  }

}