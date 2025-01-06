import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/login/login_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isKeyVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => LoginViewmodel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              // background color for the view
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
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
                top: isKeyVisible ? size.height * 0.3 : size.height * 0.45,
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
                          Text("Enter your credentials", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black45),),
                          // Form for Login
                          Column(
                            spacing: 15,
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
                              // Otp Text field
                              model.isAccountVerified 
                              ? TextFieldWidget(
                                  controller: model.otpController,
                                  hintText: "6 Digit OTP",
                                  maxLength: 6,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                )
                              : Container(),
                              SizedBox(
                                width: size.width,
                                height: 48.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    !model.isAccountVerified
                                      ? model.isMobileAdded 
                                        ? await model.login(model.mobileController.text)// Call login API
                                        : model.otpSnackBar()
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
                              // Linked in button to signin
                              SizedBox(
                                width: size.width,
                                height: 48.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    model.navigateHome();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 10.0,
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Image.asset(
                                          "assets/icon/linkedin_circle.png",
                                          fit: BoxFit.cover,
                                        )
                                      ),
                                      Text(
                                        'Login with LinkedIn',
                                        style: textStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(),
                              // Signup Navigation
                              InkWell(
                                onTap: () {
                                  model.navigateSignup();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't you have account? ", 
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Signup", 
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF7CA18)),
                                    ),
                                  ],
                                ),
                              ),
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