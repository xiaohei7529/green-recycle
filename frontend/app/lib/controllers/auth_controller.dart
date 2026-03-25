import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final _api = Get.find<ApiService>();

  final RxBool isLoggedIn = false.obs;
  final Rx<Map<String, dynamic>> userInfo = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final stored = prefs.getString('userInfo') ?? '';
    if (token.isNotEmpty) {
      isLoggedIn.value = true;
      if (stored.isNotEmpty) {
        userInfo.value = jsonDecode(stored) as Map<String, dynamic>;
      }
    }
  }

  Future<bool> login(String phone, String password) async {
    try {
      final res = await _api.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });
      final token = res.data['token'] as String;
      final user = res.data['user'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userInfo', jsonEncode(user));
      userInfo.value = user;
      isLoggedIn.value = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userInfo');
    userInfo.value = {};
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  String get maskedPhone {
    final phone = userInfo.value['phone'] as String? ?? '';
    if (phone.length >= 11) {
      return '${phone.substring(0, 3)}****${phone.substring(7)}';
    }
    return phone.isEmpty ? '未设置' : phone;
  }

  int get points => (userInfo.value['points'] as num?)?.toInt() ?? 0;
}
