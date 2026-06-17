import 'dart:developer';
import 'package:get/get.dart';
import '../utils/storage.dart';

class ApiService extends GetConnect {
  ApiService() {
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(minutes: 1);

    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${LocalStorages().getToken() ?? ""}";
      request.headers['Accept'] = 'application/json';
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      log("→ ${request.url}  ← ${response.statusCode}");
      return response;
    });
  }
}