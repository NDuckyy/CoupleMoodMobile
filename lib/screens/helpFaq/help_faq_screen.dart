import 'package:flutter/material.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> allFaqs = [
    {
      "q": "CoupleMood là gì?",
      "a":
          "CoupleMood giúp các cặp đôi tìm địa điểm hẹn hò phù hợp với tâm trạng."
    },
    {
      "q": "Ứng dụng xác định tâm trạng như thế nào?",
      "a":
          "Dựa vào lựa chọn của bạn, AI và hành vi trước đó để đưa ra gợi ý."
    },
    {
      "q": "Làm sao để tạo kế hoạch hẹn hò?",
      "a":
          "Chọn mood → địa điểm → thời gian → gửi partner."
    },
    {
      "q": "Có thể chat trong app không?",
      "a":
          "Có, bạn có thể chat riêng với người yêu."
    },
    {
      "q": "Voucher sử dụng như thế nào?",
      "a":
          "Mua trong app và dùng trực tiếp tại địa điểm."
    },
  ];

  List<Map<String, String>> filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    filteredFaqs = allFaqs;
  }

  void _search(String keyword) {
    final query = keyword.toLowerCase();

    setState(() {
      filteredFaqs = allFaqs.where((faq) {
        return faq["q"]!.toLowerCase().contains(query) ||
            faq["a"]!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Trợ giúp & FAQ"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearch(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        onChanged: _search,
        decoration: InputDecoration(
          hintText: "Tìm kiếm...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _search("");
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (filteredFaqs.isEmpty) {
      return const Center(
        child: Text(
          "Không tìm thấy kết quả",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredFaqs.length,
      itemBuilder: (context, index) {
        return FAQItem(
          question: filteredFaqs[index]["q"]!,
          answer: filteredFaqs[index]["a"]!,
        );
      },
    );
  }
}

// ITEM
class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() => isExpanded = !isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                style: TextStyle(color: Colors.grey[700]),
              ),
            )
        ],
      ),
    );
  }
}