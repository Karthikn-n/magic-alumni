import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/model/colleges_model.dart';
import 'package:magic_alumni/service/dio_service.dart';
import 'package:magic_alumni/service/encrption_service.dart';
import 'package:magic_alumni/service/onesignal_service.dart';
import 'package:stacked_services/stacked_services.dart';


class  AuthenticateService {
  static final AuthenticateService _authenticateService = AuthenticateService._internal();
  final _dio = DioService.dio;
  final SnackbarService snackBar = locator<SnackbarService>();
  // Local storage to store the user informations
  final FlutterSecureStorage store = FlutterSecureStorage();

  final OnesignalService _onesignalService = OnesignalService();
  
  AlumniModel? _alumni;
  CollegesModel? _currentCollege;
  CollegesModel? get currentCollege => _currentCollege;
  AlumniModel? get alumni => _alumni;


  /// Register API for the Alumni 
  /// Store the Alumni id and alumni approval Status from response for future use
  /// Checked Working
  Future<bool> register(Map<String, dynamic> data) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}member/register",
        data: data
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        await store.write(key: "alumni_id", value: response.data["_id"].toString());
        await store.write(key: "college_id", value: response.data["collegeid"].toString());
        await store.write(key: "alumni_role", value: response.data["role"].toString());
        snackBar.showSnackbar(message: response.data["message"], );
        await _onesignalService.oneSignalLogin(await store.read(key: "alumni_id") ?? "");
        await fetchAlumni();
        return true;
      } else{
        snackBar.showSnackbar(
            message: response.data["message"], 
           
        );
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on registering", stackTrace: st, error: err.toString());
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        snackBar.showSnackbar(message: "Request timed out. Please try again.",);
        return false;
      } 
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
         snackBar.showSnackbar(
            message: message, 
           
        );
      } 
    }
    return false;
  }

  // Login API call to authenticate the user
  // Get the response from the user
  // Store the alumni_id in local storge
  /// If the User is present in the Remote database store and call their Profile API
  /// Get the Alumni ID from the local storage
  /// Call the Alumni profile API to check their approval status
  /// store the message in the log
  /// Checked Working
  Future<bool> login(String mobile) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}member/login",
        data: {"mobile_number": mobile},
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        await store.write(key: "alumni_mobile", value: mobile.toString());
        snackBar.showSnackbar(
            message: response.data["message"], 
        );
        return true;
      } else{
        snackBar.showSnackbar(message: response.data["message"], );
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on request login", error: err.toString(), stackTrace: st);
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        snackBar.showSnackbar(message: "Request timed out. Please try again.",);
        return false;
      } 
      final statusCode = err.response!.statusCode ?? 100;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
         snackBar.showSnackbar(message: message, );
      } 
    }
    return false;
  }

  /// Verify the OTP from their Mobile message
  Future<bool> verifyOtp(String otp) async {
    try {
      final response = await _dio.post(
        "${baseApiUrl}member/verifyOtp",
        data: {
          "mobile_number": await store.read(key: "alumni_mobile"),
          "otp": otp
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        await store.write(key: "loggedIn${await store.read(key: "alumni_mobile")}", value: "success");
        await store.write(key: "alumni_id", value: response.data["alumni_id"].toString());
        await store.write(key: "alumni_role", value: response.data["role"].toString());
        await store.write(key: "alumni_status", value: response.data["approvalStatus"].toString());
        await store.write(key: "college_id", value: response.data["college_id"].toString());
        snackBar.showSnackbar(message: response.data["message"], );
        /// Login to the one signal app with external ID
        await _onesignalService.oneSignalLogin(await store.read(key: "alumni_id") ?? "");
        debugPrint('Alumni ID : ${await store.read(key: "alumni_id")}');
        debugPrint('Alumni Role : ${await store.read(key: "alumni_role")}');
        debugPrint('Alumni Status : ${await store.read(key: "alumni_status")}');
        debugPrint('Alumni College ID : ${await store.read(key: "college_id")}');
        final alumni = await fetchAlumni();
        if(alumni == null) return false;
        return true;
      }  else {
          snackBar.showSnackbar(message: response.data["message"], );
      }
      return false;
    } on DioException catch (err, st) {
      log("Something went on Verify OTP", stackTrace: st, error: err.toString());
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        snackBar.showSnackbar(message: "Request timed out. Please try again.",);
        return false;
      } 
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
         snackBar.showSnackbar(message: message, );
      } 
      return false;
    }
  }

  /// Get Alumni profile API 
  /// It call the API via dio Service and get the User information from the Database
  /// Before Send the data It encrypt using [EncryptionService]
  /// Parse the Alumni data from the response using [AlumniModel]
  /// Store it in the local Storage using [FlutterSecureStorage] for maintain session
  Future<AlumniModel?>? fetchAlumni() async {
    debugPrint("Alumni-id: ${await store.read(key: "alumni_id")}");
    try {
      final response = await _dio.post(
        "${baseApiUrl}member/profile",
        data: {"alumni_id": await store.read(key: "alumni_id")}
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        _alumni = AlumniModel.fromJson(response.data);
        await setInitialCollege(_alumni!.colleges[0].id);
        debugPrint("Alumni Profile: ${response.data}");
        return alumni;
      }
      return null;
    } on DioException catch (err, st) {
      log("Something went on Requesting Alumni Profile", stackTrace: st, error: err.toString());
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        snackBar.showSnackbar(message: "Request timed out. Please try again.",);
        return null;
      } 
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on Requesting Alumni Profile $message", stackTrace: st, error: err.toString());
      } 
      return null;
    }
  }

  Future<void> setInitialCollege(String id) async {
    await store.write(key: "current_college", value: id);
    await getCurrentCollege();
  }

  Future<void> setCurrentCollege(String id) async {
    await store.write(key: "current_college", value: id);
    _currentCollege = alumni!.colleges.firstWhere((element) => element.id == id, orElse: () => alumni!.colleges[0]);
  }
  
  Future<CollegesModel?> getCurrentCollege() async {
    if(_currentCollege != null) return _currentCollege;
    final collegeId = await store.read(key: "current_college") ?? alumni!.colleges[0].id;
    _currentCollege = alumni!.colleges.firstWhere((element) => element.id == collegeId, orElse: () => alumni!.colleges[0]);
    return _currentCollege;
  }


  /// Update the alumni || Student profile If they want to edit after approval
  Future<bool> update(Map<String, dynamic> data) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}member/update",
        data: data
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        snackBar.showSnackbar(message: response.data["message"], );
        await fetchAlumni();
        return true;
      } else{
        snackBar.showSnackbar(message: response.data["message"], );
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on registering", stackTrace: st, error: err.toString());
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        snackBar.showSnackbar(message: "Request timed out. Please try again.",);
        return false;
      } 
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
         snackBar.showSnackbar(message: message, );
      } 
    }
    return false;
  }


  /// clear the User session from the App
  /// Delete their ID and Profile
  Future<void> logout() async {
    await store.delete(key: await store.read(key: "alumni_id") ?? '-1');
    await store.delete(key: "alumni_id");
  }
  

  /// Factory constructor that gives same instance of this Service across the App
  factory AuthenticateService(){
    return _authenticateService;
  }

  // Private constructor to ensure only one instance is created across the APP
  AuthenticateService._internal();
}