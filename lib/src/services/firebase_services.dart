import 'package:bops_mobile/src/models/manager_response_model.dart';
import 'package:bops_mobile/src/models/sheet_details_firebase_response_model.dart';
import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/models/vehicle_details_firebase_response_model.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/center_response_model.dart';
import '../models/driver_response_model.dart';

class FirebaseServices {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// for google sign in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await ObjectFactory().auth.signInWithCredential(credential);
      } else {
        print("Google sign-in canceled by user");
        return null;
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      // showToast("Error signing in with Google: $e");
      return null;
    }
  }

  /// for signing out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await ObjectFactory().auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
      // showToast("Error signing out: $e");
    }
  }

  /// for adding or updating user account
  Future<DocumentReference?> addOrUpdateUser({
    required UserResponseModel userResponseModel,
  }) async {
    try {
      print(userResponseModel.userEmail);
      // Check if the user with the given userId already exists
      final QuerySnapshot snapshot = await firebaseFirestore
          .collection("users")
          .where("userId", isEqualTo: userResponseModel.userId)
          .limit(1)
          .get();

      // If the user exists, update the document
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot existingDoc = snapshot.docs.first;

        // Check for a matching manager email
        QuerySnapshot managerSnapshot = await firebaseFirestore
            .collection("managers")
            .where("managerEmail", isEqualTo: userResponseModel.userEmail)
            .limit(1)
            .get();

        QuerySnapshot driverSnapshot = await firebaseFirestore
            .collection("drivers")
            .where("driverEmail", isEqualTo: userResponseModel.userEmail)
            .limit(1)
            .get();
        // Update the existing user document
        Map<String, dynamic> updateData = {
          "fcmToken": userResponseModel.fcmToken,
          "profilePictureUrl": userResponseModel.profilePictureUrl,
          // "userName": userResponseModel.userName,
        };

        // If a matching manager is found, update additional fields
        if (managerSnapshot.docs.isNotEmpty) {
          DocumentSnapshot managerDoc = managerSnapshot.docs.first;
          updateData.addAll({
            "userPhoneNumber": managerDoc.get("managerPhoneNumber"),
            // Set userPhoneNumber to managerPhoneNumber
            "userAddress": managerDoc.get("managerAddress"),
            // Set userAddress to managerAddress
            "userName": managerDoc.get('managerName'),
            "accountType": "manager"
          });

          // Update managerUserId in the managers collection
          await managerDoc.reference.update({
            "managerUserId": userResponseModel.userId,
            // "managerName": userResponseModel
            //     .userName, // remove if no need to update the manager name
          });
        } else if (driverSnapshot.docs.isNotEmpty) {
          print('inner driver snap shot');
          DocumentSnapshot driverDoc = driverSnapshot.docs.first;
          updateData.addAll({
            "userPhoneNumber": driverDoc.get("driverPhoneNumber"),
            // Set userPhoneNumber to driverPhoneNumber
            "userAddress": driverDoc.get("driverAddress"),
            // Set userAddress to driverAddress
            "userName": driverDoc.get('driverName'),
            "accountType": "driver"
          });
          print(userResponseModel.userId);
          // Update driverId in the driver collection
          await driverDoc.reference.update({
            "driverUserId": userResponseModel.userId,
            // "driverName": userResponseModel
            //     .userName, // remove if no need to update the manager name
          });
        }

        await existingDoc.reference.update(updateData);
        return existingDoc.reference;
      } else {
        // If the user doesn't exist, create a new document with the userId as the document ID
        DocumentReference response =
            firebaseFirestore.collection("users").doc(userResponseModel.userId);

        // Check for a matching manager email
        QuerySnapshot managerSnapshot = await firebaseFirestore
            .collection("managers")
            .where("managerEmail", isEqualTo: userResponseModel.userEmail)
            .limit(1)
            .get();

        // Create the new user data
        Map<String, dynamic> newUserData = userResponseModel.toJson();

        // If a matching manager is found, set additional fields
        if (managerSnapshot.docs.isNotEmpty) {
          DocumentSnapshot managerDoc = managerSnapshot.docs.first;
          newUserData.addAll({
            "userPhoneNumber": managerDoc.get("managerPhoneNumber"),
            "userAddress": managerDoc.get("managerAddress"),
            "userName": managerDoc.get('managerName'),
            "accountType": "manager"
          });

          // Update the manager document with the new user ID
          await managerDoc.reference.update({
            "managerUserId": userResponseModel.userId,
            // "managerName": userResponseModel
            //     .userName, // remove if no need to update manager name
          });
        } else {
          print(userResponseModel.userEmail);
          QuerySnapshot driverSnapshot = await firebaseFirestore
              .collection("drivers")
              .where("driverEmail", isEqualTo: userResponseModel.userEmail)
              .limit(1)
              .get();
          if (driverSnapshot.docs.isNotEmpty) {
            DocumentSnapshot driverDoc = driverSnapshot.docs.first;
            newUserData.addAll({
              "userPhoneNumber": driverDoc.get("driverPhoneNumber"),
              "userAddress": driverDoc.get("driverAddress"),
              "userName": driverDoc.get('driverName'),
              "accountType": "driver"
            });

            await driverDoc.reference.update({
              "driverUserId": userResponseModel.userId,
            });
          }
        }

        await response.set(newUserData);
        return response;
      }
    } catch (e) {
      print("Error while adding/updating data: $e");
      return null;
    }
  }

  /// for clearing fcm token
  Future<DocumentReference?> clearFcmToken({required String userId}) async {
    try {
      // Fetch the document from the "users" collection where the document ID is the userId
      DocumentReference userDocRef =
          firebaseFirestore.collection("users").doc(userId);

      // Update the fcmToken field to an empty string
      await userDocRef.update({"fcmToken": ""});

      // Return the reference to the updated document
      return userDocRef;
    } catch (e) {
      print("Error while clearing FCM token: $e");
      return null;
    }
  }

  /// for fetching phone number and address
  Future<Map<String, dynamic>?> getPhoneAndAddress(
      {required String userId}) async {
    try {
      // Fetch the document from the "users" collection where the document ID is the userId
      DocumentReference userDocRef =
          firebaseFirestore.collection("users").doc(userId);

      // Get the document snapshot
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Check if the document exists
      if (userDocSnapshot.exists) {
        // Retrieve the fields userAddress and userPhoneNumber
        String? userAddress = userDocSnapshot.get('userAddress');
        String? userPhoneNumber = userDocSnapshot.get('userPhoneNumber');

        // Return the retrieved fields as a map
        return {
          'userAddress': userAddress,
          'userPhoneNumber': userPhoneNumber,
        };
      } else {
        print("User document does not exist.");
        return null;
      }
    } catch (e) {
      print("Error while fetching phone and address: $e");
      return null;
    }
  }

  /// for updating phone number and address
  Future<DocumentReference?> updatePhoneAndAddress({
    required String userId,
    required String address,
    required String phoneNumber,
  }) async {
    try {
      // Reference to the users collection and the specific user document
      DocumentReference userDocRef =
          firebaseFirestore.collection("users").doc(userId);

      // Update the userAddress and userPhoneNumber fields
      await userDocRef.update({
        'userAddress': address,
        'userPhoneNumber': phoneNumber,
      });

      // Now update the corresponding document in the managers collection
      QuerySnapshot managerQuery = await firebaseFirestore
          .collection("managers")
          .where('managerUserId', isEqualTo: userId)
          .get();

      if (managerQuery.docs.isNotEmpty) {
        // Assuming managerUserId is unique, get the first document
        DocumentSnapshot managerDoc = managerQuery.docs.first;

        // Update the managerAddress and managerPhoneNumber fields
        await managerDoc.reference.update({
          'managerAddress': address,
          'managerPhoneNumber': phoneNumber,
        });
      }

      // Return the reference to the updated user document
      return userDocRef;
    } catch (e) {
      print("Error while updating phone and address: $e");
      return null;
    }
  }

  /// for fetching all users
  Future<List<UserResponseModel>> getAllUsers() async {
    try {
      // Fetch all documents from the "users" collection
      QuerySnapshot querySnapshot =
          await firebaseFirestore.collection("users").get();

      // Convert the documents into a list of UserResponseModel
      List<UserResponseModel> users = querySnapshot.docs.map((doc) {
        return UserResponseModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return users;
    } catch (e) {
      print("Error while fetching users: $e");
      return [];
    }
  }

  /// for fetching user data
  Future<UserResponseModel?> getUserData({required String userId}) async {
    try {
      // Fetch the document from the "users" collection where the document ID is userId
      DocumentReference userDocRef =
          firebaseFirestore.collection("users").doc(userId);

      // Get the document snapshot
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Check if the document exists
      if (userDocSnapshot.exists) {
        // Convert the document data into a UserResponseModel
        return UserResponseModel.fromJson(
            userDocSnapshot.data() as Map<String, dynamic>);
      } else {
        print("User document does not exist.");
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print("Error while fetching user data: $e");
      return null; // Return null in case of an error
    }
  }

  /// for adding manager
  Future<DocumentReference?> addManager({
    required ManagerResponseModel managerResponseModel,
  }) async {
    try {
      // Check for existing manager with the same email
      QuerySnapshot managerQuerySnapshot = await firebaseFirestore
          .collection("managers")
          .where("managerEmail", isEqualTo: managerResponseModel.managerEmail)
          .get();

      // If a matching manager document is found, do not add a new one
      if (managerQuerySnapshot.docs.isNotEmpty) {
        print("A manager with this email already exists.");
        return null; // Return null if a manager with the same email exists
      }

      // Create a new document reference for the manager
      DocumentReference managerDocRef =
          firebaseFirestore.collection("managers").doc();

      // Set the new manager document
      await managerDocRef.set({
        ...managerResponseModel.toJson(),
        "managerId": managerDocRef.id,
      });

      // Check for existing user with the same email
      QuerySnapshot userQuerySnapshot = await firebaseFirestore
          .collection("users")
          .where("userEmail", isEqualTo: managerResponseModel.managerEmail)
          .get();

      // If a matching user document is found, update it
      if (userQuerySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;
        managerDocRef.update({"managerUserId": userDocSnapshot.get("userId")});
        await userDocSnapshot.reference.update({
          "userPhoneNumber": managerResponseModel.managerPhoneNumber,
          "userAddress": managerResponseModel.managerAddress,
          "userName": managerResponseModel.managerName,
          "accountType": "manager",
        });
      }

      return managerDocRef;
    } catch (e) {
      print("Error while adding manager: $e");
      return null;
    }
  }

  /// for getting managers
  Future<List<ManagerResponseModel>> fetchManagers(
      {required bool isSuspended}) async {
    List<ManagerResponseModel> managers = [];

    try {
      // Fetch all documents from the "managers" collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("managers").get();

      // Iterate through the documents and filter based on isSuspended
      for (var doc in querySnapshot.docs) {
        var manager =
            ManagerResponseModel.fromJson(doc.data() as Map<String, dynamic>)
              ..managerId = doc.id;

        // Check if the manager's isSuspended matches the passed parameter
        if (manager.isSuspended == isSuspended) {
          managers.add(manager);
        }
      }
    } catch (e) {
      print("Error fetching managers: $e");
    }

    return managers; // Return the filtered list of managers
  }

  /// for getting managers
  Future<void> updateSuspendStatus({required String managerId}) async {
    try {
      // Fetch the document with the given managerId
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection("managers")
          .doc(managerId)
          .get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Convert the document data to ManagerResponseModel
        var manager = ManagerResponseModel.fromJson(
            docSnapshot.data() as Map<String, dynamic>);

        manager.isSuspended = !(manager.isSuspended ?? false);

        await docSnapshot.reference.update({
          'isSuspended': manager.isSuspended,
        });

        print("Manager suspend status updated to ${manager.isSuspended}");
      } else {
        print("Manager with ID $managerId does not exist.");
      }
    } catch (e) {
      print("Error updating suspend status: $e");
    }
  }

  /// to get if the user is suspended
  Future<bool> getIsSuspended({required String userId}) async {
    try {
      // Reference to the 'managers' collection
      CollectionReference managersCollection =
          FirebaseFirestore.instance.collection('managers');

      // Query the collection for the document where managerUserId matches the userId
      QuerySnapshot querySnapshot = await managersCollection
          .where('managerUserId', isEqualTo: userId)
          .get();

      // Check if any documents were returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming managerUserId is unique)
        DocumentSnapshot document = querySnapshot.docs.first;

        // Retrieve the data as a Map
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        // Retrieve the isSuspended field
        bool isSuspended = data['isSuspended'] ?? false;

        return isSuspended;
      } else {
        return false;
      }
    } catch (e) {
      print('Error fetching suspension status: $e');
      return false;
    }
  }

  /// to get center name
  Future<String?> getCenterName({required String userId}) async {
    // Reference to the Firestore collection
    CollectionReference managersCollection =
        FirebaseFirestore.instance.collection('managers');

    try {
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot = await managersCollection
          .where('managerUserId', isEqualTo: userId)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's centerName field
        String centerName = querySnapshot.docs.first['managerCenter'];
        return centerName; // Return the centerName
      } else {
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching center name: $e');
      return null; // Return null in case of an error
    }
  }

  /// to get center name
  Future<String?> getCenterId({required String userId}) async {
    // Reference to the Firestore collection
    CollectionReference managersCollection =
        FirebaseFirestore.instance.collection('managers');

    try {
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot = await managersCollection
          .where('managerUserId', isEqualTo: userId)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's centerId field
        String centerId = querySnapshot.docs.first['managerCenterId'];
        return centerId; // Return the centerId
      } else {
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching center id: $e');
      return null; // Return null in case of an error
    }
  }

  /// to get center name
  Future<String?> getManagerId({required String userId}) async {
    // Reference to the Firestore collection
    CollectionReference managersCollection =
        FirebaseFirestore.instance.collection('managers');

    try {
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot = await managersCollection
          .where('managerUserId', isEqualTo: userId)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's managerId field
        String managerId = querySnapshot.docs.first['managerId'];
        return managerId; // Return the managerId
      } else {
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching manager id: $e');
      return null; // Return null in case of an error
    }
  }

  Future<String?> addCenter(
      {required CenterResponseModel centerResponseModel}) async {
    try {
      // Create a Map from the CenterResponseModel, setting server timestamps
      final centerData = {
        'centerName': centerResponseModel.centerName,
        'tokenNumber': centerResponseModel.tokenNumber,
        'currentDate': FieldValue.serverTimestamp(),
        'previousDate': FieldValue.serverTimestamp(),
        'sheetId': centerResponseModel.sheetId,
        'sheetCreatedDate': FieldValue.serverTimestamp(),
        'isDelete': centerResponseModel.isDelete,
        'valetCarNumber': centerResponseModel.valetCarNumber,
      };

      // Add a new document in the 'centers' collection
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('centers')
          .add(centerData);

      // Update the document with the centerId
      await docRef.update({'centerId': docRef.id});

      print('Center added successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      return null;
      print('Failed to add center: $e');
    }
  }

  Future<List<CenterResponseModel>> getCenters() async {
    List<CenterResponseModel> centers = [];
    CollectionReference centersCollection =
        FirebaseFirestore.instance.collection("centers");
    try {
      QuerySnapshot querySnapshot = await centersCollection
          .where('isDelete', isEqualTo: false)
          .orderBy(FieldPath.documentId, descending: true)
          .get();
      for (var doc in querySnapshot.docs) {
        var center =
            CenterResponseModel.fromJson(doc.data() as Map<String, dynamic>)
              ..centerId = doc.id;
        centers.add(center);
      }
      print("Centers fetched successfully");
    } catch (e) {
      print("Error on get center: $e");
    }
    return centers;
  }

  Future<void> deleteCenter({required centerId}) async {
    try {
      await firebaseFirestore
          .collection("centers")
          .doc(centerId)
          .update({'isDelete': true});
      print("Center deleted successfully");
    } catch (e) {
      print("Error on deleting center: $e");
    }
  }

  Future<void> updateCenterName(
      {required centerId, required centerName}) async {
    try {
      await firebaseFirestore
          .collection("centers")
          .doc(centerId)
          .update({'centerName': centerName});
      print("Center updated  successfully");
    } catch (e) {
      print("Error on updating center: $e");
    }
  }

  Future<void> updateCenterDates({required String centerId}) async {
    try {
      // Get the document snapshot for the specified centerId
      DocumentSnapshot doc =
          await firebaseFirestore.collection("centers").doc(centerId).get();

      if (doc.exists) {
        // Get the current date and yesterday's date
        Timestamp currentDate = Timestamp.now();
        Timestamp previousDate = Timestamp.fromMillisecondsSinceEpoch(
            currentDate.millisecondsSinceEpoch -
                const Duration(days: 1).inMilliseconds);

        // Retrieve the current data from Firestore
        Timestamp firestoreCurrentDate = doc['currentDate'] as Timestamp;
        Timestamp firestorePreviousDate = doc['previousDate'] as Timestamp;

        // Check if the currentDate and previousDate need to be updated
        bool needsUpdate = false;

        // Check if currentDate is not today
        if (firestoreCurrentDate.toDate().day != currentDate.toDate().day ||
            firestoreCurrentDate.toDate().month != currentDate.toDate().month ||
            firestoreCurrentDate.toDate().year != currentDate.toDate().year) {
          needsUpdate = true;
        }

        // Check if previousDate is not yesterday
        if (firestorePreviousDate.toDate().day != previousDate.toDate().day ||
            firestorePreviousDate.toDate().month !=
                previousDate.toDate().month ||
            firestorePreviousDate.toDate().year != previousDate.toDate().year) {
          needsUpdate = true;
        }

        if (needsUpdate) {
          // Update the document with new currentDate, previousDate, and reset tokenNumber
          await firebaseFirestore.collection("centers").doc(centerId).update({
            'currentDate': currentDate,
            'previousDate': previousDate,
            'tokenNumber': 0, // Reset tokenNumber to 0
          });
          print("Token number and date changes occured");
        } else {
          print("No updates were necessary. Token number remains unchanged.");
        }
      } else {
        print("Document with ID $centerId does not exist.");
      }
    } catch (e) {
      print("Error on updating center dates: $e");
    }
  }

  Future<int?> getTokenNumber({required String centerId}) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot doc =
          await firebaseFirestore.collection("centers").doc(centerId).get();

      // Check if the document exists
      if (doc.exists) {
        // Retrieve the tokenNumber from the document data
        int? tokenNumber = doc['tokenNumber'] as int?;
        return tokenNumber;
      } else {
        print("Document with ID $centerId does not exist.");
        return null; // Return null if the document does not exist
      }
    } catch (e) {
      print("Error retrieving token number: $e");
      return null; // Return null in case of an error
    }
  }

  Future<String?> getSheetId({required String centerId}) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot doc =
          await firebaseFirestore.collection("centers").doc(centerId).get();

      // Check if the document exists
      if (doc.exists) {
        // Retrieve the tokenNumber from the document data
        String? tokenNumber = doc['sheetId'];
        return tokenNumber;
      } else {
        print("Document with ID $centerId does not exist.");
        return null; // Return null if the document does not exist
      }
    } catch (e) {
      print("Error retrieving sheet Id: $e");
      return null; // Return null in case of an error
    }
  }

  Future<DateTime?> getSheetCreatedDate({required String centerId}) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot doc =
          await firebaseFirestore.collection("centers").doc(centerId).get();

      // Check if the document exists
      if (doc.exists) {
        // Retrieve the tokenNumber from the document data
        Timestamp? sheetCreatedDate = doc['sheetCreatedDate'];
        return sheetCreatedDate?.toDate();
      } else {
        print("Document with ID $centerId does not exist.");
        return null; // Return null if the document does not exist
      }
    } catch (e) {
      print("Error retrieving  sheet create date : $e");
      return null; // Return null in case of an error
    }
  }

  Future<int?> updateTokenNumber({required String centerId}) async {
    try {
      // Reference the document in Firestore
      DocumentReference docRef =
          firebaseFirestore.collection("centers").doc(centerId);

      // Fetch the document snapshot
      DocumentSnapshot doc = await docRef.get();

      // Check if the document exists
      if (doc.exists) {
        // Retrieve the current tokenNumber from the document data
        int currentTokenNumber = (doc['tokenNumber']);

        // Increment the tokenNumber
        int updatedTokenNumber = currentTokenNumber + 1;

        // Update the tokenNumber in Firestore
        await docRef.update({'tokenNumber': updatedTokenNumber});

        print("Token number updated to: $updatedTokenNumber");
        return updatedTokenNumber; // Return the updated token number
      } else {
        print("Document with ID $centerId does not exist.");
        return null; // Return null if the document does not exist
      }
    } catch (e) {
      print("Error updating token number: $e");
      return null; // Return null in case of an error
    }
  }

  // for adding vehicle details to firebase
  Future<VehicleDetailsFirebaseResponseModel?> addVehicleDetailsToFirebase({
    required VehicleDetailsFirebaseResponseModel
        vehicleDetailsFirebaseResponseModel,
  }) async {
    int? valetCarNumber;
    int? tokenNumber;
    VehicleDetailsFirebaseResponseModel? addedVehicleDetails;

    try {
      final vehicleData = vehicleDetailsFirebaseResponseModel.toJson();

      vehicleData['checkInTime'] = FieldValue.serverTimestamp();

      final centerDocRef = firebaseFirestore
          .collection("centers")
          .doc(vehicleDetailsFirebaseResponseModel.centerId);

      bool transactionSuccessful = false;

      await firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot centerDocSnp = await transaction.get(centerDocRef);

        if (centerDocSnp["tokenNumber"] == null ||
            centerDocSnp["valetCarNumber"] == null) {
          return null;
        } else {
          debugPrint(
              "FETCHED TOKEN NUMBER: ${centerDocSnp["tokenNumber"].toString()}");
          debugPrint(
              "FETCHED VALET CAR NUMBER: ${centerDocSnp["valetCarNumber"].toString()}");

          transaction.update(centerDocRef, {
            "valetCarNumber": centerDocSnp["valetCarNumber"] >= 9999
                ? 0
                : FieldValue.increment(1),
            "tokenNumber": FieldValue.increment(1),
          });

          transactionSuccessful = true;
          tokenNumber = centerDocSnp["tokenNumber"] + 1;
          valetCarNumber = centerDocSnp["valetCarNumber"] + 1;
        }
      }).catchError((error) {
        print("Failed to update center: $error");
        transactionSuccessful = false;
        return null;
      });

      if (transactionSuccessful) {
        vehicleData["tokenNumber"] = tokenNumber;
        vehicleData["valetCarNumber"] = valetCarNumber;
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection("tickets")
            .add(vehicleData);

        vehicleData['documentId'] = docRef.id;

        await docRef.update({'documentId': docRef.id});

        print("TICKET ADDED SUCCESSFULLY WITH ID: ${docRef.id}");

        debugPrint("GETTING DOCUMENT");
        DocumentSnapshot snapshot = await docRef.get();
        debugPrint("CONVERTING DATA TO MODEL");

        addedVehicleDetails = VehicleDetailsFirebaseResponseModel.fromJson(
            snapshot.data() as Map<String, dynamic>);
        debugPrint("DATA CONVERTED TO MODEL");
      }
    } catch (e) {
      print("Failed to add vehicle details: $e");
      return null;
    }

    return addedVehicleDetails;
  }

  // Future<VehicleDetailsFirebaseResponseModel?> addVehicleDetailsToFirebase({
  //   required VehicleDetailsFirebaseResponseModel
  //       vehicleDetailsFirebaseResponseModel,
  //   required int tokenNumber,
  //   required int valetCarNumber,
  // }) async {
  //   VehicleDetailsFirebaseResponseModel? addedVehicleDetails;
  //   try {
  //     final vehicleData = vehicleDetailsFirebaseResponseModel.toJson();
  //     vehicleData['checkInTime'] = FieldValue.serverTimestamp();
  //     final centerDocRef = firebaseFirestore
  //         .collection("centers")
  //         .doc(vehicleDetailsFirebaseResponseModel.centerId);
  //
  //     // Start a Firestore transaction
  //     await firebaseFirestore.runTransaction((transaction) async {
  //       // Get the current center document
  //       DocumentSnapshot centerDocSnp = await transaction.get(centerDocRef);
  //       debugPrint("centerDocSnp");
  //       debugPrint(centerDocSnp["tokenNumber"].toString());
  //       debugPrint(centerDocSnp["valetCarNumber"].toString());
  //
  //       // Ensure that tokenNumber and valetCarNumber are not null
  //       if (centerDocSnp["tokenNumber"] == null ||
  //           centerDocSnp["valetCarNumber"] == null) {
  //         return null;
  //       } else {
  //         int currentTokenNumber = centerDocSnp['tokenNumber'];
  //         int currentValetCarNumber = centerDocSnp['valetCarNumber'];
  //
  //         // Check if the values match the center document values
  //         if (tokenNumber != currentTokenNumber ||
  //             valetCarNumber != currentValetCarNumber) {
  //           debugPrint(
  //               "The provided tokenNumber or valetCarNumber does not match the center document values.");
  //           return null;
  //         }
  //
  //         // Get today's date to compare against the checkInTime
  //         DateTime today = DateTime.now();
  //         DateTime startOfToday = DateTime(today.year, today.month, today.day);
  //         DateTime endOfToday =
  //             DateTime(today.year, today.month, today.day, 23, 59, 59, 999);
  //
  //         // Check if there is already a document in 'tickets' with the same centerId, tokenNumber, and valetCarNumber
  //         QuerySnapshot ticketQuerySnapshot = await firebaseFirestore
  //             .collection("tickets")
  //             .where('centerId',
  //                 isEqualTo: vehicleDetailsFirebaseResponseModel.centerId)
  //             .where('tokenNumber', isEqualTo: tokenNumber)
  //             .where('valetCarNumber', isEqualTo: valetCarNumber)
  //             .where('checkInTime', isGreaterThanOrEqualTo: startOfToday)
  //             .where('checkInTime', isLessThanOrEqualTo: endOfToday)
  //             .get();
  //
  //         if (ticketQuerySnapshot.docs.isNotEmpty) {
  //           debugPrint(
  //               "A ticket with the same centerId, tokenNumber, valetCarNumber, and checkInTime from today already exists.");
  //           return null;
  //         } else {
  //           // Increment the tokenNumber and valetCarNumber
  //           int updatedTokenNumber = currentTokenNumber;
  //           int updatedValetCarNumber =
  //               currentValetCarNumber >= 9999 ? 1 : currentValetCarNumber;
  //
  //           // Update the center document with the incremented values
  //           transaction.update(centerDocRef, {
  //             "valetCarNumber":
  //                 currentValetCarNumber >= 9999 ? 1 : FieldValue.increment(1),
  //             "tokenNumber": FieldValue.increment(1),
  //           });
  //
  //           // Add the incremented values to the vehicleData map
  //           vehicleData['valetCarNumber'] = updatedValetCarNumber;
  //           vehicleData['tokenNumber'] = updatedTokenNumber;
  //
  //           // Add the document to the 'tickets' collection
  //           DocumentReference docRef =
  //               await firebaseFirestore.collection("tickets").add(vehicleData);
  //
  //           // Update the documentId field in the map
  //           vehicleData['documentId'] = docRef.id;
  //
  //           // Update the document with the documentId
  //           await docRef.update({'documentId': docRef.id});
  //
  //           debugPrint(
  //               "VEHICLE DETAILS ADDED SUCCESSFULLY IN ID: ${docRef.id}");
  //
  //           // Fetch the newly created document to confirm the addition
  //           DocumentSnapshot snapshot = await docRef.get();
  //           debugPrint("CONVERTING NEWLY ADDED DOCUMENT TO MODEL");
  //
  //           // Convert the document snapshot to the model
  //           addedVehicleDetails = VehicleDetailsFirebaseResponseModel.fromJson(
  //               snapshot.data() as Map<String, dynamic>);
  //
  //           debugPrint("NEWLY ADDED DOCUMENT CONVERTED TO MODEL");
  //           debugPrint(
  //               "UPDATED TOKEN NUMBER: ${addedVehicleDetails?.tokenNumber!.toString()}");
  //           debugPrint(
  //               "UPDATED VALET CARD NUMBER: ${addedVehicleDetails?.valetCarNumber!.toString()}");
  //           return addedVehicleDetails;
  //         }
  //       }
  //     }).catchError((error) {
  //       print("Failed to add ticket: $error");
  //       return null; // Handle errors here if needed
  //     });
  //   } catch (e) {
  //     print("Failed to add vehicle details: $e");
  //     return null; // Return null in case of an error
  //   }
  //   return addedVehicleDetails;
  // }

  /// for adding vehicle details to firebase
  Future<List<VehicleDetailsFirebaseResponseModel>?> getTickets({
    required String centerId,
    required String vehicleStatus,
  }) async {
    try {
      // Get the current date and define the start and end of the day
      final DateTime now = DateTime.now();
      final DateTime startOfDay = DateTime(now.year, now.month, now.day);
      final DateTime endOfDay = startOfDay.add(Duration(days: 1));

      // Query tickets based on the vehicleStatus
      QuerySnapshot querySnapshot;

      if (vehicleStatus == "checkedout") {
        // When vehicleStatus is 'checkedout', filter by checkout time
        querySnapshot = await FirebaseFirestore.instance
            .collection("tickets")
            .where("centerId", isEqualTo: centerId)
            .where("checkOut", isGreaterThanOrEqualTo: startOfDay)
            .where("checkOut", isLessThan: endOfDay)
            .where("vehicleStatus", isEqualTo: vehicleStatus)
            .orderBy('checkOut', descending: true)
            .get();
      } else if (vehicleStatus == "requested") {
        // When vehicleStatus is 'requested', order by requestedTime (latest first)
        querySnapshot = await FirebaseFirestore.instance
            .collection("tickets")
            .where("centerId", isEqualTo: centerId)
            .where("vehicleStatus", isEqualTo: vehicleStatus)
            .orderBy('requestedTime',
                descending:
                    false) // Sorting by requestedTime in descending order
            .get();
      } else {
        // For all other vehicle statuses, order by checkInTime
        querySnapshot = await FirebaseFirestore.instance
            .collection("tickets")
            .where("centerId", isEqualTo: centerId)
            .where("vehicleStatus", isEqualTo: vehicleStatus)
            .orderBy('checkInTime',
                descending: vehicleStatus == "requested" ? false : true)
            .get();
      }

      // Map each document snapshot to the VehicleDetailsFirebaseResponseModel
      List<VehicleDetailsFirebaseResponseModel> tickets =
          querySnapshot.docs.map((doc) {
        return VehicleDetailsFirebaseResponseModel.fromJson(
            doc.data() as Map<String, dynamic>)
          ..documentId = doc.id; // Set the document ID if needed
      }).toList();

      return tickets; // Return the sorted list of VehicleDetailsFirebaseResponseModel
    } catch (e) {
      print("Error retrieving tickets: $e");
      return []; // Return an empty list in case of an error
    }
  }

  /// for updating ticket
  Future<bool?> updateTicket(
      {required VehicleDetailsFirebaseResponseModel
          vehicleDetailsFirebaseResponseModel}) async {
    try {
      // Create a map to hold the updates
      Map<String, dynamic> updates = {
        'vehicleStatus': vehicleDetailsFirebaseResponseModel.vehicleStatus
      };
      String? parkedLocation =
          vehicleDetailsFirebaseResponseModel.parkedLocation;
      // Check if parkedLocation is not null and not empty/whitespace

      if (parkedLocation != null && parkedLocation.trim().isNotEmpty) {
        updates['parkedLocation'] = parkedLocation;
        if (vehicleDetailsFirebaseResponseModel.vehicleStatus == 'parked') {
          updates['parkedBy'] = vehicleDetailsFirebaseResponseModel.parkedBy;
        }
      }
      String? keyLocation = vehicleDetailsFirebaseResponseModel.keyHoldLocation;
      if (keyLocation != null && keyLocation.trim().isNotEmpty) {
        updates["keyHoldLocation"] = keyLocation;
      }

      // Check if the vehicleStatus is checkedOut
      if (vehicleDetailsFirebaseResponseModel.vehicleStatus?.toLowerCase() ==
          'checkedout') {
        updates['checkOut'] = FieldValue.serverTimestamp();
        updates['checkOutBy'] = vehicleDetailsFirebaseResponseModel.checkOutBy;
        updates["paymentMethod"] =
            vehicleDetailsFirebaseResponseModel.paymentMethod;
      }

      print(updates);
      print(vehicleDetailsFirebaseResponseModel.documentId);
      // Perform the update
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(vehicleDetailsFirebaseResponseModel.documentId)
          .update(updates);

      return true; // Successfully updated
    } catch (e) {
      print('Error updating vehicle status: $e');
      return false; // Update failed
    }
  }

  /// for prefetching car details
  Future<VehicleDetailsFirebaseResponseModel?> prefetchCarDetails({
    required String registrationNumber,
  }) async {
    try {
      // Query the tickets collection where registrationNumber matches the provided registrationNumber
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .where('registrationNumber', isEqualTo: registrationNumber)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's data as a Map
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Create and return the VehicleDetailsFirebaseResponseModel
        return VehicleDetailsFirebaseResponseModel.fromJson(data);
      } else {
        return null; // No matching documents found
      }
    } catch (e) {
      print('Error pre-fetching car details: $e');
      return null; // Return null in case of an error
    }
  }

  /// for searching vehicle details

  Future<VehicleDetailsFirebaseResponseModel?> searchVehicleDetails({
    required String centerId, // Required centerId
    String? registrationNumber,
    int? valetCarNumber,
  }) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('tickets')
          .where('centerId', isEqualTo: centerId).orderBy("checkInTime",descending: true);

      // Add conditions based on the presence of tokenNumber or registrationNumber
      if (valetCarNumber != null) {
        query = query.where('valetCarNumber', isEqualTo: valetCarNumber);
      } else if (registrationNumber != null) {
        query =
            query.where('registrationNumber', isEqualTo: registrationNumber);
      }

      // Execute the query and get the results
      QuerySnapshot querySnapshot = await query.limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming you have a method to convert Firestore data to your model
        return VehicleDetailsFirebaseResponseModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      }

      return null; // Return null if no document was found
    } catch (e) {
      print("Error searching vehicle details: $e");
      return null; // Return null in case of an error
    }
  }

  Future<void> updateCenterSheetId(
      {required String centerId, required String sheetId}) async {
    // Reference the document in Firestore
    try {
      await firebaseFirestore.collection("centers").doc(centerId).update({
        'sheetId': sheetId,
        'sheetCreatedDate': FieldValue.serverTimestamp(),
        'tokenNumber': 0,
      });
      print("sheet id updated  successfully");
    } catch (e) {
      print("Error on updating  sheet id: $e");
      // showToast("Error signing out: $e");
    }
  }

  Future<void> addSheetDetailsToFirebase(
      {required SheetDetailsFirebaseResponseModel
          sheetDetailsFirebaseResponseModel}) async {
    try {
      // Create a Map from the CenterResponseModel, setting server timestamps
      final sheetData = {
        'centerId': sheetDetailsFirebaseResponseModel.centerId,
        'centerName': sheetDetailsFirebaseResponseModel.centerName,
        'sheetId': sheetDetailsFirebaseResponseModel.sheetId,
        'sheetName': sheetDetailsFirebaseResponseModel.sheetName,
        'sheetCreatedDate': FieldValue.serverTimestamp(),
      };

      // Add a new document in the 'centers' collection
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('sheets').add(sheetData);

      // Update the document with the centerId
      // await docRef.update({'centerId': docRef.id});

      print('sheet added successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Failed to add center: $e');
    }
  }

  Future<List<SheetDetailsFirebaseResponseModel>?> getSheetDetails(
      {required String centerId, required int limit}) async {
    try {
      // Query the tickets collection where centerId matches the provided centerId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("sheets")
          .where("centerId", isEqualTo: centerId)
          .orderBy("sheetCreatedDate", descending: true)
          .limit(limit)
          .get();

      List<SheetDetailsFirebaseResponseModel> sheet =
          querySnapshot.docs.map((doc) {
        return SheetDetailsFirebaseResponseModel.fromJson(
            doc.data() as Map<String, dynamic>);
      }).toList();
      sheet.sort((a, b) => b.sheetCreatedDate!.compareTo(a.sheetCreatedDate!));
      print(sheet[0].sheetName);
      return sheet;
    } catch (e) {
      print(e);
    }
  }

  Future<List<VehicleDetailsFirebaseResponseModel>?> getRequestedVehicleDetails(
      {required String centerId, required int limit}) async {
    try {
      DateTime Today = DateTime.now().toLocal();
      Timestamp TodayStartTime = Timestamp.fromDate(
          DateTime(Today.year, Today.month, Today.day, 0, 0, 0));
      Timestamp TodayEndTime = Timestamp.fromDate(
          DateTime(Today.year, Today.month, Today.day, 23, 59, 59));
      // Query the tickets collection where centerId matches the provided centerId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tickets")
          .where("centerId", isEqualTo: centerId)
          .where('checkInTime', isGreaterThanOrEqualTo: TodayStartTime)
          .where('checkInTime', isLessThanOrEqualTo: TodayEndTime)
          .where("vehicleStatus", isEqualTo: "requested")
          .limit(limit)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<VehicleDetailsFirebaseResponseModel> tickets =
            querySnapshot.docs.map((doc) {
          return VehicleDetailsFirebaseResponseModel.fromJson(
              doc.data() as Map<String, dynamic>);
        }).toList();
        tickets.sort((a, b) => b.checkInTime!.compareTo(a.checkInTime!));

        return tickets;
      } else {
        print('ticket is null');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<DocumentReference?> addDriver({
    required DriverResponseModel driverResponseModel,
  }) async {
    try {
      // Check for existing manager with the same email
      QuerySnapshot driverQuerySnapshot = await firebaseFirestore
          .collection("drivers")
          .where("driverEmail", isEqualTo: driverResponseModel.driverEmail)
          .get();

      // If a matching manager document is found, do not add a new one
      if (driverQuerySnapshot.docs.isNotEmpty) {
        print("A driver with this email already exists.");
        return null; // Return null if a manager with the same email exists
      }

      // Create a new document reference for the drivers
      DocumentReference driverDocRef =
          firebaseFirestore.collection("drivers").doc();

      // Set the new driver document
      await driverDocRef.set({
        ...driverResponseModel.toJson(),
        "driverId": driverDocRef.id,
      });

      // Check for existing user with the same email
      QuerySnapshot userQuerySnapshot = await firebaseFirestore
          .collection("users")
          .where("userEmail", isEqualTo: driverResponseModel.driverEmail)
          .get();

      // If a matching user document is found, update it
      if (userQuerySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;
        driverDocRef.update({"driverUserId": userDocSnapshot.get("userId")});
        // driverQuerySnapshot.docs.first.reference.update({"driverUserId":userDocSnapshot.get("userId")});
        await userDocSnapshot.reference.update({
          "userPhoneNumber": driverResponseModel.driverPhoneNumber,
          "userAddress": driverResponseModel.driverAddress,
          "userName": driverResponseModel.driverName,
          "accountType": "driver",
        });
      }

      return driverDocRef;
    } catch (e) {
      print("Error while adding driver: $e");
      return null;
    }
  }

  Future<List<DriverResponseModel>?> getDrivers(
      {required bool isSuspended, required String centerId}) async {
    try {
      /// fetch
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("drivers")
          .where("isSuspended", isEqualTo: isSuspended)
          .where("driverCenterId", isEqualTo: centerId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<DriverResponseModel> drivers = querySnapshot.docs.map((doc) {
          return DriverResponseModel.fromJson(
              doc.data() as Map<String, dynamic>);
        }).toList();
        print(drivers[0].driverName);
        return drivers;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching managers: $e");
      return null;
    }
  }

  Future<void> updatedDriverSuspendStatus(
      {required String driverId, required bool isSuspended}) async {
    try {
      // Fetch the document with the given managerId
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection("drivers")
          .doc(driverId)
          .get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Convert the document data to ManagerResponseModel
        await docSnapshot.reference.update({
          'isSuspended': isSuspended,
        });
      } else {
        print("Driver with ID $driverId does not exist.");
      }
    } catch (e) {
      print("Error updating suspend status: $e");
    }
  }

  Future<String?> getDriverCenterName({required String userId}) async {
    // Reference to the Firestore collection
    print(userId);
    CollectionReference driversCollection =
        FirebaseFirestore.instance.collection('drivers');

    try {
      print("userId$userId");
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot = await driversCollection
          .where('driverUserId', isEqualTo: userId)
          .get();
      print(querySnapshot.docs.isNotEmpty ? "hi" : "hello");
      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's centerName field
        String centerName = querySnapshot.docs.first['driverCenter'];
        print(" center Name $centerName");
        return centerName; // Return the centerName
      } else {
        print("not exist");
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching center name: $e');
      return null; // Return null in case of an error
    }
  }

  Future<String?> getDriverCenterId({required String userId}) async {
    // Reference to the Firestore collection
    CollectionReference driversCollection =
        FirebaseFirestore.instance.collection('drivers');

    try {
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot = await driversCollection
          .where('driverUserId', isEqualTo: userId)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's centerName field
        String centerId = querySnapshot.docs.first['driverCenterId'];
        return centerId; // Return the centerName
      } else {
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching center id: $e');
      return null; // Return null in case of an error
    }
  }

  Future<String?> getDriverId({required String userId}) async {
    // Reference to the Firestore collection
    CollectionReference driversCollection =
        FirebaseFirestore.instance.collection('drivers');

    try {
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot = await driversCollection
          .where('driverUserId', isEqualTo: userId)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's centerName field
        String driverId = querySnapshot.docs.first['driverId'];
        return driverId; // Return the centerName
      } else {
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching center id: $e');
      return null; // Return null in case of an error
    }
  }

  Future<bool> getDriverSuspendedStatus({required String userId}) async {
    try {
      // Reference to the 'managers' collection
      CollectionReference driversCollection =
          FirebaseFirestore.instance.collection('drivers');

      // Query the collection for the document where managerUserId matches the userId
      QuerySnapshot querySnapshot = await driversCollection
          .where('driverUserId', isEqualTo: userId)
          .get();

      // Check if any documents were returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming managerUserId is unique)
        DocumentSnapshot document = querySnapshot.docs.first;

        // Retrieve the data as a Map
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        // Retrieve the isSuspended field
        bool isSuspended = data['isSuspended'] ?? false;

        return isSuspended;
      } else {
        return false;
      }
    } catch (e) {
      print('Error fetching suspension status: $e');
      return false;
    }
  }

  Future<void> updateDriverDetails(
      {required DriverResponseModel driverResponseModel}) async {
    try {
      Map<String, dynamic> updates = {
        'driverEmail': driverResponseModel.driverEmail,
        'driverCenter': driverResponseModel.driverCenter,
        'driverCenterId': driverResponseModel.driverCenterId,
        'driverName': driverResponseModel.driverName,
        'driverPhoneNumber': driverResponseModel.driverPhoneNumber,
        'driverAddress': driverResponseModel.driverAddress
      };
      await firebaseFirestore
          .collection("drivers")
          .doc(driverResponseModel.driverId)
          .update(updates);
      print("Driver details updated  successfully");
    } catch (e) {
      print("Error on updating driver details: $e");
    }
  }

  Future<void> updateManagerDetails(
      {required ManagerResponseModel managerResponseModel}) async {
    try {
      Map<String, dynamic> updates = {
        'managerEmail': managerResponseModel.managerEmail,
        'managerCenter': managerResponseModel.managerCenter,
        'managerCenterId': managerResponseModel.managerCenterId,
        'managerName': managerResponseModel.managerName,
        'managerPhoneNumber': managerResponseModel.managerPhoneNumber,
        'managerAddress': managerResponseModel.managerAddress
      };
      print(managerResponseModel.managerId);
      await firebaseFirestore
          .collection("managers")
          .doc(managerResponseModel.managerId)
          .update(updates);
      print("Manager details updated  successfully");
    } catch (e) {
      print("Error on updating manager details: $e");
    }
  }

  Future<void> updateVehicleParkedLocation(
      {required String documentId, required String parkedLocation}) async {
    try {
      await firebaseFirestore
          .collection("tickets")
          .doc(documentId)
          .update({"parkedLocation": parkedLocation});
      print("parked location updated  successfully");
    } catch (e) {
      print("Error on updating parked location: $e");
    }
  }

  Future<List<UserResponseModel>> getRequestedUsers() async {
    try {
      // Fetch all documents from the "users" collection
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection("users")
          .where("accountType", isEqualTo: "user")
          .get();

      // Convert the documents into a list of UserResponseModel
      List<UserResponseModel> users = querySnapshot.docs.map((doc) {
        return UserResponseModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return users;
    } catch (e) {
      print("Error while fetching users: $e");
      return [];
    }
  }

  Future<List<dynamic>> getPaymentCount({
    required String centerId,
  }) async {
    try {
      // Get the current date and define the start and end of the day
      final DateTime now = DateTime.now();
      final DateTime startOfDay = DateTime(now.year, now.month, now.day);
      final DateTime endOfDay = startOfDay.add(Duration(days: 1));

      // print("it is check out");
      QuerySnapshot upiQuerySnapshot = await FirebaseFirestore.instance
          .collection("tickets")
          .where("centerId", isEqualTo: centerId)
          .where("checkOut", isGreaterThanOrEqualTo: startOfDay)
          .where("checkOut", isLessThan: endOfDay)
          .where("paymentMethod", isEqualTo: "Upi")
          .orderBy('checkOut', descending: true)
          .get();
      QuerySnapshot cashQuerySnapshot = await FirebaseFirestore.instance
          .collection("tickets")
          .where("centerId", isEqualTo: centerId)
          .where("checkOut", isGreaterThanOrEqualTo: startOfDay)
          .where("checkOut", isLessThan: endOfDay)
          .where("paymentMethod", isEqualTo: "Cash")
          .orderBy('checkOut', descending: true)
          .get();
      List paymentLengthList = [];
      paymentLengthList.add(upiQuerySnapshot.docs.length);
      paymentLengthList.add(cashQuerySnapshot.docs.length);
      return paymentLengthList; // Return the sorted list of VehicleDetailsFirebaseResponseModel
    } catch (e) {
      print("Error retrieving tickets: $e");
      return []; // Return an empty list in case of an error
    }
  }

  Future<String?> getCenterNameByCenterId(
      {required String centerId,
      required String userId,
      required bool isManager}) async {
    // Reference to the Firestore collection
    CollectionReference centersCollection =
        FirebaseFirestore.instance.collection('centers');

    CollectionReference managerCollection =
        FirebaseFirestore.instance.collection("managers");

    CollectionReference driverCollection =
        FirebaseFirestore.instance.collection("drivers");

    try {
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot =
          await centersCollection.where('centerId', isEqualTo: centerId).get();
      QuerySnapshot secondQuerySnapshot = isManager
          ? await managerCollection
              .where("managerUserId", isEqualTo: userId)
              .get()
          : await driverCollection
              .where("driverUserId", isEqualTo: userId)
              .get();
      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's centerName field
        DocumentSnapshot documentSnapshot = secondQuerySnapshot.docs.first;
        String centerName = querySnapshot.docs.first['centerName'];
        String databaseCenterName =
            documentSnapshot[isManager ? "managerCenter" : "driverCenter"];
        if (centerName != databaseCenterName) {
          await documentSnapshot.reference.update(isManager
              ? {"managerCenter": centerName}
              : {"driverCenter": centerName});
        }
        return centerName; // Return the centerName
      } else {
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching center name: $e');
      return null; // Return null in case of an error
    }
  }

  Future<bool?> getIsDeleted({required String centerId}) async {
    // Reference to the Firestore collection
    CollectionReference centersCollection =
        FirebaseFirestore.instance.collection('centers');

    try {
      // Fetch the document where managerUserId equals userId
      QuerySnapshot querySnapshot =
          await centersCollection.where('centerId', isEqualTo: centerId).get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        bool isDelete = querySnapshot.docs.first['isDelete'];

        return isDelete; // Return the centerName
      } else {
        return null; // No document found
      }
    } catch (e) {
      // Handle errors (e.g., log or display)
      print('Error fetching ceneter delete status: $e');
      return null; // Return null in case of an error
    }
  }
}
