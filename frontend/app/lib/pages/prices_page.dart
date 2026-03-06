import 'package:flutter/material.dart';

class PricesPage extends StatelessWidget {
  const PricesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('回收价格'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 10),
                Text('价格每日更新，仅供参考', style: TextStyle(color: Colors.blue[700])),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _buildCategoryCard('📰 纸类', [
                  {'name': '报纸', 'price': '1.5', 'unit': 'kg'},
                  {'name': '纸箱', 'price': '1.2', 'unit': 'kg'},
                  {'name': '书本', 'price': '1.8', 'unit': 'kg'},
                ]),
                _buildCategoryCard('🥤 塑料', [
                  {'name': 'PET 瓶', 'price': '2.0', 'unit': 'kg'},
                  {'name': 'PE 膜', 'price': '3.5', 'unit': 'kg'},
                ]),
                _buildCategoryCard('🥫 金属', [
                  {'name': '铁', 'price': '3.5', 'unit': 'kg'},
                  {'name': '铝', 'price': '12.0', 'unit': 'kg'},
                  {'name': '铜', 'price': '45.0', 'unit': 'kg'},
                ]),
                _buildCategoryCard('🔌 电器', [
                  {'name': '空调', 'price': '150', 'unit': '台'},
                  {'name': '冰箱', 'price': '100', 'unit': '台'},
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, List<Map<String, String>> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        children: items.map((item) => ListTile(
          title: Text(item['name']!),
          trailing: Text(
            '¥${item['price']}/${item['unit']}',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )).toList(),
      ),
    );
  }
}
