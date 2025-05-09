import 'package:dio/dio.dart';

abstract class StudentsRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
}

class StudentsRemoteDataSourceImpl implements StudentsRemoteDataSource {
  final Dio dio;

  StudentsRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('login', data: {
      'email': email,
      'password': password,
    });

    return response.data;
  }
}
