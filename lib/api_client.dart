import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080')); // Android 에뮬레이터 기준

  Future<String> health() async {
    final res = await _dio.get('/health');
    return res.data.toString();
  }
}
