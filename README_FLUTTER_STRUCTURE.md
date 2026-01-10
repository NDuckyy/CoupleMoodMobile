# Flutter Project Structure README

Tài liệu này giải thích cấu trúc thư mục Flutter phổ biến, kèm **ví dụ code cho từng phần**.

---

## lib/

Thư mục chính chứa toàn bộ mã nguồn Dart của ứng dụng.

---

## main.dart
**Chức năng:** Điểm khởi chạy ứng dụng.

```dart
void main() {
  runApp(const MyApp());
}
```

---

## app.dart
**Chức năng:** Khai báo `MaterialApp`, routes và theme.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
```

---

## screens/ (hoặc pages/)
**Chức năng:** Các màn hình chính của app.

### Ví dụ: home_screen.dart
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Hello Flutter')),
    );
  }
}
```

---

## widgets/
**Chức năng:** Widget tái sử dụng.

### Ví dụ: primary_button.dart
```dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(text));
  }
}
```

---

## models/
**Chức năng:** Model dữ liệu.

### Ví dụ: user_model.dart
```dart
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name']);
  }
}
```

---

## services/ (hoặc data/)
**Chức năng:** Làm việc với API, local storage.

### Ví dụ: api_service.dart
```dart
class ApiService {
  Future<String> fetchData() async {
    return 'data from api';
  }
}
```

---

## providers/
**Chức năng:** Quản lý state (Provider/Riverpod).

### Ví dụ: auth_provider.dart
```dart
class AuthProvider extends ChangeNotifier {
  bool isLoggedIn = false;

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }
}
```

---

## utils/
**Chức năng:** Hằng số, helper, validator.

### Ví dụ: validators.dart
```dart
bool isValidEmail(String email) {
  return email.contains('@');
}
```

---

## themes/
**Chức năng:** Theme và màu sắc toàn app.

### Ví dụ: app_colors.dart
```dart
class AppColors {
  static const primary = Color(0xFF2196F3);
}
```

---

## Kết luận
Cấu trúc này:
- Dễ mở rộng
- Dễ bảo trì
- Phù hợp app nhỏ → lớn

Bạn có thể tùy chỉnh theo **feature-based architecture** khi dự án phát triển lớn hơn.
