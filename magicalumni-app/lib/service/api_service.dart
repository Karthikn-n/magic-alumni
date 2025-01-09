import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/model/jobs_model.dart';
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

  AlumniModel? alumni;
  List<CollegesModel> collegesList = [];

  final SnackbarService _snackbarService = locator<SnackbarService>();

  /// Get Alumni profile API 
  /// It call the API via dio Service and get the User information from the Database
  /// Before Send the data It encrypt using [EncryptionService]
  /// Parse the Alumni data from the response using [AlumniModel]
  /// Store it in the local Storage using [FlutterSecureStorage] for maintain session
  Future<void> fetchAlumni() async {
    try {
      final response = await _dio.post(
        "${baseApiUrl}alumni/member",
        data: {"alumni_id": await storage.read(key: "alumni_id")}
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        alumni = AlumniModel.fromJson(response.data);
        String alumniId =  await storage.read(key: "alumni_id") ?? " ";
        await storage.write(key: alumniId, value: json.encode(alumni?.toMap()));
        final alumniDetail = await storage.read(key: alumniId);
        debugPrint("Alumni Details: $alumniDetail");
      }
    } on DioException catch (err, st) {
      log("Something went on Requesting Alumni Profile", stackTrace: st, error: err.toString());
      final statusCode = err.response!.statusCode;
      final message = err.response!.data["message"] ?? "Unknown error occured";
      final status = err.response!.data["status"] ?? "Error";
      if((status == "not ok" && statusCode == 400) 
        || (status == "not found" && statusCode == 404)
        || (status == "error" && status == 500) ) {
          log("Something went on Requesting Alumni Profile $message", stackTrace: st, error: err.toString());
      } 
    }
  }


  /// Get all the College from the API and Store it in local storage 
  /// checked Working
  Future<List<CollegesModel>> colleges() async {
    try {
      final response = await _dio.get(
        "${baseApiUrl}college"
      );
      if (response.statusCode == 200 && response.data["status"] == "Ok") {
        List<dynamic> collegesRepsponse =  (response.data["collegeWithDepartments"] ?? []) as List<dynamic>;
        collegesList = collegesRepsponse.map((college) => CollegesModel.fromMap(college) ,).toList();
        debugPrint("Colleges: ${collegesList.length}");
        return collegesList;
      }else{
        log("Something went on getting colleges", error: response.data["message"]);
        return [];
      }
    } on DioException catch (err, st) {
      log("Something went on getting colleges", stackTrace: st, error: err.toString());
      return [];
    }
  }


  // Get all the news for the college from the API
  // Checked
  Future<List<NewsModel>> news() async {
    print("NEWS Detail:${{
          "alumni_id": await storage.read(key: "alumni_id"),
          "college_id": "${await storage.read(key: "college_id")}",
        }}");
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
      return [];
    }
  }

  // Get all the events for the college from the API
  Future<List<EventsModel>> events() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}events/",
        data: {
          "college_id": "${await storage.read(key: "college_id")}",
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        List<dynamic> eventsResponse =  (response.data["eventList"] ?? []) as List<dynamic>;
        eventsList = eventsResponse.map((events) => EventsModel.fromMap(events) ,).toList();
        debugPrint("Events: ${eventsList.length}");
        return eventsList;
      }else{
        log("Something went on getting events ${response.data["message"]}", error: response.data["message"]);
        return [];
      }
    } on DioException catch (err, st) {
      log("Something went on getting events", stackTrace: st, error: err.toString());
      return [];
    }
  }

  /// Create the Event only the Alumni who is Alumni Coordinator can create this Events
  Future<bool> eventCreate(Map<String, dynamic> data) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}events/create",
        data: data
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
        log("Something went on creating events  ${response.data["message"]}", error: response.data["message"]);
      }
    } on DioException catch (err, st) {
      log("Something went on creating events $err", stackTrace: st, error: err.toString());
    }
    return false;
  }

  /// API that send User interest to the Event creater
  Future<bool> giveRsvp(String eventId, String feedback) async {
     try{
      final response = await _dio.post(
        "${baseApiUrl}events/updatePeople",
        data: {
          "alumni_id": await storage.read(key: "alumni_id"),
          "event_id": eventId,
          "status": feedback,
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
        log("Something went on events feedback  ${response.data["message"]}", error: response.data["message"]);
      }
    } on DioException catch (err, st) {
      log("Something went on events feedback  $err", stackTrace: st, error: err.toString());
    }
    return false;
  }
  
  /// This will gives the count of interested people 
  Future<String> eventPeopleCount(String eventId, String feedback) async {
     try{
      final response = await _dio.post(
        "${baseApiUrl}events/eventpeople",
        data: {
          "event_id": eventId,
        }
      );
      if (response.statusCode == 200 && response.data["status"] == "ok") {
        return response.data["eventPeople"].toString();
      }else{
        log("Something went on events feedback  ${response.data["message"]}", error: response.data["message"]);
      }
    } on DioException catch (err, st) {
      log("Something went on events feedback  $err", stackTrace: st, error: err.toString());
    }
    return "0";
  }

  /// Create the Jobs API and Get the List of Jobs from the DB send it to the View
  Future<List<JobsModel>> jobs() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}jobs",
        data: {
          "college_id": "${await storage.read(key: "college_id")}",
        }
      );
      print({
          "college_id": "${await storage.read(key: "college_id")}",
        });
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
      return [];
    }
  }

  /// Call Peoples API from and Send it to the View
  Future<List<AlumniProfileModel>> peoples() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}alumni",
        data: {
          "college_id": "${await storage.read(key: "college_id")}",
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
      return [];
    }
  }

  /// Create the Event only the Alumni who is Alumni Coordinator can create this Events
  Future<bool> jobCreate(Map<String, dynamic> data) async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}jobs/create",
        data: data
      );
      if (response.statusCode == 201) {
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
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

  /// Add new college to the Alumni list
  Future<bool> addCollege(Map<String, dynamic> data) async {
     try{
      final response = await _dio.post(
        "${baseApiUrl}alumni/addCollege",
        data: data
      );
      if (response.statusCode == 201 && response.data["status"] == "ok") {
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
        return true;
      }else{
        _snackbarService.showSnackbar(message: response.data["message"], duration: Duration(milliseconds: 1200));
        debugPrint("Something went on add college ${response.data["message"]}");
        return false;
      }
    } on DioException catch (err, st) {
      log("Something went on add college $err", stackTrace: st, error: err.toString());
    }
    return false;
  }


  // Factory constructor to return the instance of the ApiService
  factory ApiService() {
    return _apiService;
  }

  // private constructor for the singleton
  ApiService._internal();
}