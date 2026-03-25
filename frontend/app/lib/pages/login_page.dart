import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePwd = true;

  final _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Logo 区域
              const Column(
                children: [
                  Icon(Icons.recycling, size: 80, color: AppTheme.primary),
                  SizedBox(height: 12),
                  Text(
                    'Green Recycle',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '让回收更简单，让地球更美好',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 52),
              // 登录表单
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '账号登录',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: '手机号',
                            hintText: '请输入11位手机号',
                            prefixIcon: Icon(Icons.phone_android_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return '请输入手机号';
                            if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(v.trim())) {
                              return '请输入正确的手机号';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePwd,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                          decoration: InputDecoration(
                            labelText: '密码',
                            hintText: '请输入密码',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePwd
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.textHint,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePwd = !_obscurePwd),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return '请输入密码';
                            if (v.length < 6) return '密码至少 6 位';
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text('立即登录'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('还没有账号？', style: TextStyle(color: AppTheme.textSecondary)),
                  TextButton(
                    onPressed: () => Get.snackbar(
                      '提示',
                      '注册功能即将上线',
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                    child: const Text(
                      '立即注册',
                      style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final ok = await _auth.login(
      _phoneCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        '登录失败',
        '手机号或密码错误，请重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.dangerLight,
        colorText: AppTheme.danger,
      );
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
