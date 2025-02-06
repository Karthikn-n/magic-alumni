import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/widgets/payment/payment_card_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PaymentCardView extends StackedView<PaymentCardViewmodel> {
  const PaymentCardView({super.key});
  
  @override
  Widget builder(BuildContext context, PaymentCardViewmodel viewModel, Widget? child) {
    Size size = MediaQuery.sizeOf(context);
    return Card(
      child: Container(
        child: Column(
          children: [
            Text(
              "You are need to Pay to be a alumni",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "You ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

          ],
        ),
      ),
    );
  }
  
  @override
  PaymentCardViewmodel viewModelBuilder(BuildContext context) => PaymentCardViewmodel();


}