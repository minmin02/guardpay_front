import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter ↔ Spring 연결 테스트')),
        body: Center(
          child: FutureBuilder<String>(
            future: _checkHealth(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Response: ${snapshot.data}');
              }
            },
          ),
        ),
      ),
    );
  }

  static Future<String> _checkHealth() async {
    final dio = Dio(BaseOptions(
      baseUrl: const String.fromEnvironment(
        'BASE_URL',
        defaultValue: 'http://10.0.2.2:8080',
      ),
    ));
    final res = await dio.get('/health');
    return res.data.toString();
  }
}
