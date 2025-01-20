import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/model/jobs_model.dart';
import 'package:magic_alumni/model/mobrequest_model.dart';
import 'package:magic_alumni/model/news_model.dart';
import 'package:stacked_services/stacked_services.dart';

import '../constants/app_constants.dart';
import '../model/colleges_model.dart';

class ApiService {
  static final ApiService _apiService = ApiService._internal();
  final Dio _dio = Dio();

  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<NewsModel> newsList = [];
  List<EventsModel> eventsList = [];
  List<JobsModel> jobsList = [];
  List<AlumniProfileModel> peoplesList = [];

  AlumniModel? _alumni;
  AlumniModel? get alumni => _alumni;
  List<CollegesModel> collegesList = [];
  List<MobileRequestModel> mobRequestsList = [];

  bool isSent = false;

  /// Use snackbar service to show the messages to the User
  final SnackbarService _snackbarService = locator<SnackbarService>();

  /// Get Alumni profile API 
  /// It call the API via dio Service and get the User information from the Database
  /// Before Send the data It encrypt using [EncryptionService]
  /// Parse the Alumni data from the response using [AlumniModel]
  Future<AlumniModel?>? fetchAlumni() async {
    try {
      final response = await _dio.post(
        "${baseApiUrl}alumni/member",
        data: {"alumni_id": await storage.read(key: "alumni_id")}
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        _alumni = AlumniModel.fromJson(response.data);
        return alumni;
      }
      return null;
    } on DioException catch (err, st) {
      log("Something went on Requesting Alumni Profile", stackTrace: st, error: err.toString());
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        _snackbarService.showSnackbar(message: "Request timed out. Please try again.",);
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

  /// Get all the College from the API and Store it in local storage 
  Future<List<CollegesModel>> colleges() async {
    if (collegesList.isNotEmpty) {
      return collegesList;
    }
    try {
      final response = await _dio.get(
        "${baseApiUrl}colleges"
      );
      if (response.statusCode == 200 && response.data["status"] == "Ok") {
        List<dynamic> collegesRepsponse =  (response.data["collegeWithDepartments"] ?? []) as List<dynamic>;
        collegesList = collegesRepsponse.map((college) => CollegesModel.fromMap(college) ,).toList();
        debugPrint("Colleges: ${collegesList.length}");
        return collegesList;
      }else{
        _snackbarService.showSnackbar(message: "Can't get colleges", );
        log("Something went on getting colleges", error: response.data["message"]);
        return [];
      }
    } on DioException catch (err, st) {
      log("Something went on getting colleges", stackTrace: st, error: err.toString());
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        _snackbarService.showSnackbar(message: "Request timed out. Please try again.",);
        return [];
      } 
      return [];
    }
  }


  // Get all the news for the college from the API
  Future<List<NewsModel>> news() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}news/list",
        data: {
          "alumni_id": await storage.read(key: "alumni_id"),
          "college_id": "${await storage.read(key: "college_id")}",
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        List<dynamic> newsResponse =  (response.data["newsList"] ?? []) as List<dynamic>;
        newsList = newsResponse.map((news) => NewsModel.fromMap(news) ,).toList();
        return newsList;
      }else{
        log("Something went on getting news ${response.data["message"]}", error: response.data["message"]);
        return [];
      }
    } on DioException catch (err, st) {
      log("Something went on getting news", stackTrace: st,error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on getting news $message", stackTrace: st, error: err.toString());
      } 
      return [];
    }
  }

  /// Get all the events for the college from the API
  Future<List<EventsModel>> events() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}event/list",
        data: {
          "college_id": "${await storage.read(key: "college_id")}",
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        List<dynamic> eventsResponse =  (response.data["eventList"] ?? []) as List<dynamic>;
        eventsList = eventsResponse.map((events) => EventsModel.fromMap(events) ,).toList();
        debugPrint("Events: $eventsResponse");
        return eventsList;
      }else{
        log("Something went on getting events ${response.data["message"]}", error: response.data["message"]);
        return [];
      }
    } on DioException catch (err, st) {
      log("Something went on getting events", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on getting news $message", stackTrace: st, error: err.toString());
      } 
      return [];
    }
  }

  /// Create the Event only the Alumni who is Alumni Coordinator can create this Events
  Future<bool> eventCreate(Map<String, dynamic> data) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}event/create",
        data: data
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"],);
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], );
        log("Something went on creating event  ${response.data["message"]}", error: response.data["message"]);
      }
    } on DioException catch (err, st) {
      log("Something went on creating event $err", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on creating event $message", stackTrace: st, error: err.toString());
      } 
    }
    return false;
  }

  /// API that send User interest to the Event creater
  Future<bool> giveRsvp(String eventId, String feedback) async {
     try{
      final response = await _dio.post(
        "${baseApiUrl}event/eventPeople",
        data: {
          "alumni_id": await storage.read(key: "alumni_id"),
          "event_id": eventId,
          "interested": feedback,
        }
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], );
        isSent = true;
        return true;
      }
    } on DioException catch (err, st) {
      log("Something went on events feedback  $err", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on feedback giving $message", stackTrace: st, error: err.toString());
      } 
    }
    return false;
  }
  
  /// This will gives the count of interested people 
  Future<String> eventPeopleCount(String eventId, String feedback) async {
     try{
      final response = await _dio.post(
        "${baseApiUrl}event/eventPeopleCount",
        data: {
          "event_id": eventId,
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        return response.data["eventPeople"].toString();
      }else{
        log("Something went on event people count  ${response.data["message"]}", error: response.data["message"]);
      }
    } on DioException catch (err, st) {
      log("Something went on events feedback  $err", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on event people count $message", stackTrace: st, error: err.toString());
      } 
    }
    return "0";
  }

  /// check the status on Event
  Future<String> checkEventStatus(String eventId) async {
    try {
      final response = await _dio.post(
        "${baseApiUrl}event/status",
        data: {
          "event_id": eventId,
          "alumni_id": await storage.read(key: "alumni_id"),
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        return response.data["your_status"] ?? "";
      }
      return "";
    } on DioException catch (err, st) {
      log("Something went wrong on checking event status", stackTrace: st, error:  err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
        log("Something went on Requesting Alumni Profile $message", stackTrace: st, error: err.toString());
      } 
      return "";
    }
  }

  /// Create the Jobs API and Get the List of Jobs from the DB send it to the View
  Future<List<JobsModel>> jobs() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}job/list",
        data: {
          "college_id": "${await storage.read(key: "college_id")}",
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        List<dynamic> jobsResponse =  (response.data["jobList"] ?? []) as List<dynamic>;
        jobsList = jobsResponse.map((job) => JobsModel.fromMap(job) ,).toList();
        debugPrint("Jobs: ${jobsList.length} $jobsResponse");
        return jobsList;
      }else{
        log("Something went on getting jobs ${response.data["message"]}", error: response.data["message"]);
        return [];
      }
    } on DioException catch (err, st) {
      log("Something went on getting jobs", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on Requesting Alumni Profile $message", stackTrace: st, error: err.toString());
          
      } 
      return [];
    }
  }

  /// Call Peoples API from and Send it to the View
  Future<List<AlumniProfileModel>> peoples() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}member/allMembers",
        data: {
          "college_id": await storage.read(key: "college_id"),
          "alumni_id": await storage.read(key: "alumni_id")
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        List<dynamic> peoplesResponse =  (response.data["alumniDetails"] ?? []) as List<dynamic>;
        peoplesList = peoplesResponse.map((alumni) => AlumniProfileModel.fromJson(alumni) ,).toList();
        debugPrint("Peoples: ${peoplesList.length}");
        return peoplesList;
      }else{
        log("Something went on getting peoples  ${response.data["message"]}", error: response.data["message"]);
        return [];
      }
    } on DioException catch (err, st) {
      log("Something went on getting peoples", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on getting peoples $message", stackTrace: st, error: err.toString());
      } 
      return [];
    }
  }

  /// Create the Event only the Alumni who is Alumni Coordinator can create this Events
  Future<bool> jobCreate(Map<String, dynamic> data) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}job/create",
        data: data
      );
      if (response.statusCode == 201) {
        _snackbarService.showSnackbar(message: response.data["message"], );
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], );
        debugPrint("Something went on creating Job ${response.data["message"]}");
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on creating Job $err", stackTrace: st, error: err.toString());
       final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
        
      log("Something went on creating Job $err", stackTrace: st, error: message);
      } 
      return false;
    }
  }

  /// Report any job is not valid 
   Future<bool> reportJob(String jobId, String reason) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}job/report",
        data: {
          "job_id": jobId,
          "alumni_id": await storage.read(key: "alumni_id"),
          "reason": reason
        }
      );
      if (response.statusCode == 201) {
        _snackbarService.showSnackbar(message: response.data["message"], );
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], );
        debugPrint("Something went on reporting Job ${response.data["message"]}");
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on reporting Job $err", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
        log("Something went on reporting Job $err", stackTrace: st, error: message);
      } 
      return false;
    }
  }

  /// Add new college to the Alumni list
  Future<bool> addCollege(Map<String, dynamic> data) async {
    debugPrint("Add college URL: ${baseApiUrl}member/addCollege");
     try{
      final response = await _dio.post(
        "${baseApiUrl}member/addCollege",
        data: data
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], );
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], );
        debugPrint("Something went on add college ${response.data["message"]}");
        return false;
      }
    } on DioException catch (err, st) {
       log("Something went on request login", error: err.toString(), stackTrace: st);
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        _snackbarService.showSnackbar(message: "Request timed out. Please try again.",);
        return false;
      } 
      final statusCode = err.response!.statusCode ?? 100;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
         _snackbarService.showSnackbar(message: message,);
      }
    }
    return false;
  }

  /// Send the REquest to the alumni for the mobil number request and
  Future<bool> requestMobile(String receiver) async {
     try{
      final response = await _dio.post(
        "${baseApiUrl}member/requestMobile",
        data: {
          "sender": await storage.read(key: "alumni_id"),
          "receiver": receiver,
          "request_id": "${await storage.read(key: "alumni_id")}_$receiver",
        }
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], );
        return true;
      }else{
        debugPrint("Something went on requesting mobile number ${response.data["message"]}");
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on requesting mobile number $err", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode ?? 100;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on Requesting mobile number $message", stackTrace: st, error: err.toString());
      } 
    }
    return false;
  }

  /// List all the requestes from the alumni and student for their mobile
  Future<List<MobileRequestModel>> mobileRequestList() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}member/requestList"
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        List<dynamic> requests = (response.data["requests"] ?? []) as List<dynamic>;
        mobRequestsList = requests.map((request) => MobileRequestModel.fromJson(request),).toList();
        return mobRequestsList;
      }
      return [];
    } on DioException catch(err, st) {
      log("Somthing went wrong on listing mobile requests", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode ?? 100;
      final message = err.response!.data["message"] ?? "Unknown";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && statusCode == 500)) {
          log("Somthing went wrong on listing mobile requests", stackTrace: st, error: message);
        }
        return [];
    }
  }
  
  /// Check the requesting status from from thre reciever
  Future<bool> updateMobileRequest(String status, String requestId) async {
     try{
      final response = await _dio.post(
        "${baseApiUrl}member/requestStatusUpdate",
        data: {
          "request_id": requestId,
          "status": status
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], );
        return true;
      }else{
        debugPrint("Something went on updating status ${response.data["message"]}");
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on updating status $err", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
        log("Something went on reporting Job $err", stackTrace: st, error: message);
      } 
      return false;
    }
  }

  /// Check the requesting status from from thre reciever
  Future<String> checkStatus(String receiverId) async {
      String alumniId = await storage.read(key: "alumni_id") ?? "";
     try{
      final response = await _dio.post(
        "${baseApiUrl}member/requestStatus",
        data: {
          "request_id": "${alumniId}_$receiverId",
        }
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], );
        return response.data["requestStatus"];
      }
      return "";
    } on DioException catch (err, st) {
      log("Something went on getting status $err", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
        log("Something went on getting status $err", stackTrace: st, error: message);
      } 
      return "";
    }
  }

  /// Factory constructor to return the instance of the ApiService
  factory ApiService() {
    return _apiService;
  }

  /// private constructor for the singleton
  ApiService._internal();
}