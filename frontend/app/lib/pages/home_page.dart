import 'package:flutter/material.dart';
import 'create_order_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('♻️ Green Recycle'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.recycling, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      '让回收更简单',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),

            // 快速下单
            Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.orange, size: 40),
                title: const Text('快速下单', style: TextStyle(fontSize: 18)),
                subtitle: const Text('一键预约，上门回收'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateOrderPage()),
                  );
                },
              ),
            ),

            // 功能网格
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              padding: const EdgeInsets.all(10),
              children: [
                _buildGridItem(Icons.shopping_bag, '我的订单'),
                _buildGridItem(Icons.attach_money, '回收价格'),
                _buildGridItem(Icons.location_on, '附近回收点'),
                _buildGridItem(Icons.card_giftcard, '积分商城'),
              ],
            ),

            // 公告
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      '回收价格每日更新，欢迎下单！新人首单立减 5 元！',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
