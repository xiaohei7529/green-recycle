import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/orders_page.dart';
import 'pages/prices_page.dart';
import 'pages/profile_page.dart';
import 'pages/create_order_page.dart';
import 'services/api_service.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ApiService());
  Get.put(AuthController());
  runApp(const GreenRecycleApp());
}

class GreenRecycleApp extends StatelessWidget {
  const GreenRecycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return GetMaterialApp(
      title: 'Green Recycle',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: auth.isLoggedIn.value ? '/home' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(
          name: '/home',
          page: () => const MainPage(),
          middlewares: [_AuthMiddleware()],
        ),
        GetPage(
          name: '/create-order',
          page: () => const CreateOrderPage(),
          middlewares: [_AuthMiddleware()],
        ),
      ],
    );
  }
}

class _AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    if (!auth.isLoggedIn.value) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const OrdersPage();
      case 2:
        return const PricesPage();
      case 3:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: '订单',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.price_change_outlined),
            activeIcon: Icon(Icons.price_change),
            label: '价格',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
