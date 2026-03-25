import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class OrdersController extends GetxController {
  final _api = Get.find<ApiService>();

  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    errorMsg.value = '';
    try {
      final res = await _api.get('/orders');
      final data = res.data;
      final list = (data['orders'] ?? data) as List<dynamic>;
      orders.value = list.cast<Map<String, dynamic>>();
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelOrder(int id) async {
    try {
      await _api.put('/orders/$id/cancel');
      await fetchOrders();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<Map<String, dynamic>> getFiltered(int? status) {
    if (status == null) return orders;
    return orders.where((o) => o['status'] == status).toList();
  }

  static String statusText(int status) => const {
        0: '待接单',
        1: '已接单',
        2: '回收中',
        3: '已完成',
        4: '已取消',
      }[status] ??
      '未知';

  static Color statusColor(int status) {
    switch (status) {
      case 0:
        return const Color(0xFFF59E0B);
      case 1:
        return const Color(0xFF3B82F6);
      case 2:
        return const Color(0xFF8B5CF6);
      case 3:
        return const Color(0xFF10B981);
      case 4:
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  static Color statusBgColor(int status) {
    switch (status) {
      case 0:
        return const Color(0xFFFFFBEB);
      case 1:
        return const Color(0xFFEFF6FF);
      case 2:
        return const Color(0xFFF5F3FF);
      case 3:
        return const Color(0xFFECFDF5);
      case 4:
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFF5F5F5);
    }
  }
}
