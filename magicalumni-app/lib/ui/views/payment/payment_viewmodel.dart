import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../service/api_service.dart';

class PaymentViewmodel extends BaseViewModel {
  late Razorpay razorPay;
  final _diologService = locator<DialogService>();
  final _apiService = locator<ApiService>();
  List<String> paymentMethods = [
    "Google Pay",
    "Stripe",
    "Credit/Debit Card",
  ];
  List<String> icons = [
    "assets/icon/gpay.png",
    "assets/icon/stripe.png",
    "assets/icon/card.png",
  ];
  final secertKey = "";
  final secertId = "";

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    _diologService.showDialog(
      title: "Payment Failed",
      description:  "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}"
    );
    debugPrint("Error on payment: code: ${response.code}, Description: ${response.message}, Error: ${response.error.toString()}", wrapWidth: 1064);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    _diologService.showDialog(
      title: "Payment Successful",
      description:  "Payment ID: ${response.paymentId}"
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    _diologService.showDialog(
      title: "External Wallet Selected",
      description:  "${response.walletName}"
    );
  }



  void makeCheckOut() {
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    var options = {
      'key': secertId,
      'amount': 50000, //in paise.
      'name': 'Acme Corp.',
      'order_id': '1', // Generate order_id using Orders API
      'description': 'Fine T-Shirt',
      'timeout': 60, // in seconds
      'prefill': {
        'contact': '9000090000',
        'email': 'gaurav.kumar@example.com'
      }
    };
    razorPay.open(options);
  }
}
