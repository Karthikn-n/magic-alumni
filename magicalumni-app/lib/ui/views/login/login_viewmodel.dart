import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoad(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
    debugPrint("OTP verified here: $_isOTPVerified");
    notifyListeners();
  }


  // If the mobile is not added show the snackbar
  void mobileSnackBar(){
    if (mobileController.text.isEmpty) {
      _snackbarService.showSnackbar(message: "Enter a Registered Mobile Number",);
    }else if(!RegExp(r'^[0-9]{10}$').hasMatch(mobileController.text)){
      _snackbarService.showSnackbar(message: "Enter a Valid Mobile Number",);
    }else{
      return;
    }
  }

  /// If the otp is not entered show the snackbar
  void otpSnackBar(){
    if (otpController.text.isEmpty) {
      _snackbarService.showSnackbar(message: "Enter a OTP",);
    }else if(!RegExp(r'^[0-9]{6}$').hasMatch(otpController.text)){
      _snackbarService.showSnackbar(message: "Enter a Valid OTP",);
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
  Future<void> login(String mobile) async {
    isLoad = true;
     await auth.login(mobile).then(
      (value){
        if(value){
          verifyAccount();
          startTimer();
        }
        isLoad = false;
        notifyListeners();
      }
    );
  }
 

  Future<void> verifyOtp(String otp) async {
    isLoad = true;
    await auth.verifyOtp(otp).then((value) {
      if(value) {
        verifiedOTP();
        _isOTPVerified ? navigateHome() : null;  
      }
      isLoad = false;
      notifyListeners();
    });
  }
  
  // Move to signup screen 
  void navigateSignup() => _navigationService.replaceWithSignupView();
  
  // Navigate to home screen view
  void navigateHome()  => _navigationService.replaceWithAppView();


  
  void onDispose() {
    mobileController.dispose();
    otpController.dispose();
    timer?.cancel();
  }

  List<String> images = [
      // "https://images.unsplash.com/photo-1634170380000-4b3b3b3b3b3b",
      "https://i.ytimg.com/vi/af98UXA1s4I/maxresdefault.jpg",
      "https://static.vecteezy.com/system/resources/previews/023/576/936/large_2x/beautiful-coastal-sunset-seascape-scenery-of-rocky-coast-at-wild-atlantic-way-in-barna-galway-ireland-free-photo.jpg",
      "https://papers.co/desktop/wp-content/uploads/papers.co-nf16-sea-ocean-nature-sunset-rock-wave-29-wallpaper.jpg",
      "https://samueldurfeehouse.com/wp-content/uploads/2023/05/shutterstock_2129390144-768x512.jpg",
      "https://mir-s3-cdn-cf.behance.net/project_modules/2800_opt_1/94012896263347.5eaa3c9e847cb.jpg",
      "https://images.squarespace-cdn.com/content/v1/55317945e4b0cb1542a52840/1430429636991-1MARAQ5LKITS8NOFTTLX/15523267694_e01cd76813_h.jpg",
      "https://www.pixelstalk.net/wp-content/uploads/2016/08/Best-Nature-Full-HD-Images-For-Desktop.jpg",
      "https://live.staticflickr.com/8575/16528381587_05a625723b_b.jpg",
      "https://pixnio.com/free-images/2017/10/24/2017-10-24-07-06-36-850x567.jpg",
      "https://images.squarespace-cdn.com/content/v1/55317945e4b0cb1542a52840/1430429636991-1MARAQ5LKITS8NOFTTLX/15523267694_e01cd76813_h.jpg",
      "https://thewowstyle.com/wp-content/uploads/2015/01/free-beautiful-place-wallpaper-hd-173.jpg",
      "https://www.pixelstalk.net/wp-content/uploads/2016/07/Wallpapers-pexels-photo.jpg",
      "https://photographylife.com/wp-content/uploads/2014/09/Nikon-D750-Image-Samples-2.jpg", 
    ];

  final PagingController<String, String> _pagingController = PagingController(firstPageKey: '');

  PagingController<String, String> get pagingController => _pagingController; 

  final Uint16List data = Uint16List(100);
}


/// OOPS  -> 
/// class, object, constructors, this, super, static, 
/// inheritence, overriding, abstract class, interface, 
/// mixins, generics, sealed class, final class, 
/// factory constructor, extension, named constructor, 
/// async, await, future, stream, yield, yield*,