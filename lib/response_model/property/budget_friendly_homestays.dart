import 'package:elior/response_model/property/property_search_response.dart';

class BudgetFriendlyHomestayResponse {
  bool? status;
  String? message;
  List<Property>? data;

  BudgetFriendlyHomestayResponse({
    this.status,
    this.message,
    this.data,
  });

  BudgetFriendlyHomestayResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => Property.fromBudgetJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList(),
    };
  }
}