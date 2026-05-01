import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Điều khoản & Chính sách")),
      body: const Padding(padding: EdgeInsets.all(16), child: _PolicyContent()),
    );
  }
}

class _PolicyContent extends StatelessWidget {
  const _PolicyContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📄 Điều khoản & Chính sách sử dụng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          _sectionTitle("1. Giới thiệu"),
          _content(
            "Khi sử dụng ứng dụng, bạn xác nhận đã đọc, hiểu và đồng ý với các điều khoản dưới đây. "
            "Chính sách này nhằm đảm bảo trải nghiệm an toàn, minh bạch và công bằng cho tất cả người dùng.",
          ),

          _sectionTitle("2. Tài khoản người dùng"),
          _bullet("Mỗi tài khoản phải sử dụng email hợp lệ và là duy nhất."),
          _bullet("Bạn chịu trách nhiệm bảo mật thông tin đăng nhập."),
          _bullet("Tài khoản có thể bị khóa nếu vi phạm chính sách."),
          _bullet("Chức năng đặt lại mật khẩu yêu cầu xác thực OTP hợp lệ."),

          _sectionTitle("3. Quan hệ cặp đôi"),
          _bullet("Ứng dụng hiện tại chỉ hỗ trợ ghép đôi giữa Nam và Nữ."),
          _bullet("Mối quan hệ chỉ được tạo khi cả hai bên cùng chấp nhận."),
          _bullet(
            "Mỗi người chỉ có một người yêu hoặc trong 1 cặp đôi tại một thời điểm.",
          ),
          _bullet(
            "Không thể gửi yêu cầu ghép đôi mới khi đang trong một mối quan hệ.",
          ),
          _bullet("Bạn có thể hủy yêu cầu ghép đôi khi chưa được chấp nhận."),
          _bullet("Xóa tài khoản sẽ tự động kết thúc mối quan hệ."),

          _sectionTitle("4. Cá nhân hóa & AI"),
          _bullet(
            "Hệ thống sử dụng MBTI và tâm trạng để phân tích và gợi ý trải nghiệm phù hợp.",
          ),
          _bullet(
            "AI được sử dụng cho: phân tích cảm xúc, gợi ý địa điểm và kiểm duyệt nội dung.",
          ),
          _bullet("Việc xử lý dữ liệu bằng AI chỉ diễn ra khi bạn đã đồng ý."),
          _bullet("Kết quả phân tích chỉ phục vụ cá nhân hóa trong hệ thống."),

          _sectionTitle("5. Tâm trạng & cảm xúc"),
          _bullet(
            "Bạn có thể cập nhật tâm trạng bằng cách chọn thủ công hoặc chụp ảnh.",
          ),
          _bullet("Hệ thống sử dụng trạng thái gần nhất để xác định mood."),
          _bullet(
            "Mood của cặp đôi được xác định bằng cách kết hợp mood của hai người.",
          ),
          _bullet(
            "Ảnh tải lên phải là jpg, jpeg hoặc png và không vượt quá 10MB.",
          ),
          _bullet("Dữ liệu cảm xúc được lưu dưới dạng nhật ký riêng tư."),

          _sectionTitle("6. Quyền riêng tư & dữ liệu"),
          _bullet("Dữ liệu cá nhân chỉ được sử dụng khi có sự đồng ý của bạn."),
          _bullet(
            "Thông tin chỉ được sử dụng cho mục đích cá nhân hóa và cải thiện hệ thống.",
          ),
          _bullet(
            "Hệ thống không chia sẻ dữ liệu ra bên ngoài khi chưa có sự cho phép.",
          ),
          _bullet(
            "Vị trí chỉ được chia sẻ khi cả hai trong cặp đôi cùng đồng ý.",
          ),
          _bullet("AI chỉ xử lý dữ liệu khi bạn đã cấp quyền rõ ràng."),

          _sectionTitle("7. Nội dung người dùng"),
          _bullet("Bạn chịu trách nhiệm với nội dung mình đăng tải."),
          _bullet("Hệ thống có thể ẩn hoặc xóa nội dung vi phạm."),
          _bullet("AI có thể được sử dụng để kiểm duyệt nội dung."),
          _bullet("Mỗi bài đăng tối đa 4 hình ảnh."),
          _bullet("Bình luận có giới hạn độ sâu để tránh spam."),
          _bullet("Bạn chỉ có thể chỉnh sửa hoặc xóa nội dung của mình."),

