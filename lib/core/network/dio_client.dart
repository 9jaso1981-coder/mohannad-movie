import 'package:dio/dio.dart';

/// Single shared Dio instance. Internet Archive's API needs no auth headers,
/// which keeps this client intentionally simple — no token/interceptor logic
/// since there is no user/account layer in this app.
class DioClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );
  }
}
