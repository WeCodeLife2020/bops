import 'dart:async';
import 'dart:io';
import 'package:bops_mobile/src/utils/urls.dart';
import 'package:dio/dio.dart';

class AppDio {
  AppDio() {
    initClient();
  }

//for api client testing only
  AppDio.test({required this.dio});

  Dio? dio;
  BaseOptions? _baseOptions;

  initClient() async {
    _baseOptions = BaseOptions(
        // baseUrl: Urls.baseUrl,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 100000),
        followRedirects: true,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        responseType: ResponseType.json,
        receiveDataWhenStatusError: true);

    dio = Dio(_baseOptions);
  }

  Future<Response> postSmsWithAuthKey({
    String? url,
    var data,
    String? authKey, // Include the authKey parameter
  }) async {
    try {
      print("Request Data: $data");

      final options = Options(
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          if (authKey != null) 'authkey': authKey,
        },
      );

      final response = await dio!.post(
        "$url",
        data: data,
        options: options,
      );

      print("Response Status Code: ${response.statusCode}");
      return response;
    } catch (error) {
      print("Error: $error");
      rethrow;
    }
  }

  ///dio  post
  Future<Response> post({String? url, var data}) async {
    try {
      print(data);
      final response = await dio!.post("$url", data: data);
      print(response.statusCode);
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location']?.first;
        print(response.headers['location']);
        if (redirectUrl != null) {
          print('Redirecting to: $redirectUrl');
          // Make a new request to the redirected URL
          final redirectedResponse = await dio!.get(redirectUrl);
          print(redirectedResponse.statusCode);
          return redirectedResponse;
        }
      }

      return response;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  ///dio get
  Future<Response> get({String? url}) async {
    print(url);
    final response = dio!.get(url!);
    print('c jb');
    return response;
  }
}
