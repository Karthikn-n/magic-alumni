import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/model/news_model.dart';

import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _apiService = ApiService._internal();
  final Dio _dio = Dio();

  List<NewsModel> newsList = [];
  List<EventsModel> eventsList = [];

  // Get all the news for the college from the API
  Future<void> news() async {
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
      }else{
        log("Something went on getting news", error: response.data["message"]);
      }
    } on DioException catch (err, st) {
      log("Something went on getting news", stackTrace: st);
    }
  }

  // Get all the events for the college from the API
  Future<void> events() async {
    try{
      final response = await _dio.post(
        "${baseApiUrl}events/",
        data: {
          "alumni_id": "676fbaa59e94f0c187a53cd9",
          "college_id": "676fbaa59e94f0c187a53cdc",
        }
      );
      if (response.statusCode == 200) {
        print(response.data);
        List<dynamic> eventsResponse =  (response.data ?? []) as List<dynamic>;
        eventsList = eventsResponse.map((events) => EventsModel.fromMap(events) ,).toList();
        debugPrint("Events: ${eventsList.length}");
      }else{
        log("Something went on getting events", error: response.data["message"]);
      }
    } on DioException catch (err, st) {
      log("Something went on getting events", stackTrace: st);
    }
  }

  // Factory constructor to return the instance of the ApiService
  factory ApiService() {
    return _apiService;
  }

  // private constructor for the singleton
  ApiService._internal();
}