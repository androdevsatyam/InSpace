import 'package:dio/dio.dart';

class ApiService {
  final Dio client;

  ApiService({Dio? client}) : client = client ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));

  Future<Response<dynamic>> get(String path) => client.get(path);
}
