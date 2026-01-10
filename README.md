# Flutter `lib/` Folder Structure

Thư mục `lib/` là nơi chứa **toàn bộ code Dart** của ứng dụng Flutter.  
Tài liệu này giải thích **từng thư mục**, **nó dùng để làm gì**, và **ví dụ đơn giản** để người mới cũng hiểu.

---

## Tổng quan cấu trúc

lib/
├─ main.dart
├─ screens/ (hoặc pages/)
├─ widgets/
├─ models/
├─ services/ (hoặc data/)
├─ utils/ (hoặc helpers/)
├─ providers/
└─ themes/

yaml
Sao chép mã

---

## 1. `main.dart`
**Vai trò:**  
Điểm bắt đầu của ứng dụng Flutter.

**Hiểu đơn giản:**  
> App mở lên là chạy file này đầu tiên.

**Ví dụ:**
```dart
void main() {
  runApp(const MyApp());
}
2. screens/ hoặc pages/
Vai trò:
Chứa các màn hình chính (UI) của app.

Hiểu đơn giản:

Đây là các “trang” người dùng nhìn thấy.

Ví dụ cấu trúc:

arduino
Sao chép mã
screens/
├─ auth/
│  └─ login_screen.dart
├─ home/
│  └─ home_screen.dart
Ví dụ code:

dart
Sao chép mã
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Login');
  }
}
3. widgets/
Vai trò:
Chứa các widget tái sử dụng ở nhiều màn hình.

Hiểu đơn giản:

Nút bấm, ô nhập… dùng lại nhiều lần.

Ví dụ cấu trúc:

Sao chép mã
widgets/
├─ primary_button.dart
Ví dụ code:

dart
Sao chép mã
class PrimaryButton extends StatelessWidget {
  final String text;
  const PrimaryButton(this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
    );
  }
}
4. models/
Vai trò:
Chứa các lớp dữ liệu (Model / DTO) để:

Ép kiểu dữ liệu từ API

Chuyển object ↔ JSON

Hiểu đơn giản:

API trả dữ liệu lộn xộn → model gom lại cho dễ dùng.

Ví dụ cấu trúc:

Sao chép mã
models/
├─ user_model.dart
├─ login_request.dart
Ví dụ code:

dart
Sao chép mã
class UserModel {
  final String name;

  UserModel(this.name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json['name']);
  }
}
5. services/ hoặc data/
Vai trò:
Xử lý gọi API, database, local storage.

Hiểu đơn giản:

Đây là người “đi lấy dữ liệu” cho app.

Ví dụ cấu trúc:

Sao chép mã
services/
├─ auth_service.dart
Ví dụ code:

dart
Sao chép mã
class AuthService {
  Future<UserModel> login() async {
    // gọi API ở đây
    return UserModel('Alex');
  }
}
6. providers/ (QUAN TRỌNG)
Vai trò:
Quản lý state (trạng thái) và chia sẻ dữ liệu giữa nhiều màn hình.

Hiểu đơn giản:

Provider là “cục nhớ chung” của app.
Thay đổi ở đây → màn hình tự cập nhật.

Ví dụ cấu trúc:

Sao chép mã
providers/
├─ auth_provider.dart
Ví dụ code:

dart
Sao chép mã
class AuthProvider extends ChangeNotifier {
  String? userName;

  void login() {
    userName = 'Alex';
    notifyListeners();
  }
}
Dùng trong màn hình:

dart
Sao chép mã
final auth = context.watch<AuthProvider>();
Text(auth.userName ?? 'Chưa login');
7. utils/ hoặc helpers/
Vai trò:
Chứa các hàm tiện ích dùng chung.

Hiểu đơn giản:

Hàm dùng đi dùng lại nhiều chỗ.

Ví dụ cấu trúc:

Sao chép mã
utils/
├─ validators.dart
Ví dụ code:

dart
Sao chép mã
bool isValidEmail(String email) {
  return email.contains('@');
}
8. themes/
Vai trò:
Định nghĩa theme, màu sắc, font chữ cho toàn ứng dụng.

Hiểu đơn giản:

Đổi màu 1 lần → cả app đổi theo.

Ví dụ cấu trúc:

Sao chép mã
themes/
├─ app_theme.dart
Ví dụ code:

dart
Sao chép mã
ThemeData appTheme = ThemeData(
  primaryColor: Colors.blue,
);
9. Luồng hoạt động cơ bản
nginx
Sao chép mã
UI (screens)
   ↓
State (providers)
   ↓
Logic (services)
   ↓
API / Database
   ↓
Model (models)
10. Tóm tắt dễ nhớ
css
Sao chép mã
screens   → màn hình
widgets   → UI dùng chung
models    → dữ liệu + ép JSON
services  → gọi API
providers → nhớ & chia sẻ state
utils     → hàm tiện ích
themes    → màu sắc, font
11. Kết luận
Cấu trúc này giúp:

Code rõ ràng, dễ đọc

Dễ học cho người mới

Dễ mở rộng cho project thật

Nguyên tắc quan trọng:

❌ UI không gọi API trực tiếp
✅ UI → Provider → Service → Model

yaml
Sao chép mã

---

Nếu bạn muốn, bước tiếp theo mình có thể:
- Viết **README cho từng feature (auth, home…)**
- Làm **ví dụ login full có Provider**
- Chuẩn hoá README này cho **project thực tế / đi làm**

Bạn chỉ cần nói tiếp 👍