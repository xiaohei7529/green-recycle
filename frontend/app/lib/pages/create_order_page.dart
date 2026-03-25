import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  int _orderType = 1; // 1=上门, 2=站点
  String? _selectedCategory;
  DateTime? _pickupTime;
  bool _isSubmitting = false;

  final _categories = ['纸类', '塑料', '金属', '电器', '其他'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('发起回收')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 回收类型
              _buildSection(
                title: '回收方式',
                child: Row(
                  children: [
                    Expanded(
                      child: _typeButton(
                        icon: Icons.directions_car_outlined,
                        label: '上门回收',
                        selected: _orderType == 1,
                        onTap: () => setState(() => _orderType = 1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _typeButton(
                        icon: Icons.store_outlined,
                        label: '站点回收',
                        selected: _orderType == 2,
                        onTap: () => setState(() => _orderType = 2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 废品信息
              _buildSection(
                title: '废品信息',
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                          labelText: '废品类型', prefixIcon: Icon(Icons.category_outlined)),
                      items: _categories
                          .map((c) =>
                              DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCategory = v),
                      validator: (v) => v == null ? '请选择废品类型' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _weightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: '预估重量',
                        prefixIcon: Icon(Icons.scale_outlined),
                        suffixText: 'kg',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return '请输入预估重量';
                        if (double.tryParse(v) == null) return '请输入有效数字';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 上门信息
              _buildSection(
                title: '上门信息',
                child: Column(
                  children: [
                    // 时间选择
                    InkWell(
                      onTap: _selectPickupTime,
                      borderRadius: BorderRadius.circular(8),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '预约上门时间',
                          prefixIcon: Icon(Icons.access_time_outlined),
                        ),
                        child: Text(
                          _pickupTime == null
                              ? '请选择时间'
                              : '${_pickupTime!.year}-${_pickupTime!.month.toString().padLeft(2, '0')}-${_pickupTime!.day.toString().padLeft(2, '0')} ${_pickupTime!.hour.toString().padLeft(2, '0')}:${_pickupTime!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: _pickupTime == null
                                ? AppTheme.textHint
                                : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: '详细地址',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '请输入详细地址' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: '联系人',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '请输入联系人' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: '联系电话',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return '请输入联系电话';
                        if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(v.trim())) {
                          return '请输入正确的手机号';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 备注
              _buildSection(
                title: '备注（选填）',
                child: TextFormField(
                  controller: _remarksCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: '如有特殊要求请填写',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitOrder,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('立即下单', style: TextStyle(fontSize: 17)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _typeButton({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryLight : const Color(0xFFF9FAFB),
          border: Border.all(
            color: selected ? AppTheme.primary : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: selected ? AppTheme.primary : AppTheme.textHint,
                size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppTheme.primary : AppTheme.textSecondary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPickupTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (!mounted || time == null) return;

    setState(() {
      _pickupTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickupTime == null) {
      Get.snackbar('提示', '请选择预约上门时间',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final api = Get.find<ApiService>();
      final pt = _pickupTime!;
      final pickupStr =
          '${pt.year}-${pt.month.toString().padLeft(2, '0')}-${pt.day.toString().padLeft(2, '0')} ${pt.hour.toString().padLeft(2, '0')}:${pt.minute.toString().padLeft(2, '0')}:00';

      await api.post('/orders', data: {
        'type': _orderType,
        'address': _addressCtrl.text.trim(),
        'contact_name': _nameCtrl.text.trim(),
        'contact_phone': _phoneCtrl.text.trim(),
        'pickup_time': pickupStr,
        'remarks': _remarksCtrl.text.trim(),
        'items': [
          {'category_id': 1, 'estimated_weight': double.tryParse(_weightCtrl.text) ?? 0.0}
        ],
      });

      if (!mounted) return;
      Get.back();
      Get.snackbar(
        '下单成功 🎉',
        '您的回收预约已提交，请等待接单',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primaryLight,
        colorText: AppTheme.primaryDeep,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        '下单失败',
        '网络错误，请重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.dangerLight,
        colorText: AppTheme.danger,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _addressCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }
}
