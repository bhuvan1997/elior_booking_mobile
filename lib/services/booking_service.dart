import '../network/service_provider.dart';
import '../response_model/final_payment_model/final_payment_model.dart';
import '../response_model/final_payment_model/payment_initiated_model.dart';


class BookingResult {
  final bool isSuccess;
  final FInalPaymentModel? data;
  final String? error;

  BookingResult({required this.isSuccess, this.data, this.error});
}

class BookingService {
  final ServiceProvider _serviceProvider = ServiceProvider();
  PaymentInitiatedModel paymentInitiatedModel = PaymentInitiatedModel();

  Future<BookingResult> confirmBooking({
    required String propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String guests,
    required String roomtype,
    required String roomIdAllotted,
    required int basePrice,
    required int taxFee,
    required int discountAmount,
    required int totalAmount,
    required String payPlan,
  }) async {
    try {
      final result = await _serviceProvider.payFinalHotelPaymentApi(
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        propertyId: propertyId,
        guests: guests,
        roomtype: roomtype,
        roomIdAllotted: roomIdAllotted,
        basePrice: basePrice,
        taxFee: taxFee,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        payPlan: payPlan,
      );

      return BookingResult(
        isSuccess: result.status == true,
        data: result,
        error: result.status != true ? "Booking confirmation failed" : null,
      );
    } catch (e) {
      return BookingResult(
        isSuccess: false,
        error: "Booking error: $e",
      );
    }
  }

  Future<void> initiatePayment({
    required int type,
    required int bookingId,
  }) async {
    try {
      paymentInitiatedModel = await _serviceProvider.paymentInitiated(
        type: type,
        bookingId: bookingId,
      );
    } catch (e) {
      print("Payment Initiated Error: $e");
    }
  }
}