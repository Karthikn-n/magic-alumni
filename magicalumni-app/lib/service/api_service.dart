import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/model/jobs_model.dart';
import 'package:magic_alumni/model/news_model.dart';
import 'package:magic_alumni/model/peoples_model.dart';
import 'package:stacked_services/stacked_services.dart';

import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _apiService = ApiService._internal();
  final Dio _dio = Dio();

  List<NewsModel> newsList = [];
  List<EventsModel> eventsList = [];
  List<JobsModel> jobsList = [];
  List<PeoplesModel> peoplesList = [];

  final SnackbarService _snackbarService = locator<SnackbarService>();

  // Get all the news for the college from the API
  Future<List<NewsModel>> news() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}news/list",
        data: {
          "alumni_id": "6777879c28985edd68efbba2",
          "college_id": "677778f82a2bd99272a30ebf",
        }
      );
      if (response.statusCode == 200 && response.data["message"] == "News retrieved successfully") {
        List<dynamic> newsResponse =  (response.data["newsList"] ?? []) as List<dynamic>;
        newsList = newsResponse.map((news) => NewsModel.fromMap(news) ,).toList();
        debugPrint("News: ${newsList.length}");
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
          "alumni_id": "676fbaa59e94f0c187a53cd9",
          "college_id": "676fbaa59e94f0c187a53cdc",
        }
      );
      if (response.statusCode == 200) {
        List<dynamic> eventsResponse =  (response.data ?? []) as List<dynamic>;
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
      if (response.statusCode == 201) {
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

  /// Create the Jobs API and Get the List of Jobs from the DB send it to the View
  Future<List<JobsModel>> jobs() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}jobs",
        data: {
          "college_id": "677778f82a2bd99272a30ebf",
        }
      );
      if (response.statusCode == 200) {
        List<dynamic> jobsResponse =  (response.data["jobsList"] ?? []) as List<dynamic>;
        jobsList = jobsResponse.map((job) => JobsModel.fromMap(job) ,).toList();
        debugPrint("JObs: ${jobsList.length}");
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
  Future<List<PeoplesModel>> peoples() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}alumni",
        data: {
          "college_id": "677778f82a2bd99272a30ebf",
        }
      );
      if (response.statusCode == 200) {
        List<dynamic> peoplesResponse =  (response.data["peopels"] ?? []) as List<dynamic>;
        peoplesList = peoplesResponse.map((alumni) => PeoplesModel.fromJson(alumni) ,).toList();
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
      }
    } on DioException catch (err, st) {
      log("Something went on creating Job $err", stackTrace: st, error: err.toString());
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