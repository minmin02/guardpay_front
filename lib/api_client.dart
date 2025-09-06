import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment(
      'BASE_URL',
      defaultValue: 'http://10.0.2.2:8080', // 에뮬레이터에서 PC localhost 접근
    ),
  ));

  Future<String> health() async {
    final res = await _dio.get('/health');
    return res.data.toString(); // "ok"
  }
}
