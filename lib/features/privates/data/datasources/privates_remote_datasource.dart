import 'package:dio/dio.dart';

abstract class PrivatesRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
}

class PrivatesRemoteDataSourceImpl implements PrivatesRemoteDataSource {
  final Dio dio;

  PrivatesRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('login', data: {
      'email': email,
      'password': password,
    });

    return response.data;
  }
}