          _sectionTitle("8. Địa điểm & đánh giá"),
          _bullet("Chỉ có thể tương tác với địa điểm đang hoạt động."),
          _bullet("Chỉ được đánh giá khi đã check-in hợp lệ."),
          _bullet("Mỗi địa điểm chỉ được đánh giá một lần."),
          _bullet("Không thể đánh giá nếu nội dung đang chờ kiểm duyệt."),
          _bullet("Hệ thống có thể ưu tiên hiển thị địa điểm có đánh giá tốt."),

          _sectionTitle("9. Check-in & vị trí"),
          _bullet("Chỉ được check-in tại địa điểm hợp lệ và đang hoạt động."),
          _bullet("Bạn phải ở trong phạm vi cho phép (khoảng cách giới hạn)."),
          _bullet("Không thể check-in liên tục trong thời gian ngắn."),
          _bullet(
            "Dữ liệu check-in được dùng để xác minh và gợi ý trải nghiệm.",
          ),

          _sectionTitle("10. Voucher & giao dịch"),
          _bullet("Mỗi voucher chỉ sử dụng một lần và có thời hạn cụ thể."),
          _bullet("Voucher hết hạn sẽ không thể sử dụng."),
          _bullet("Chỉ có thể sử dụng voucher tại địa điểm hợp lệ."),
          _bullet("Giao dịch có thể bị từ chối nếu không hợp lệ."),
          _bullet("Điểm chỉ có thể sử dụng khi đủ số dư."),
          _bullet("Một số giao dịch cần thời gian xử lý."),
          _bullet("Hoàn tiền tuân theo chính sách của hệ thống."),

          _sectionTitle("11. Ví & thanh toán"),
          _bullet("Bạn có thể nạp tiền và quy đổi thành điểm."),
          _bullet("Số tiền nạp phải nằm trong giới hạn cho phép."),
          _bullet("Rút tiền được xử lý thủ công bởi hệ thống."),
          _bullet(
            "Các giao dịch quan trọng đều được ghi lại để đảm bảo an toàn.",
          ),

          _sectionTitle("12. Gói dịch vụ"),
          _bullet("Một số tính năng yêu cầu gói dịch vụ trả phí."),
          _bullet("Người dùng miễn phí sẽ bị giới hạn một số chức năng."),
          _bullet("Một số tính năng chỉ hoạt động khi bạn đã ghép đôi."),

          _sectionTitle("13. Địa điểm & nhà cung cấp"),
          _bullet("Người dùng có thể đăng ký địa điểm nhưng cần được duyệt."),
          _bullet("Thông tin địa điểm phải đầy đủ và hợp lệ."),
          _bullet("Một số nội dung cần xác minh danh tính trước khi gửi."),
          _bullet("Địa điểm không hoạt động sẽ không được hiển thị."),

          _sectionTitle("14. Quảng cáo & gợi ý"),
          _bullet("Quảng cáo có thể được cá nhân hóa theo mood của cặp đôi."),
          _bullet(
            "Hệ thống ưu tiên nội dung phù hợp hơn với trạng thái của bạn.",
          ),
          _bullet("Địa điểm được đề xuất dựa trên hành vi và sở thích."),

          _sectionTitle("15. Hành vi bị cấm"),
          _bullet("Spam hoặc lạm dụng hệ thống."),
          _bullet("Gian lận hoặc khai thác lỗi hệ thống."),
          _bullet("Đăng tải nội dung vi phạm pháp luật."),
          _bullet("Thực hiện giao dịch khi tài khoản bị hạn chế."),

          _sectionTitle("16. Quyền của hệ thống"),
          _bullet("Có quyền kiểm duyệt nội dung."),
          _bullet("Có quyền hạn chế hoặc khóa tài khoản vi phạm."),
          _bullet("Có thể ghi nhận hoạt động để đảm bảo an toàn."),
          _bullet("Có quyền thay đổi cách hiển thị nội dung và đề xuất."),

          _sectionTitle("17. Thay đổi chính sách"),
          _content(
            "Chính sách có thể được cập nhật bất kỳ lúc nào để phù hợp với hệ thống và quy định pháp luật.",
          ),

          _sectionTitle("18. Xác nhận"),
          _bullet("Bạn xác nhận đã đọc và đồng ý với toàn bộ điều khoản."),
          _bullet("Bạn đồng ý cho hệ thống xử lý dữ liệu theo chính sách này."),
          _bullet(
            "Bạn đồng ý cho hệ thống sử dụng AI trong các chức năng đã mô tả.",
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// ==================
/// Helper Widgets
/// ==================

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _content(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
  );
}

Widget _bullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• "),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
        ),
      ],
    ),
  );
}
