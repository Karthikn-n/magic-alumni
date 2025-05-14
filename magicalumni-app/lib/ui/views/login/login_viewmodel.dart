import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/service/authenticate_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewmodel extends BaseViewModel{
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

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
       if (otpController.text.isEmpty || otpController.text.length < 6) {
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
      _snackbarService.showSnackbar(message: "Enter a Mobile Number",);
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
    
    final otp = Random().nextInt(900000) + 100000;
     await auth.login(mobile, otp.toString()).then(
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


  
  Future<void> notificationPermission() async {
    await Permission.notification.request();
    await Permission.sms.request();
  }

  Future<void> listenForSms() async {
    await SmsAutoFill().listenForCode();
  }

  Future<String> apphash() async {
    String? hash = await storage.read(key: "app_hash");
    if(hash == null){
      String? hash = await SmsAutoFill().getAppSignature;
      await storage.write(key: "app_hash",value: hash);
      return hash;
    } else {
      return hash;
    }
  }
 
  Future<int> generateOTP() async {
    int otp = 1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
    // await storeOtp(otp.toString());
    return otp;
  }

  Future<void> storeOtp(String otp) async{
   await storage.write(key: "last_otp", value: otp);
  }

  Future<void> clearOTP() async{
    await storage.delete(key: "last_otp");
  }

  Future<String?> getLastOtp() async {
    return storage.read(key: "last_otp");
  }

  // TODO: Check the code API once credits are restored and call this in login button
  Future<void> twilioOTPSender(String mobile) async {
    try {
      await SmsAutoFill().listenForCode();
      int? lastOtp = await generateOTP();
      String hashId = await apphash();
      String key = "f665fb10246333b640a6f6bd929e2af3";
      String templateId= "1407168862906996721";
      String sms = "Your otp for Maduraimarket is $lastOtp. Please do not share this OTP. $hashId";
      String url = "http://instantalerts.in/api/smsapi?key=$key&route=2&sender=INSTNE&number=$mobile&templateid=$templateId&sms=$sms";
      final response = await _dio.post(url);
      if (response.statusCode == 200) {
      } else {
        print("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }
}


/// OOPS  -> 
/// class, object, constructors, this, super, static, 
/// inheritence, overriding, abstract class, interface, 
/// mixins, generics, sealed class, final class, 
/// factory constructor, extension, named constructor, 
/// async, await, future, stream, yield, yield*,