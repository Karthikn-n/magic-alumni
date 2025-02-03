import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/payment/payment_viewmodel.dart';
import 'package:stacked/stacked.dart';

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
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Container(
          //   decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          // ),
          // Actual Body of the View
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.08,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.paymentMethods.length,
                      itemBuilder: (context, index) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashFactory: InkRipple.splashFactory,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              
                            },
                            child: ListTile(
                              shape: index == 0
                              ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                              )
                              : null,
                              leading: SizedBox(
                                height: 24,
                                width: 24,
                                child: Image.asset(
                                  viewModel.icons[index]
                                ),
                              ),
                              title: Text(viewModel.paymentMethods[index]),
                              trailing: Icon(Icons.arrow_forward_ios),
                              splashColor: Colors.transparent,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(onPressed: () => viewModel.makeCheckOut(), child: Text("Pay now"))
                ],
              ),
            ),
          ),
          // Positioned(
          //   right: 10,
          //   left: 10,
          //   top: 0,
          //   child: PaymentCardView()
          // )
        ],
      ),
    );
  }

  @override
  PaymentViewmodel viewModelBuilder(BuildContext context) {
    return PaymentViewmodel();
  }


  
}

