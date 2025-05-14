import 'package:dio/dio.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('login', data: {
      'email': email,
      'password': password,
    });

    return response.data;
  }
}
