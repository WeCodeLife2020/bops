import 'package:bops_mobile/src/resources/repository/repository.dart';
import 'package:bops_mobile/src/utils/firebase_client.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'api_client.dart';
import 'dio.dart';
import 'hive.dart';

/// it is a hub that connecting pref,repo,client
/// used to reduce imports in pages
class ObjectFactory {
  static final _objectFactory = ObjectFactory._internal();

  ObjectFactory._internal();

  factory ObjectFactory() => _objectFactory;

  ///Initialisation of Objects
  AppHive _appHive = AppHive();
   final FirebaseAuth auth = FirebaseAuth.instance;
  ApiClient _apiClient = ApiClient();
  AppDio _appDio = AppDio();
  Repository _repository = Repository();
  FirebaseClient _firebaseClient = FirebaseClient();

  ///
  /// Getters of Objects
  ///
  ApiClient get apiClient => _apiClient;
  AppDio get appDio => _appDio;
  FirebaseClient get firebaseClient => _firebaseClient;
  AppHive get appHive => _appHive;

  Repository get repository => _repository;

  ///
  /// Setters of Objects
  ///
}
