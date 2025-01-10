import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioService {
  // Create instance singleton constructor to ensure only one instance of Dio is used
  static final DioService _dioService = DioService._internal();
  // Used to instantiate Dio across the app to make HTTP requests
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    )
  );

  // Factory constructor to return the instance of DioService if it exists
  factory DioService(){
    return _dioService;
  }

  Future<void> init() async {
    // Load the .env file
    await dotenv.load();
  }

  // Singleton constructor
  DioService._internal();
}