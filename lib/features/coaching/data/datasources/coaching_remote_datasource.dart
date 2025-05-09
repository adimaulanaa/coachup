import 'package:dio/dio.dart';

abstract class CoachingRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
}

class CoachingRemoteDataSourceImpl implements CoachingRemoteDataSource {
  final Dio dio;

  CoachingRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('login', data: {
      'email': email,
      'password': password,
    });

    return response.data;
  }
}
