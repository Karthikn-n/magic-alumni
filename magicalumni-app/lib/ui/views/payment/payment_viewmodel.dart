import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class PaymentViewmodel extends BaseViewModel {
  late Razorpay razorPay;
  final _diologService = locator<DialogService>();
// https://medium.com/yavar/how-i-integrated-razorpay-into-my-flutter-application-d0858fd35e85
  final Future<PaymentConfiguration> googlePayConfigFuture = PaymentConfiguration.fromAsset('icon/google_pay_config.json');
  List<String> paymentMethods = [
    "Google Pay",
    "Stripe",
    "Credit/Debit Card",
  ];
  List<String> icons = [
    "assets/icon/playstore.png",
    "assets/icon/stripe.png",
    "assets/icon/card.png",
  ];
  final secertKey = "";
  final secertId = "";

  final String defaultGooglePay = '''
  {
    "provider": "google_pay",
    "data": {
      "apiVersion": 2,
      "apiVersionMinor": 0,
      "environment": "TEST",
      "allowedPaymentMethods": [
        {
          "type": "UPI",
          "parameters": {
            "pa": "karthikn11092001@okicici", 
            "pn": "Your Merchant Name",
            "tr": "1234567890",
            "tn": "Order Payment",
            "mc": "1234",
            "url": "https://yourwebsite.com",
            "cu": "INR"
          }
        }
      ],
      "merchantInfo": {
        "merchantName": "Tea time"
      },
      "transactionInfo": {
        "countryCode": "IN",
        "currencyCode": "INR"
      }
    }
  }
  ''';
  /// Check the result from the Google Pay
  void onGooglePayResult(paymentResult) {
    debugPrint("Result: ${paymentResult.toString()}");
  }

  // Google pay payment item
  List<PaymentItem> paymentItem() {
    return [
      PaymentItem(
        amount: "1", 
        label: "Total", 
        type: PaymentItemType.total, 
        status: PaymentItemStatus.final_price
      )
    ];
  }

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
