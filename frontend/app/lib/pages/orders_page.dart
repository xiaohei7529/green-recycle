import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_controller.dart';
import '../utils/app_theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OrdersController _ctrl;

  static const _tabs = [
    {'label': '全部', 'status': null},
    {'label': '待接单', 'status': 0},
    {'label': '回收中', 'status': 2},
    {'label': '已完成', 'status': 3},
    {'label': '已取消', 'status': 4},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _ctrl = Get.put(OrdersController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<OrdersController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的订单'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _tabs
              .map((t) => Tab(text: t['label'] as String))
              .toList(),
        ),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }
        if (_ctrl.errorMsg.isNotEmpty) {
          return _buildError();
        }
        return TabBarView(
          controller: _tabController,
          children: _tabs
              .map((t) => _buildOrderList(_ctrl.getFiltered(t['status'] as int?)))
              .toList(),
        );
      }),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 64, color: AppTheme.textHint),
          const SizedBox(height: 16),
          Text('加载失败', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _ctrl.fetchOrders,
            icon: const Icon(Icons.refresh),
            label: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textHint),
            const SizedBox(height: 12),
            const Text('暂无订单', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed('/create-order'),
              icon: const Icon(Icons.add),
              label: const Text('立即下单'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: _ctrl.fetchOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        itemBuilder: (_, i) => _buildOrderCard(list[i]),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = (order['status'] as num?)?.toInt() ?? 0;
    final statusTxt = OrdersController.statusText(status);
    final statusClr = OrdersController.statusColor(status);
    final statusBg = OrdersController.statusBgColor(status);
    final orderId = (order['order_id'] as num?)?.toInt() ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单头部
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['order_no'] as String? ?? '-',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusTxt,
                    style: TextStyle(
                      color: statusClr,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 订单信息
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppTheme.textHint),
                const SizedBox(width: 6),
                Text(
                  '${(order['type'] as num?) == 1 ? '上门回收' : '站点回收'}  ·  ${order['pickup_time'] ?? '-'}',
                  style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.scale_outlined, size: 16, color: AppTheme.textHint),
                const SizedBox(width: 6),
                Text(
                  '${order['total_weight'] ?? '-'} kg',
                  style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const Spacer(),
                Text(
                  '¥ ${order['total_amount'] ?? '-'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppTheme.divider),
            const SizedBox(height: 8),
            // 操作按钮（替换已废弃的 ButtonBar）
            OverflowBar(
              alignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                if (status == 0)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.danger,
                      side: const BorderSide(color: AppTheme.danger),
                    ),
                    onPressed: () => _confirmCancel(orderId),
                    child: const Text('取消'),
                  ),
                ElevatedButton(
                  onPressed: () => _showOrderDetail(order),
                  child: const Text('查看详情'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(int orderId) {
    Get.dialog(
      AlertDialog(
        title: const Text('取消订单'),
        content: const Text('确定要取消该订单吗？'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await _ctrl.cancelOrder(orderId);
              if (ok) {
                Get.snackbar('成功', '订单已取消',
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.snackbar('失败', '取消失败，请重试',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppTheme.dangerLight);
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
            child: const Text('确定取消'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetail(Map<String, dynamic> order) {
    // 展示订单详情底部弹窗
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('订单详情',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: Get.back, icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            _detailRow('订单号', order['order_no'] ?? '-'),
            _detailRow('类型', (order['type'] as num?) == 1 ? '上门回收' : '站点回收'),
            _detailRow('联系人', order['contact_name'] ?? '-'),
            _detailRow('联系电话', order['contact_phone'] ?? '-'),
            _detailRow('地址', order['address'] ?? '-'),
            _detailRow('预约时间', order['pickup_time'] ?? '-'),
            _detailRow('备注', order['remarks'] ?? '-'),
            const Divider(),
            _detailRow('重量', '${order['total_weight'] ?? '-'} kg'),
            _detailRow(
              '金额',
              '¥ ${order['total_amount'] ?? '-'}',
              valueColor: AppTheme.primary,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? AppTheme.textPrimary,
                fontWeight:
                    valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
