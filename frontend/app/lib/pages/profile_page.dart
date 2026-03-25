import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('个人中心')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户信息卡片
            Obx(() => Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            auth.maskedPhone.isNotEmpty
                                ? auth.maskedPhone.substring(0, 1)
                                : '我',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.maskedPhone,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '普通用户',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),

            // 统计数据
            Obx(() => Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem('${auth.points}', '积分'),
                      _divider(),
                      _statItem('-', '订单'),
                      _divider(),
                      _statItem('-', '收益'),
                    ],
                  ),
                )),

            // 功能菜单
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  _menuItem(
                    Icons.receipt_long_outlined,
                    '我的订单',
                    onTap: () {
                      // 通过回调通知 MainPage 切换 Tab
                      // 这里用 Get.snackbar 提示导航
                      Get.snackbar('提示', '请点击底部「订单」Tab',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 1));
                    },
                  ),
                  _dividerLine(),
                  _menuItem(
                    Icons.location_on_outlined,
                    '我的地址',
                    onTap: () => Get.snackbar('提示', '功能即将上线',
                        snackPosition: SnackPosition.BOTTOM),
                  ),
                  _dividerLine(),
                  _menuItem(
                    Icons.card_giftcard_outlined,
                    '积分商城',
                    onTap: () => Get.snackbar('提示', '功能即将上线',
                        snackPosition: SnackPosition.BOTTOM),
                  ),
                  _dividerLine(),
                  _menuItem(
                    Icons.headset_mic_outlined,
                    '客服中心',
                    onTap: () => Get.snackbar('提示', '功能即将上线',
                        snackPosition: SnackPosition.BOTTOM),
                  ),
                  _dividerLine(),
                  _menuItem(
                    Icons.settings_outlined,
                    '设置',
                    onTap: () => Get.snackbar('提示', '功能即将上线',
                        snackPosition: SnackPosition.BOTTOM),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 退出登录
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _confirmLogout(auth),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.dangerLight,
                    foregroundColor: AppTheme.danger,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('退出登录',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(AuthController auth) {
    Get.dialog(
      AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(
            onPressed: () {
              Get.back();
              auth.logout();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
            child: const Text('确定退出'),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 36, color: AppTheme.divider);
  }

  Widget _dividerLine() {
    return const Divider(height: 1, indent: 56, color: AppTheme.divider);
  }

  Widget _menuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title,
          style:
              const TextStyle(fontSize: 15, color: AppTheme.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textHint),
      onTap: onTap,
    );
  }
}
