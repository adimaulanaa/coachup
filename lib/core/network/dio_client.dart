import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://51.15.250.187:8006/api/method/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
}
