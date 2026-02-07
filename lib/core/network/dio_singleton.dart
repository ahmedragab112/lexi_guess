import 'package:dio/dio.dart';

class DioSingleton {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com', 
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static void init() {
    
    
  }
}
