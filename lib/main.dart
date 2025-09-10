import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-Spring Boot Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _healthStatus = '서버 상태 확인 전';
  final Dio _dio = Dio(); // Dio 인스턴스 생성

  // Spring Boot 서버의 health check API를 호출하는 함수
  Future<void> _checkServerHealth() async {
    // 안드로이드 에뮬레이터인 경우 10.0.2.2, 그 외(iOS 시뮬레이터 등)는 localhost 사용
    final String baseUrl = 'http://localhost:8080';
    final url = '$baseUrl/health';

    setState(() {
      _healthStatus = '서버에 요청 중...'; // 요청 시작을 알리는 메시지
    });

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        // 성공적으로 'ok' 응답을 받았을 경우
        setState(() {
          _healthStatus = '서버 응답: ${response.data} (연동 성공!)';
        });
      } else {
        // 서버가 응답했지만 상태 코드가 200이 아닐 경우
        setState(() {
          _healthStatus = '연동 실패: 서버가 상태 코드 ${response.statusCode}로 응답했습니다.';
        });
      }
    } on DioException catch (e) {
      // Dio 통신 중 예외가 발생했을 경우
      // 네트워크 연결 오류, 타임아웃 등 다양한 원인이 있을 수 있습니다.
      String errorMessage;
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        errorMessage = '서버에 연결할 수 없습니다. Spring Boot 서버가 실행 중인지, IP 주소(10.0.2.2)와 포트(8080)가 올바른지 확인하세요.';
      } else {
        errorMessage = '통신 오류 발생: ${e.message}';
      }
      setState(() {
        _healthStatus = '연동 실패: $errorMessage';
      });
    } catch (e) {
      // 그 외 예외
      setState(() {
        _healthStatus = '알 수 없는 오류 발생: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Spring Boot 연동 테스트 (Dio)'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '아래 버튼을 눌러 Spring Boot 서버와 연동을 확인하세요.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _healthStatus,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkServerHealth,
                child: const Text('서버 Health Check'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
