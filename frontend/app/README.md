# Green Recycle - Flutter APP

## 环境要求

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / VS Code
- Android SDK / Xcode

## 快速开始

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 运行 APP

```bash
# Android
flutter run

# iOS
flutter run

# 指定设备
flutter devices
flutter run -d <device_id>
```

### 3. 构建发布版本

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 项目结构

```
lib/
├── main.dart              # 入口文件
├── pages/                 # 页面
│   ├── home_page.dart     # 首页
│   ├── orders_page.dart   # 订单页
│   ├── prices_page.dart   # 价格页
│   ├── profile_page.dart  # 个人页
│   └── create_order_page.dart # 创建订单
├── components/            # 组件
├── services/              # 服务
├── models/                # 数据模型
└── utils/                 # 工具类
```

## 功能特性

- ✅ 首页展示
- ✅ 快速下单
- ✅ 订单管理
- ✅ 价格查询
- ✅ 个人中心
- ✅ 微信登录（待配置）

## 配置说明

### 微信登录

1. 在微信开放平台创建应用
2. 获取 AppID 和 AppSecret
3. 配置到 `android/app/build.gradle` 和 `ios/Runner/Info.plist`

### API 配置

编辑 `lib/services/api_service.dart` 配置后端 API 地址

## 常见问题

### Q: 运行失败？

```bash
# 清理缓存
flutter clean
flutter pub get

# 检查 Flutter 环境
flutter doctor
```

### Q: Android 构建失败？

```bash
# 升级 Gradle
cd android
./gradlew wrapper --gradle-version 8.0
```

### Q: iOS 构建失败？

```bash
# 安装 CocoaPods 依赖
cd ios
pod install
```

## 开发规范

- 使用 Dart 格式化代码：`flutter format .`
- 运行代码分析：`flutter analyze`
- 运行测试：`flutter test`

## 发布流程

### Android

1. 修改 `pubspec.yaml` 版本号
2. 构建签名 APK
3. 上传应用商店

### iOS

1. 修改 `pubspec.yaml` 版本号
2. Xcode Archive
3. 上传 App Store Connect

## 许可证

MIT License
