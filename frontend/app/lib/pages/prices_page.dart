import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/prices_controller.dart';
import '../utils/app_theme.dart';

class PricesPage extends StatefulWidget {
  const PricesPage({super.key});

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  late PricesController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(PricesController());
  }

  @override
  void dispose() {
    Get.delete<PricesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('回收价格')),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }
        if (_ctrl.errorMsg.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_outlined,
                    size: 64, color: AppTheme.textHint),
                const SizedBox(height: 16),
                const Text('加载失败',
                    style: TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _ctrl.fetchPrices,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重试'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: _ctrl.fetchPrices,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // 提示条
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppTheme.primaryDark, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '价格每日更新，以实际回收为准',
                        style: TextStyle(
                            color: AppTheme.primaryDeep, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              // 分类卡片
              ..._ctrl.categories.map((cat) => _buildCategoryCard(cat)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat) {
    final name = cat['name'] as String? ?? '未知';
    final items = (cat['items'] as List<dynamic>?) ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.category_outlined, color: AppTheme.primary),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: items.map<Widget>((item) {
          final m = item as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    m['name'] as String? ?? '-',
                    style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
                  ),
                ),
                Text(
                  '¥${m['price']}/${m['unit'] ?? 'kg'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.danger,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
