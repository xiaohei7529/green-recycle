import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户信息
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green, Colors.lightGreen]),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('用户昵称', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                        child: const Text('138****8000', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 统计数据
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('1250', '积分'),
                  _buildStatItem('15', '订单'),
                  _buildStatItem('¥358.50', '收益'),
                ],
              ),
            ),

            // 功能列表
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(leading: const Icon(Icons.shopping_bag), title: const Text('我的订单'), trailing: const Icon(Icons.chevron_right)),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.location_on), title: const Text('我的地址'), trailing: const Icon(Icons.chevron_right)),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.card_giftcard), title: const Text('积分商城'), trailing: const Icon(Icons.chevron_right)),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.headset_mic), title: const Text('客服中心'), trailing: const Icon(Icons.chevron_right)),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.settings), title: const Text('设置'), trailing: const Icon(Icons.chevron_right)),
                ],
              ),
            ),

            // 退出按钮
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('退出登录', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
