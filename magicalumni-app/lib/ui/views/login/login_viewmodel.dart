import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/service/authenticate_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewmodel extends BaseViewModel{
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();


  bool isMobileAdded = false;
  bool isOtpAdded = false;
  // bool isKeyVisible = false;
  // check the account is exits are not is account is exist change the account verified status
  bool _isAccountVerified = false;
  bool get isAccountVerified => _isAccountVerified;
  bool _isOTPVerified = false;
  bool get isOTPVerified => _isOTPVerified;

  // Resend OTP timer varaibles
  bool isResendClicked = false;
  int time = 30;
  Timer? timer;

  // Use navigation service to navigate between views
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  // Authenticate Service used to Authenticate users from Database
  final AuthenticateService auth = locator<AuthenticateService>();

  // Validate the text fields
  void init(){
    // Validate the mobile number 
    mobileController.addListener(() {
      if (mobileController.text.isEmpty || mobileController.text.length < 10) {
        isMobileAdded = false;
      }else{
        isMobileAdded = true;
      }
    },);
    // Validate the otp fields
    otpController.addListener(() {
       if (otpController.text.isEmpty || mobileController.text.length < 6) {
        isOtpAdded = false;
      }else{
        isOtpAdded = true;
      }
    },);
  }

  /// Once successfully user is verified set that to [true]
  void verifyAccount(){
    _isAccountVerified = true;
    notifyListeners();
  }
  
  /// Verified the OTP
  void verifiedOTP(){
    _isOTPVerified = true;
    notifyListeners();
  }


  // If the mobile is not added show the snackbar
  void mobileSnackBar(){
    if (mobileController.text.isEmpty) {
      _snackbarService.showSnackbar(message: "Enter a Registered Mobile Number", duration: const Duration(milliseconds: 1200));
    }else if(!RegExp(r'^[0-9]{10}$').hasMatch(mobileController.text)){
      _snackbarService.showSnackbar(message: "Enter a Valid Mobile Number", duration: const Duration(milliseconds: 1200));
    }else{
      return;
    }
  }

  /// If the otp is not entered show the snackbar
  void otpSnackBar(){
    if (otpController.text.isEmpty) {
      _snackbarService.showSnackbar(message: "Enter a OTP", duration: const Duration(milliseconds: 1200));
    }else if(!RegExp(r'^[0-9]{6}$').hasMatch(otpController.text)){
      _snackbarService.showSnackbar(message: "Enter a Valid OTP", duration: const Duration(milliseconds: 1200));
    }else{
      return;
    }
    notifyListeners();
  }

  /// Start the timer once the Login is verified
  void startTimer() {
    isResendClicked = true;
    time = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
       if (time > 0) {
          time--;
        } else {
          isResendClicked = false;
          timer.cancel(); // Stop the timer when it reaches 0
        }
        notifyListeners();
    },);
    notifyListeners();
  }

  String formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // Call the API 
  Future<void> login(String mobile) async 
    => await auth.login(mobile).then(
      (value){
        if(value){
          verifyAccount();
          startTimer();
        }
        notifyListeners();
      }
    );
 

  Future<void> verifyOtp(String otp) async 
    => await auth.verifyOtp(otp).then((value) {
      if(value) {
        verifiedOTP();
        // _isOTPVerified ? navigateHome() : null;  
      }
      notifyListeners();
    });
  
  // Move to signup screen 
  void navigateSignup() => _navigationService.replaceWithSignupView();
  
  // Navigate to home screen view
  void navigateHome()  => _navigationService.replaceWithAppView();


  @override
  void dispose() {
    super.dispose();
    mobileController.dispose();
    otpController.dispose();
    timer?.cancel();
  }
}

