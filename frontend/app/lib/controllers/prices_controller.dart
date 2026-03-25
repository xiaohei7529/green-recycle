import 'package:get/get.dart';
import '../services/api_service.dart';

class PricesController extends GetxController {
  final _api = Get.find<ApiService>();

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrices();
  }

  Future<void> fetchPrices() async {
    isLoading.value = true;
    errorMsg.value = '';
    try {
      final res = await _api.get('/prices');
      final data = res.data;
      final list = (data['prices'] ?? data) as List<dynamic>;
      final raw = list.cast<Map<String, dynamic>>();

      // 按 category_name 分组
      final Map<String, List<Map<String, dynamic>>> grouped = {};
      for (final item in raw) {
        final cat = item['category_name'] as String? ??
            item['category'] as String? ??
            '其他';
        grouped.putIfAbsent(cat, () => []).add(item);
      }

      categories.value = grouped.entries
          .map((e) => {'name': e.key, 'items': e.value})
          .toList();
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
