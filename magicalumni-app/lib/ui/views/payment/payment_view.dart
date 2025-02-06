import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/payment/payment_viewmodel.dart';
import 'package:pay/pay.dart';
import 'package:stacked/stacked.dart';
import 'package:magic_alumni/ui/views/payment/default_config.dart' as payment_configurations;

class PaymentView extends StackedView<PaymentViewmodel> {
  const PaymentView({super.key});

  @override
  Widget builder(BuildContext context, PaymentViewmodel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Payment", style: appBarTextStyle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )
        ),
      ),
      body: PayAdvancedSampleApp()
      // Stack(
      //   clipBehavior: Clip.none,
      //   children: [
      //     // Container(
      //     //   decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      //     // ),
      //     // Actual Body of the View
      //     Positioned(
      //       top: MediaQuery.sizeOf(context).height * 0.08,
      //       left: 0,
      //       right: 0,
      //       bottom: 0,
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: Theme.of(context).scaffoldBackgroundColor,
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(30),
      //             topRight: Radius.circular(30),
      //           ),
      //         ),
      //         child: Column(
      //           children: [
      //             // FutureBuilder<PaymentConfiguration>(
      //             //   future: viewModel.googlePayConfigFuture,
      //             //   builder: (context, snapshot) {
      //             //      return snapshot.hasData 
      //             //       ?  GestureDetector(
      //             //           onTap: () => viewModel.onGooglePayResult,
      //             //           child: GooglePayButton(
      //             //             height: kToolbarHeight,
      //             //             width: double.infinity,
      //             //             theme: GooglePayButtonTheme.dark,
      //             //             paymentConfiguration: snapshot.data!,
      //             //             paymentItems: viewModel.paymentItem(),
      //             //             type: GooglePayButtonType.buy,
      //             //             margin: const EdgeInsets.only(top: 15.0),
      //             //             onPaymentResult: viewModel.onGooglePayResult,
      //             //             loadingIndicator: const Center(
      //             //               child: CircularProgressIndicator(),
      //             //             ),
      //             //           ),
      //             //         )
      //             //       : const SizedBox.shrink();
      //             //   }
      //             // ),
      //             // Expanded(
      //             //   child: ListView.builder(
      //             //     physics: const NeverScrollableScrollPhysics(),
      //             //     itemCount: viewModel.paymentMethods.length,
      //             //     itemBuilder: (context, index) {
      //             //       return Material(
      //             //         color: Colors.transparent,
      //             //         child: InkWell(
      //             //           splashFactory: InkRipple.splashFactory,
      //             //           highlightColor: Colors.transparent,
      //             //           onTap: () {
                              
      //             //           },
      //             //           child: ListTile(
      //             //             shape: index == 0
      //             //             ? RoundedRectangleBorder(
      //             //               borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      //             //             )
      //             //             : null,
      //             //             leading: SizedBox(
      //             //               height: 24,
      //             //               width: 24,
      //             //               child: Image.asset(
      //             //                 viewModel.icons[index]
      //             //               ),
      //             //             ),
      //             //             title: Text(viewModel.paymentMethods[index]),
      //             //             trailing: Icon(Icons.arrow_forward_ios),
      //             //             splashColor: Colors.transparent,
      //             //           ),
      //             //         ),
      //             //       );
      //             //     },
      //             //   ),
      //             // ),
      //             // // ElevatedButton(onPressed: () => viewModel.makeCheckOut(), child: Text("Pay now")),
                  
      //           ],
      //         ),
      //       ),
      //     ),
      //     // Positioned(
      //     //   right: 10,
      //     //   left: 10,
      //     //   top: 0,
      //     //   child: PaymentCardView()
      //     // )
      //   ],
      // ),
   
    );
  }

  @override
  PaymentViewmodel viewModelBuilder(BuildContext context) {
    return PaymentViewmodel();
  }


  
}



const googlePayEventChannelName = 'plugins.flutter.io/pay/payment_result';
const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '1.00',
    status: PaymentItemStatus.final_price,
  )
];


class PayAdvancedSampleApp extends StatefulWidget {
  final Pay payClient;

  PayAdvancedSampleApp({super.key})
      : payClient = Pay({
          PayProvider.google_pay: payment_configurations.defaultGooglePayConfig,
        });

  @override
  State<PayAdvancedSampleApp> createState() => _PayAdvancedSampleAppState();
}

class _PayAdvancedSampleAppState extends State<PayAdvancedSampleApp> {
  static const eventChannel = EventChannel(googlePayEventChannelName);
  StreamSubscription<String>? _googlePayResultSubscription;

  late final Future<bool> _canPayGoogleFuture;
  late final Future<bool> _canPayAppleFuture;

  // A method to listen to events coming from the event channel on Android
  void _startListeningForPaymentResults() {
    _googlePayResultSubscription = eventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .listen(debugPrint, onError: (error) => debugPrint(error.toString()));
  }

  final bool _collectPaymentResultSynchronously =
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    if (!_collectPaymentResultSynchronously) {
      _startListeningForPaymentResults();
    }

    // Initialize userCanPay futures
    _canPayGoogleFuture = widget.payClient.userCanPay(PayProvider.google_pay);
  }

  void _onGooglePayPressed() =>
      _showPaymentSelectorForProvider(PayProvider.google_pay);

  

  void _showPaymentSelectorForProvider(PayProvider provider) async {
    try {
      final result =
          await widget.payClient.showPaymentSelector(provider, _paymentItems);
      if (_collectPaymentResultSynchronously) debugPrint(result.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void dispose() {
    _googlePayResultSubscription?.cancel();
    _googlePayResultSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Google Pay button
          FutureBuilder<bool>(
            future: _canPayGoogleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return RawGooglePayButton(
                      paymentConfiguration:
                          payment_configurations.defaultGooglePayConfig,
                      type: GooglePayButtonType.buy,
                      onPressed: _onGooglePayPressed);
                } else {
                  // userCanPay returned false
                  // Consider showing an alternative payment method
                }
              } else {
                // The operation hasn't finished loading
                // Consider showing a loading indicator
              }
              // This example shows an empty box if userCanPay returns false
              return const SizedBox.shrink();
            },
          ),

        ],
      ),
    );
  }
}