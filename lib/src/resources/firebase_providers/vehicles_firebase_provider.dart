import 'package:bops_mobile/src/models/state.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';

class VehiclesFirebaseProvider {
  Future<State?> addVehicleDetailsToFirebase({
    required VehicleDetailsFirebaseResponseModel
        vehicleDetailsFirebaseResponseModel,
    // required int tokenNumber,
    // required int valetCarNumber,
  }) async {
    VehicleDetailsFirebaseResponseModel? result =
        await ObjectFactory().firebaseClient.addVehicleDetailsToFirebase(
              vehicleDetailsFirebaseResponseModel:
                  vehicleDetailsFirebaseResponseModel,
              // tokenNumber: tokenNumber,
              // valetCarNumber: valetCarNumber,
            );

    if (result != null) {
      return State<VehicleDetailsFirebaseResponseModel>.success(result);
    } else {
      return State.error("Adding vehicle details to firebase failed");
    }
  }

  Future<State?> getTickets(
      {required String centerId, required String vehicleStatus}) async {
    final List<VehicleDetailsFirebaseResponseModel>? result =
        await ObjectFactory()
            .firebaseClient
            .getTickets(centerId: centerId, vehicleStatus: vehicleStatus);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Fetching tickets failed");
    }
  }

  Future<State?> updateTicket(
      {required VehicleDetailsFirebaseResponseModel
          vehicleDetailsFirebaseResponseModel}) async {
    final bool? result = await ObjectFactory().firebaseClient.updateTicket(
        vehicleDetailsFirebaseResponseModel:
            vehicleDetailsFirebaseResponseModel);

    if (result == true) {
      return State.success("Ticket updation successfull");
    } else {
      return State.error("Ticket updation failed");
    }
  }

  Future<State?> prefetchVehicleDetails(
      {required String registrationNumber}) async {
    final VehicleDetailsFirebaseResponseModel? result = await ObjectFactory()
        .firebaseClient
        .prefetchCarDetails(registrationNumber: registrationNumber);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Prefetching vehicle details failed");
    }
  }

  Future<State?> searchVehicleDetails({
    String? registrationNumber,
    int? valetCarNumber,
    required String centerId,
  }) async {
    final VehicleDetailsFirebaseResponseModel? result =
        await ObjectFactory().firebaseClient.searchVehicleDetails(
              registrationNumber: registrationNumber,
              valetCarNumber: valetCarNumber,
              centerId: centerId,
            );

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Search Vehicle Details Failed");
    }
  }

  Future<State?> getRequestedVehicleDetails(
      {required String centerId, required int limit}) async {
    final List<VehicleDetailsFirebaseResponseModel>? result =
        await ObjectFactory()
            .firebaseClient
            .getRequestedVehicleDetails(centerId: centerId, limit: limit);

    if (result != null) {
      return State.success(result);
    } else {
      return State.error("Fetching tickets failed");
    }
  }

  Future<State?> updateVehicleParkedLocation(
      {required String documentId, required String parkedLocation}) async {
    try {
      await ObjectFactory().firebaseClient.updateVehicleParkedLocation(
          documentId: documentId, parkedLocation: parkedLocation);
      return State.success("Vehicle location update successfully");
    } catch (e) {
      return State.error("Vehicle location update failed");
    }
  }

  Future<State?> getPaymentCount({
    required String centerId,
  }) async {
    try {
      final List<dynamic> result = await ObjectFactory()
          .firebaseClient
          .getPaymentCount(centerId: centerId);
      return State.success(result);
    } catch (e) {
      return State.error("payment method count get failed");
    }
  }
}
