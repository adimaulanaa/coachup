import 'package:dio/dio.dart';

abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('login', data: {
      'email': email,
      'password': password,
    });

    return response.data;
  }
}
