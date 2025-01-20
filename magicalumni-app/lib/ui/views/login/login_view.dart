import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/login/login_viewmodel.dart';
import 'package:magic_alumni/widgets/common/loading_button_widget.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isKeyVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return ViewModelBuilder<LoginViewmodel>.reactive(
      viewModelBuilder: () => LoginViewmodel(),
      onDispose: (viewModel) => viewModel.onDispose(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              // background color for the view
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 240,
                      child: Image.asset(
                        "assets/icon/logo_white.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // The stack hold the forms
              Positioned(
                top: isKeyVisible ? size.width > 600 ? size.height * 0.35 :size.height * 0.25 : size.width > 600 ? size.height * 0.5 : size.height * 0.4,
                bottom: 0,
                right: 0,
                left: 0,
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 35,),
                          Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                          Text("Enter your Mobile Number", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black45),),
                          const SizedBox(height: 15,),
                          // Form for Login
                          Column(
                            children: [
                              Container(),
                              // mobile number text field
                              TextFieldWidget(
                                controller: model.mobileController,
                                hintText: "Mobile Number",
                                maxLength: 10,
                                prefixIcon: Icon(CupertinoIcons.phone, color: Theme.of(context).primaryColor, size: 20,),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 15,),
                              // Otp Text field
                              model.isAccountVerified 
                              ? TextFieldWidget(
                                  controller: model.otpController,
                                  hintText: "6 Digit OTP",
                                  maxLength: 6,
                                  prefixIcon: Icon(Icons.password, size: 20, color: Theme.of(context).primaryColor,),
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                )
                              : Container(),
                              model.isAccountVerified 
                              ? const SizedBox(height: 15,)
                              : Container(),
                              model.isResendClicked
                              ?  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Resend OTP in: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                      Text(model.formatTime(model.time), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFF7CA18)),),
                                    ],
                                  )
                              : !model.isAccountVerified ? Container(): Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Didn't receive OTP: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                  InkWell(
                                    onTap: () async {
                                      await model.login(model.mobileController.text);
                                      model.startTimer();
                                    },
                                    child: Text("Resend", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFF7CA18)),)
                                  ),
                                ],
                              ),
                              model.isAccountVerified 
                              ? const SizedBox(height: 15,)
                              : Container(),
                              SizedBox(
                                width: size.width,
                                height: 48.0,
                                child: model.isLoading
                                ? LoadingButtonWidget()
                                : ElevatedButton(
                                  onPressed: () async {
                                    model.isOTPVerified
                                    ? model.navigateHome()
                                    : !model.isAccountVerified
                                        ? model.isMobileAdded 
                                          ? await model.login(model.mobileController.text)// Call login API
                                          : model.mobileSnackBar()
                                        : model.isOtpAdded
                                          ? await model.verifyOtp(model.otpController.text)
                                          : model.otpSnackBar();
                                  },
                                  child: Text(
                                    model.isAccountVerified ? "Verify" : 'Login',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              // Linked in button to signin
                              SizedBox(
                                width: size.width,
                                height: 48.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // model.isLoad = false;
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 10.0,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.asset(
                                            "assets/icon/linkedin_circle.png",
                                            fit: BoxFit.cover,
                                          )
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                          'Login with LinkedIn',
                                          style: textStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              // Signup Navigation
                              InkWell(
                                onTap: () {
                                  model.navigateSignup();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        "Don't you have account? ", 
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        "Signup", 
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF7CA18)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}