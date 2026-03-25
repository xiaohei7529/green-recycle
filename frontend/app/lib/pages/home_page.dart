import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';
import 'create_order_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('♻ Green Recycle'),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    auth.maskedPhone,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              )),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 欢迎横幅
              Obx(() => Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '你好，${auth.maskedPhone}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              const Text('让回收更简单',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '积分 ${auth.points}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.recycling,
                            size: 72, color: Colors.white54),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // 快速下单
              Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.flash_on,
                        color: AppTheme.primaryDark, size: 28),
                  ),
                  title: const Text('快速下单',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: const Text('一键预约，上门回收',
                      style: TextStyle(color: AppTheme.textSecondary)),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppTheme.textHint),
                  onTap: () => Get.to(() => const CreateOrderPage()),
                ),
              ),
              const SizedBox(height: 16),

              // 功能网格
              const Text(
                '功能入口',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _gridItem(Icons.receipt_long_outlined, '我的订单',
                      AppTheme.primary),
                  _gridItem(Icons.price_change_outlined, '回收价格',
                      AppTheme.warning),
                  _gridItem(Icons.location_on_outlined, '附近回收点',
                      AppTheme.info),
                  _gridItem(Icons.card_giftcard_outlined, '积分商城',
                      const Color(0xFFEC4899)),
                ],
              ),
              const SizedBox(height: 16),

              // 公告
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.campaign_outlined,
                        color: AppTheme.primaryDark),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '回收价格每日更新，欢迎下单！新人首单立减 5 元！',
                        style: TextStyle(
                            color: AppTheme.primaryDeep, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridItem(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
