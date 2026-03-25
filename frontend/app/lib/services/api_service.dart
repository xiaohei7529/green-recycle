import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends GetxService {
  // Android 模拟器访问宿主机 localhost 使用 10.0.2.2；真机调试请改为实际 IP
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          await prefs.remove('userInfo');
          Get.offAllNamed('/login');
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? params,
  }) => _dio.get(path, queryParameters: params);

  Future<Response<dynamic>> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response<dynamic>> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response<dynamic>> delete(String path) => _dio.delete(path);
}
