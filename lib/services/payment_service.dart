import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import '../network/service_provider.dart';
import '../response_model/final_payment_model/final_payment_model.dart';

class PaymentService {
  final ServiceProvider _serviceProvider = ServiceProvider();

  Future<void> startPartialPayment({
    required BuildContext context,
    required double amount,
    required FInalPaymentModel bookingModel,
    required Function(String) onSuccess,
    required Function(String) onError,
    required String apikey,
    required bool sandbox,

  }) async {
    _navigateToPaymentGateway(
      context: context,
      amount: amount.toInt(),
      bookingModel: bookingModel,
      onSuccess: onSuccess,
      onError: onError,
      sandbox: sandbox,
      apikey: apikey
    );
  }

  void _navigateToPaymentGateway({
    required BuildContext context,
    required int amount,
    required FInalPaymentModel bookingModel,
    required Function(String) onSuccess,
    required Function(String) onError,
    required String apikey,
    required bool sandbox,
  }) {
    final bookingNo = bookingModel.data?.bookingno ?? "";
    final bookingId = bookingModel.data?.bookingId ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KKiaPay(
          amount: amount,
          apikey: apikey,
          sandbox: sandbox,
          reason: "Hotel Booking $bookingNo",
          theme: "#ff7903",
          data: jsonEncode({"order_id": bookingNo, "booking_id": bookingId}),
          callback: (response, context) {
            _handlePaymentCallback(
              response: response,
              bookingNo: bookingNo,
              bookingId: bookingId,
              onSuccess: onSuccess,
              onError: onError,
            );
          },
        ),
      ),
    );
  }

  void _handlePaymentCallback({
    required Map<String, dynamic> response,
    required String bookingNo,
    required int bookingId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    final status = response['status'];
    final transactionId = response['transactionId'];

    if (status != "PAYMENT_SUCCESS") {
      return;
    }

    if (transactionId == null || transactionId.isEmpty) {
      onError("Payment success but transaction ID missing");
      return;
    }

    _verifyPayment(
      transactionId: transactionId,
      bookingNo: bookingNo,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  Future<void> _verifyPayment({
    required String transactionId,
    required String bookingNo,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final response = await _serviceProvider.paymentSuccess(
        transactionId: transactionId,
      );

      if (response.status == true) {
        onSuccess(
          "Payment Successful\n"
          "Booking No: $bookingNo\n"
          "Txn ID: $transactionId",
        );
      } else {
        onError("Payment verification failed");
      }
    } catch (e) {
      onError("Payment verification error: $e");
    }
  }
}
